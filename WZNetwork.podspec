#
# Be sure to run `pod lib lint WZNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WZNetwork'
  s.version          = '4.0.0'
  s.summary          = '我主良缘网络框架'

  s.description      = <<-DESC
深圳我主良缘有限公司，iOS项目组网络组件.
                       DESC

  s.homepage         = 'https://gitlab.com/WZiOS/WZNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxiaobin' => '327847390@qq.com' }
  s.source           = { :git => 'https://gitlab.com/WZiOS/WZNetwork.git', :tag => s.version.to_s }


  s.requires_arc = true
  s.static_framework = true
  s.swift_version         = '5.0'
  s.ios.deployment_target = '10.0'
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'WZNetwork/Classes/'
    ss.dependency "Moya", "~> 15.0.0-alpha.1"
    ss.dependency "Moya/RxSwift", "~> 15.0.0-alpha.1"
    ss.dependency "DeviceKit", "~> 3.2.0"
  end
  
end
