ROOT_DIR = File.dirname(__FILE__)

require 'rubygems'
gem 'bundler'
require 'bundler'
require 'ripple'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

namespace(:test) do
  desc "Test everything"
  task :all => [:test] + Dir["vendor/*"].map { |d| "test:#{File.basename(d)}" }

  Dir["vendor/*"].each do |vendor_dir|
    vendor = File.basename(vendor_dir)
    Rake::TestTask.new(vendor) do |test|
      test.libs << vendor_dir + '/lib'
      test.libs << vendor_dir + '/test'
      test.pattern = vendor_dir + '/test/**/test_*.rb'
      test.verbose = true
    end
  end
end

task :default => :test

namespace(:example) do
  100.times do |time|
    task("create_data_points_#{time}".to_sym) do
      require File.join(ROOT_DIR,'lib','riak_rolling_average')

      data = File.readlines(File.join(ROOT_DIR,'test','data'))[time]
      count = 0
      data.split(',').each do |value|
        DataPointDocument.create(:value => value.to_i)
        count += 1
      end
      puts count.to_s
    end
  end
end
