Pod::Spec.new do |spec|
  spec.name         = "Split Suite"
  spec.version      = "1.0.1-rc1"
  spec.summary      = "iOS Suite for Split"
  spec.description  = <<-DESC
  iOS Suite provides the all-encompassing essential programming interface for working with your Split feature flags, as well as capabilities for automatically tracking performance measurements and user events.
                   DESC

  spec.homepage         = 'http://www.split.io'
  spec.license          = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.author             = "Split Software"
  spec.platform     = :ios, "12.0"
  spec.source       = { :http => "https://cdn.split.io/ios-suite/iOSSplitSuite_1.0.1-rc2.zip" }
  spec.vendored_frameworks = "SplitRumAgent.xcframework"
end
