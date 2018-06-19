Pod::Spec.new do |s|
  s.name         = "Toast"
  s.version      = "0.0.1"
  s.summary      = "The toast to show human readable message."
  s.description  = <<-DESC
                   The toast to show human readable message on iOS platform.
                   DESC

  s.homepage     = "https://github.com/devedbox/Toast"
  s.license      = "MIT"
  s.author             = { "devedbox" => "devedbox@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/devedbox/Toast.git", :tag => "#{s.version}" }

  s.source_files  = "Sources", "Sources/**/*.{swift}"

  s.frameworks = "Foundation", "UIKit", "CoreGraphics"

  s.requires_arc = true

  s.swift_version = '4.1'
end
