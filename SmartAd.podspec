#
# Be sure to run `pod lib lint SmartAd.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartAd'
  s.version          = '0.1.0'
  s.summary          = 'SmartAd.'
  s.description      = <<-DESC
Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ShockUtility/SmartAd'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ShockUtility' => 'shock@docs.kr' }
  s.source           = { :git => 'https://github.com/ShockUtility/SmartAd.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'SmartAd/Classes/**/*'
  s.resource_bundles = {
      'SmartAd' => ['SmartAd/Classes/**/*.{storyboard,xib,png}']
  }

  s.static_framework = true
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Messaging'
  s.dependency 'Firebase/AdMob'
  s.dependency 'FBAudienceNetwork'
end
