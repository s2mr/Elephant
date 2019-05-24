Pod::Spec.new do |s|
  s.name             = 'Elephant'
  s.swift_version    = '5.0'
  s.version          = '0.1.0'
  s.summary          = 'SVG animation kit for iOS'
  s.description      = <<-DESC
You can display the elegant svg animation in app.
                       DESC
  s.homepage         = 'https://github.com/kzumu/Elephant'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kazumasa Shimomura' => 'kazu.devapp@gmail.com' }
  s.source           = { :git => 'https://github.com/kzumu/Elephant.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kazuringo5'
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'UIKit', 'WebKit'
end
