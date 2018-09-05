#
# Be sure to run `pod lib lint GICXMLLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GICXMLLayout'
  s.version          = '0.2.2'
  s.summary          = 'A short description of GICXMLLayout.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/ghwghw4/GICXMLLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ghwghw4' => 'dagehaoshuang@163.com' }
  s.source           = { :git => 'https://github.com/ghwghw4/GICXMLLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'


  
  # s.resource_bundles = {
  #   'GICXMLLayout' => ['GICXMLLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

        s.subspec 'Core' do |core|
            core.source_files = 'GICXMLLayout/Classes/Core/**/*'
            core.prefix_header_file = 'GICXMLLayout/Classes/Core/XMLLayoutPrefixHeader.pch'
            core.dependency 'GDataXMLNode_GIC'
            core.dependency 'GICJsonParser'
            core.dependency 'ReactiveObjC'
            core.dependency 'Texture'
            core.dependency 'pop'
            core.frameworks = 'JavaScriptCore'
            core.libraries = 'xml2'
            core.xcconfig = { 'HEADER_SEARCH_PATHS' => '${SDK_DIR}/usr/include/libxml2' }
        end

        s.subspec 'Router' do |router|
            router.source_files = 'GICXMLLayout/Classes/Router/**/*'
            router.dependency 'GICXMLLayout/Core'
        end
end
