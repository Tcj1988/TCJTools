#
# Be sure to run `pod lib lint TCJTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCJTools'
  s.version          = '0.0.4'
  s.summary          = 'A short description of TCJTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Tcj1988/TCJTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '310537065@qq.com' => '310537065@qq.com' }
  s.source           = { :git => 'https://github.com/Tcj1988/TCJTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  #s.source_files = 'TCJTools/Classes/**/*'
  s.subspec 'TCJUtils' do |st|
    st.source_files = "TCJTools/TCJUtils/**/*.{h,m}"
  end
  
  s.subspec 'TCJNetWorking' do |st|
    st.source_files = "TCJTools/TCJNetWorking/**/*.{h,m}"
  end
  
  s.subspec 'TCJCategory' do |st|
    st.source_files = "TCJTools/TCJCategory/**/*.{h,m}"
  end
  
  s.subspec 'TCJTimeCountDown' do |st|
    st.source_files = "TCJTools/TCJTimeCountDown/**/*.{h,m}"
    st.resource_bundles = {
      'TCJTools' => ['TCJTools/TCJTimeCountDown/**/*']
    }
  end
  
  # s.resource_bundles = {
  #   'TCJTools' => ['TCJTools/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking', '~> 4.0.1'
end
