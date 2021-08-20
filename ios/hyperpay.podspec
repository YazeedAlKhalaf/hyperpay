#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hyperpay.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hyperpay'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin that wraps the official SDK of hyperpay.'
  s.description      = <<-DESC
A Flutter plugin that wraps the official SDK of hyperpay.
                       DESC
  s.homepage         = 'https://github.com/YazeedAlKhalaf/hyperpay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yazeed AlKhalaf' => 'yazeedfady@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  s.vendored_frameworks = 'OPPWAMobile.framework'
  s.resource_bundles = {
    'OPPWAMobile' => ['OPPWAMobile-Resources.bundle']
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
