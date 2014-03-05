# WLANAudit Rakefile
# ==================
# Author: Roberto Estrada Casarrubios

require 'rubygems'
require 'rake'

task :default => [:dep_setup]

task :dep_setup do
  sh "rm -rf Pods/"
  puts 'Setting up dependencies...'  
  sh "pod install"
  puts 'Dependencies set up'
end

task :update_translations do
  sh "python Tools/update_strings.py WLANAudit/en.lproj/Localizable.strings WLANAudit"
end