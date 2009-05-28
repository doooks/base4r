require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

spec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "base4r"
    s.homepage  =   "http://code.google.com/p/base4r"
    s.version   =   "0.2"
    s.author    =   "Dan Dukeson"
    s.email     =   "dandukeson@gmail.com"
    s.summary   =   "Ruby client for the Google Base API"
    s.files     =   FileList['lib/*.rb', 'test/*.rb', 'cert/cacert.pem', 'LICENSE'].to_a
    s.require_path  =   "lib"
    s.autorequire   =   "base4r"
    s.test_files = Dir.glob('test/*.rb')
    s.has_rdoc  =   true
    s.extra_rdoc_files  =   ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

desc "Run tests"
Rake::TestTask.new("test") { |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = true
}

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
