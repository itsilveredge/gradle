require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
ruby_version = RbConfig::CONFIG["ruby_version"]
path = File.expand_path('..', __FILE__)
$:.unshift File.expand_path("#{path}/../gems/rake-10.3.2/lib")
$:.unshift File.expand_path("#{path}/../gems/diff-lcs-1.2.5/lib")
$:.unshift File.expand_path("#{path}/../gems/json-1.7.5-java/lib")
$:.unshift File.expand_path("#{path}/../gems/slop-3.0.4/lib")
$:.unshift File.expand_path("#{path}/../gems/jenkins-plugin-runtime-0.2.3/lib")
$:.unshift File.expand_path("#{path}/../gems/rack-1.4.1/lib")
$:.unshift File.expand_path("#{path}/../gems/rack-protection-1.2.0/lib")
$:.unshift File.expand_path("#{path}/../gems/rspec-support-3.0.2/lib")
$:.unshift File.expand_path("#{path}/../gems/rspec-core-3.0.2/lib")
$:.unshift File.expand_path("#{path}/../gems/rspec-expectations-3.0.2/lib")
$:.unshift File.expand_path("#{path}/../gems/rspec-mocks-3.0.2/lib")
$:.unshift File.expand_path("#{path}/../gems/rspec-3.0.0/lib")
$:.unshift File.expand_path("#{path}/../gems/tilt-1.3.3/lib")
$:.unshift File.expand_path("#{path}/../gems/sinatra-1.3.3/lib")
