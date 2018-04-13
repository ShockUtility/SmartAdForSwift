#
# Be sure to run `pod lib lint SmartAd.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartAd'
  s.version          = '0.1.1'
  s.summary          = 'SmartAd is an easy-to-use library for Google AdMob and Facebook advertising frameworks.'
  s.description      = <<-DESC
SmartAd is an easy-to-use library for AdMob and Audience Network advertising frameworks on iOS and Android.
                       DESC

  s.homepage         = 'https://github.com/ShockUtility/SmartAdForSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ShockUtility' => 'shock@docs.kr' }
  s.source           = { :git => 'https://github.com/ShockUtility/SmartAdForSwift.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'SmartAd/Classes/**/*'
  s.resource_bundles = {
      'SmartAd' => ['SmartAd/Classes/**/*.{storyboard,xib,png}']
  }

  s.static_framework = true
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/AdMob'
  s.dependency 'FBAudienceNetwork'
end

# 새로운 버전 생성 후 github.com 에서 릴리스 버전 생성하고 다음의 커맨드로 배포해야된다
# pod trunk push SmartAd.podspec --verbose           --allow-warnings
