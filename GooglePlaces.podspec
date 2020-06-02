Pod::Spec.new do |spec|
  spec.name         = "GooglePlaces"
  spec.version      = "1.1"
  spec.summary      = "GooglePlaces API wrapper for iOS."
  spec.description  = "Custom client for GooglePlaces API, to be used with Ono iOS apps."
  spec.homepage     = "https"//git@github.com:ono-ono/ono-ios-frameworks-googleplaces"
  spec.license      = { :type => "Commercial" }
  spec.author             = { "Igor Tabački" => "Igor_tilt@yahoo.com" }

  spec.source       = { :path => '.' }
  spec.source_files  = ["GooglePlaces/**/*.swift", "Vendor/**/*.swift", "GooglePlaces/*.lproj/*.strings"]
  spec.swift_versions = ['5.0']

  spec.ios.deployment_target = "11.0"
  # spec.osx.deployment_target = "10.10"
  # spec.watchos.deployment_target = "5.0"
  # spec.tvos.deployment_target = "12.0"
end
