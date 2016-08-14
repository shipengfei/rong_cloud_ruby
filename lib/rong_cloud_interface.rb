require "rong_cloud_interface/client"
require "rong_cloud_interface/message_type"
require "rong_cloud_interface/version"

module RongCloudInterface

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :server_api_url
    config_accessor :app_key
    config_accessor :app_secret
    config_accessor :format
  end

  def self.configure(&block)
    yield @config ||= Configuration.new
  end
    
  def self.config
    @config
  end

  configure do |config|
    config.server_api_url = "http://api.cn.ronghub.com"
    config.app_key = "82hegw5uhh24x"
    config.app_secret = "EZPyXbN261"  
    config.format = :json
  end
end
