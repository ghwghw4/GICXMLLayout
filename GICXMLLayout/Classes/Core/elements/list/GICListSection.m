//
//  GICListSection.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/28.
//

#import "GICListSection.h"
#import "GICStringConverter.h"

@implementation GICListSection{
    __weak id<GICListSectionProtocol> _owner;
//    NSOperationQueue *insertItemsQueue;
    NSMutableArray *insertedItems;
    
}
+(NSString *)gic_elementName{
    return @"section";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListSection *item = (GICListSection *)target;
                 item->_title = value;
             } withGetter:^id(id target) {
                 GICListSection *item = (GICListSection *)target;
                 return item.title;
             }]
             };
}

-(id)initWithOwner:(id<GICListSectionProtocol>)owner withSectionIndex:(NSInteger)sectionIndex{
    self = [super init];
    _owner = owner;
    _items = [NSMutableArray array];
    _sectionIndex = sectionIndex;
    insertedItems = [NSMutableArray array];
//    insertItemsQueue = [NSOperationQueue mainQueue];
    
    return self;
}

-(NSArray *)gic_subElements{
    NSMutableArray *elments = [self.items mutableCopy];
    if(self.header){
        [elments addObject:self.header];
    }
    if(self.footer){
        [elments addObject:self.footer];
    }
    return elments;
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [subElement gic_ExtensionProperties].superElement = self;
        [_owner onItemAddedInSection:@{@"item":subElement,@"section":@(self.sectionIndex)}];
        return subElement;
    }
    else if ([subElement isKindOfClass:[GICListHeader class]]){
        _header = subElement;
        return subElement;
    }else if ([subElement isKindOfClass:[GICListFooter class]]){
        _footer = subElement;
        return subElement;
    }
    else{
        return [super gic_willAddAndPrepareSubElement:subElement];
    }
}


// 插入item 需要做特殊处理
-(id)gic_insertSubElement:(id)subElement atIndex:(NSInteger)index{
    if([subElement isKindOfClass:[GICListItem class]]){
        [subElement gic_ExtensionProperties].superElement = self;
        [insertedItems addObject:@{@"item":subElement,@"index":@(index)}];
        // TODO:这里可能会出现线程问题。
        if(insertedItems.count ==1){
            [self dealInsert];
        }
    }
    return nil;
}


-(void)dealInsert{
    if(insertedItems.count>0){
        NSDictionary *item = [insertedItems firstObject];
        NSInteger index = [item[@"index"] integerValue];
        [self.items insertObject:item[@"item"] atIndex:index];
        [_owner insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]]];
        [_owner onDidFinishProcessingUpdates:^{
            [self->insertedItems removeObject:item];
            // 这个方法的的递归调用是在主线程中调用的，因此也不存在 insertedItems 的线程安全问题
            [self dealInsert];
        }];
    }
    
}

-(void)gic_removeSubElements:(NSArray<GICListItem *> *)subElements{
    [super gic_removeSubElements:subElements];
    if(subElements.count==0)
        return;
    // TODO:临时解决方案。目前的解决方案还是有隐患的/
    /**
     问题描述:
     首先GIC为了优化list的加载速度，采用了类似RX中的buffer 技术。也就是不管数据源有多少数据，每次加载数据都是通过insertItemsSubscriber 来发送next 消息，然后使用RAC提供的buffer方法来实现，一个大概0.1秒的时间窗口，也就是说在0.1秒内所有插入的数据都会一并打包到0.1秒超时后一并处理。之所以要这样处理，是因为，当一次性加载过多数据的时候，虽然UI不会在屏幕上显示，但是UI的视图结构都会一并解析到内存中，而这些视图最终都会被添加到UITableView中，而对于UITableView的操作必须是在UI线程处理的，因此这时候如果数据一多，就会出现明显的卡顿。
     而采用了buffer 方式后，每次只会加载 RACWindowCount 条数据，这样就会显著的提高首屏数据的显示，当首屏加载完后继续加载剩余的数据，但是保持每次加载RACWindowCount 条数据，这样对于用户来说，即不会看到明显的卡顿，而且不会意识到系统在继续加载剩余的数据，这个过程事实上当用户在加载的时候快速滑动屏幕的时候是能明显看到的，但是就算用户看到了系统在继续加载剩余数据(现象就是出现明显的cell占位图以及滑到底的时候又出现新的cell)，但是也不会出现卡顿的现象，因为对于UI线程来说，每次处理RACWindowCount 条数据，并不会导致UI线程堵塞。
     
     然而这样的处理方式又带来一个缺点，就是当数据源切换过快。比如：当第一批的数据还没有全部加载完毕的时候，就出现新的数据源，也即是两个不同的array 分批作为数据源，这时后如果不管三七二十一直接reload或者delete数据的话，就会出现ASD中的处理线程死锁。下面的处理方式是等在处理完毕再处理新的数据，虽然不会出现线程死锁，但是又出现新的问题，那就是数据混乱，也就是前一批的数据因为还没来得及插入，而又来了一批全新的数据，对于新的数据来说，前面的数据是不应该存在的，但是因为现在的处理方式仅仅是等在每次RACWindowCount条数据处理完毕后再去加载新的数据，因此对于第一批的剩余数据来说就是漏网之鱼了。
     
     好在这样的情况不常见，后续考虑其他方法来避免。
     */
    [self->_owner onDidFinishProcessingUpdates:^{
        NSMutableArray *mutArray=[NSMutableArray array];
        for(id subElement in subElements){
            if([subElement isKindOfClass:[GICListItem class]]){
                [mutArray addObject:[NSIndexPath indexPathForRow:[self->_items indexOfObject:subElement] inSection:self.sectionIndex]];
            }
        }
        [self->_items removeObjectsInArray:subElements];
        if(self.items.count==0){
            NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
            [idxSet addIndex:self.sectionIndex];
            [self->_owner reloadSections:idxSet];
        }else{
            [self->_owner deleteItemsAtIndexPaths:mutArray];
        }
    }];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    NSString *elName = [element name];
    if([elName isEqualToString:[GICListHeader gic_elementName]]){
        return  [GICListHeader new];
    }else if([elName isEqualToString:[GICListFooter gic_elementName]]){
        return  [GICListFooter new];
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
