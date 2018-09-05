# image

`image`其实就是`UIImageView`,支持加载网络图片，也支持本地图片。

## 属性

| 名称       | 数据类型      | 介绍                                                 | 是否支持绑定 | 是否支持动画 |
| ---------- | ------------- | ---------------------------------------------------- | ------------ | ------------ |
| url        | string        | 网络图片url。**支持gif图片**                         | 是           | 否           |
| placehold  | string        | 在加载网络图片的时候显示的默认图片，必须是本地图片。 | 是           | 否           |
| local-name | string        | 显示本地图片                                         | 是           | 否           |
| fill-mode  | Integer(枚举) | 就是uiview 的contentmode 属性。默认2                 | 是           | 是           |

### fill-mode

| 枚举值  | 对应枚举                             | 说明         |
| ---- | -------------------------------- | ---------- |
| 0    | UIViewContentModeScaleToFill     | 不解释 |
| 1    | UIViewContentModeScaleAspectFit  |            |
| 2    | UIViewContentModeScaleAspectFill |            |
| 3    | UIViewContentModeRedraw          |            |
| 4    | UIViewContentModeCenter          |            |
| 5    | UIViewContentModeTop             |            |
| 6    | UIViewContentModeBottom          |            |
| 7    | UIViewContentModeLeft            |            |
| 8    | UIViewContentModeRight           |            |
| 9    | UIViewContentModeTopLeft         |            |
| 10   | UIViewContentModeTopRight        |            |
| 11   | UIViewContentModeBottomLeft      |            |
| 12   | UIViewContentModeBottomRight     | 不解释        |

