#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint iap.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'huawei_iap'
  s.version          = '5.0.0'
  s.summary          = 'Huawei HMS Flutter IAP Plugin.'
  s.description      = <<-DESC
Huawei HMS Flutter IAP Plugin.
                       DESC
  s.homepage         = 'https://www.huawei.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Huawei' => 'huawei@huawei.com' }
  s.source           = { :git => 'https://github.com/frsisalima/hms-flutter-plugin.git' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.author           = { 'Huawei HMS' => 'flutter-dev@googlegroups.com' }

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
