require "rubygems"
require "bundler/setup"
require 'base64'

Bundler.require(:default)

AppRoot = "#{File.dirname(__FILE__)}/.."

Dir["#{AppRoot}/vendor/**/*.rb"].each { |f| load(f) }
Dir["#{AppRoot}/lib/**/*.rb"].each { |f| load(f) }
Config = YAML.load_file("#{AppRoot}/config/config.yml")

CloudVision = Google::Apis::VisionV1::VisionService.new
CloudVision.key = Config["google"]["api_key"]
