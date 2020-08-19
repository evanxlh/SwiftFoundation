#
#  Be sure to run `pod spec lint SwiftFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SwiftFoundation"
  spec.version      = "0.0.2"
  spec.summary      = "SwiftFoundation, speed up your development using Swift."
  spec.description  = <<-DESC
  	A swift foundation toolkit for apple multiple platforms, which help you speed up sdk or app development.
                   DESC

  spec.homepage     = "https://github.com/evanxlh/SwiftFoundation"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Evan Xie" => "evanxie.mr@foxmail.com" }
  spec.social_media_url   = "https://evanxlh.gitee.io/Blog/"

  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "10.0"

  spec.source       = { :git => "https://github.com/evanxlh/SwiftFoundation.git", :tag => "#{spec.version}" }

  spec.source_files  = "Source/*.{h, swift}", "Source/**/*.{h,swift}"
  spec.swift_versions = "5.0"
  spec.requires_arc = true

end
