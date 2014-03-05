platform :ios, :deployment_target => "7.0"
workspace 'WLANAudit'

xcodeproj 'WLANAudit.xcodeproj'

target :wlanaudit do
  xcodeproj 'WLANAudit.xcodeproj'
  pod 'MagicalRecord'
  pod 'QuickDialog', '~> 0.9.1'
  pod 'libKeygen', :path => "../libKeygen"
  
  post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-WLANAudit-acknowledgements.plist', 'WLANAudit/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    FileUtils.cp_r('../libKeygen', 'Pods/libKeygen')
  end
end