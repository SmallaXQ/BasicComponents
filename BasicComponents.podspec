#
# Be sure to run `pod lib lint BasicComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BasicComponents'
  s.version          = '1.0.0'
  s.summary          = '基础组件库，包含设备基本信息、基础工具类、版本比较类、缓存管理类、Plist工具类、正则校验类、常用类拓展、定时器类'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
基础组件库，包含机型判断、屏幕判断、iPhoneX系列机型判断、 按比例适配宽高，以750*1334为基准、系统其他常量定义；基础工具类BasicTool、版本比较类VersionManager、缓存管理类CacheManager、Plist工具类、ValidateTool正则校验工具；常用类拓展：Array+Extension、CGSize+Extension、Date+Extension、Float+Extension、NSObject+Extension、String+Extension、UIColor+Extension、UIImage+Extension、UIImageView+Extension、UILabel+Extension、UITextField+Extension、UIView+Extension；定时器类。
                       DESC

  s.homepage         = 'https://github.com/SmallaXQ/BasicComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SmallaXQ' => 'smallaxq@gmail.com' }
  s.source           = { :git => 'https://github.com/SmallaXQ/BasicComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = '5.0'

  s.source_files = 'BasicComponents/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BasicComponents' => ['BasicComponents/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'FCUUID', '~> 1.3.1'
  s.dependency 'Toast', '~> 4.0.0'
  s.dependency 'SDWebImage', '~> 5.8.4'
  s.dependency 'UICKeyChainStore', '~> 2.1.2'
end
