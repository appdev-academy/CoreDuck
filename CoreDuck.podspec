Pod::Spec.new do |s|
  s.name             = "CoreDuck"
  s.version          = "1.2.3"
  s.summary          = "Small and fast CoreData stack written in Swift"
  s.homepage         = "https://github.com/appdev-academy/CoreDuck"
  s.license          = 'MIT'
  s.authors          = { "Maksym Skliarov" => "maksym@appdev.academy",
                         "Yura Voevodin" => "yura@appdev.academy" }
  s.source           = { :git => "https://github.com/appdev-academy/CoreDuck.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AppDev_Academy'
  
  s.ios.deployment_target = '12.1'
  s.osx.deployment_target = '10.12'
  
  s.framework = 'CoreData'
  s.ios.framework = 'UIKit'
  s.osx.framework = 'AppKit'
  
  s.swift_version = '5.3'
  
  s.source_files = 'CoreDuck/Classes/**/*'
  s.requires_arc = true
end
