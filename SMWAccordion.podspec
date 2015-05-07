#
# Be sure to run `pod lib lint SMWAccordion.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SMWAccordion"
  s.version          = "1.0.2"
  s.summary          = "An accordion for iOS that subclasses UITableView."
  s.description      = <<-DESC
  					   SMWAccordion is an Objective-C accordion library for iOS.
                       The SMWAccordionView can be treated just like a UITableView, with a few extra datasource and delegate methods to make the accordion part work.
                       DESC
  s.homepage         = "https://github.com/meech-ward/SMWAccordion"
  s.screenshots      = "http://www.sammeechward.com/assets/SMWAccordion/preview.gif"
  s.license          = 'MIT'
  s.author           = { "Sam Meech-Ward" => "sam@meech-ward.com" }
  s.source           = { :git => "https://github.com/meech-ward/SMWAccordion.git", :tag => s.version.to_s }
  s.documentation_url = 'http://www.sammeechward.com/library/ios/documentation/SMWAccordion/'
  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'SMWAccordion'
  #s.resource_bundles = {
  #  'SMWAccordion' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
