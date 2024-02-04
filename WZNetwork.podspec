
Pod::Spec.new do |s|
  s.name             = 'WZNetwork'
  s.version          = '6.2.0'
  s.summary          = '我主良缘网络框架'

  s.description      = <<-DESC
深圳我主良缘有限公司，iOS项目组网络组件.
                       DESC

  s.homepage         = 'https://github.com/WZLYiOS/WZNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxiaobin' => '327847390@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZNetwork.git', :tag => s.version.to_s }


  s.requires_arc = true
  s.static_framework = true
  s.swift_version         = '5.0'
  s.ios.deployment_target = '13.0'
#  s.default_subspec = 'Core'
  
 
  
  s.subspec 'Moya' do |ss|
    ss.source_files = 'WZNetwork/Classes/Moya'
    ss.dependency "Moya/RxSwift", "~> 15.0.0"
    ss.dependency 'WZNetwork/Cache'
  end
  
  s.subspec 'AF' do |ss|
    ss.source_files = 'WZNetwork/Classes/AF'
    ss.dependency 'WZNetwork/Cache'
  end
  
  s.subspec 'Cache' do |ss|
    ss.source_files = 'WZNetwork/Classes/Cache'
    ss.dependency 'Cache', '~> 6.0.0'
  end
  
  
  
end
