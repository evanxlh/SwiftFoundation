Pod::Spec.new do |spec|
  spec.name         = "SwiftFoundation"
  spec.version      = "0.0.3"
  spec.summary      = "SwiftFoundation, speed up your development using Swift."
  spec.homepage     = "https://github.com/evanxlh/SwiftFoundation"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Evan Xie" => "evanxie.mr@foxmail.com" }
  spec.social_media_url   = "https://evanxlh.github.io"

  spec.swift_versions = "5.0"
  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "10.0"

  spec.source       = { :git => "https://github.com/evanxlh/SwiftFoundation.git", :tag => "#{spec.version}" }
  spec.source_files  = "Source/*.{h, swift}", "Source/**/*.{h,swift}"

end
