#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = "TMUIKit"
	s.version          = "1.0.2"
	s.summary          = "常用UI库"

	s.description      = "常用UI库 - 支持弹框，下划线，图片按钮，侧滑菜单等。"
	s.homepage         = "https://github.com/Tovema-iOS/TMUIKit"
	s.license          = 'MIT'
    s.author           = { 'CodingPub' => 'lxb_0605@qq.com' }
	s.source           = { :git => "https://github.com/Tovema-iOS/TMUIKit.git", :tag => s.version.to_s }

	s.platform     = :ios, '8.0'
	s.requires_arc = true

    s.source_files = 'Pod/TMUIKit/**/*'
    s.resource_bundles = {
        'TMUIKit' => ['Pod/Assets/*']
    }

    s.dependency 'TMLogger', '~> 1.0'
    s.dependency 'TMUtility', '~> 1.0'
    s.dependency 'TMCategories', '~> 1.0'
    s.dependency 'Masonry', '~> 1.1'
end
