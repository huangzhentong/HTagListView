
Pod::Spec.new do |s|

 
  s.name         = "HTagListView"
  s.version      = "0.0.1"
  s.summary      = "A short description of HTagListView."

 
  s.homepage     = "https://github.com/huangzhentong/HTagListView"
 
  
   s.license      = { :type => "MIT", :file => "LICENSE" }


 
  s.author             = { "huang" => "181310067@qq.com" }
  # Or just: s.author    = "huang"
  # s.authors            = { "huang" => "181310067@qq.com" }
  # s.social_media_url   = "http://twitter.com/huang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"




  s.source       = { :git => "https://github.com/huangzhentong/HTagListView.git", :tag => "#{s.version}" }


 
  s.source_files  = "HTagListView"
 

  # s.public_header_files = "Classes/**/*.h"


  

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
