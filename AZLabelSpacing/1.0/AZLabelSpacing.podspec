Pod::Spec.new do |s|
  s.name     = 'AZLabelSpacing'
  s.version  = '1.0'
  s.ios.deployment_target   = '8.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Easy change character spacing in UILabel'
  s.homepage = 'https://github.com/azimin/AZLabelCharecterSpacing'
  s.author   = { 'Alex Zimin' => 'azimin@me.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/azimin/AZLabelCharecterSpacing.git',
    :branch => 'master',
    :tag => s.version.to_s
#:tag => s.version
  }
  s.source_files  = 'LabelSpacing/*.{h,m}'
  s.requires_arc = true
end