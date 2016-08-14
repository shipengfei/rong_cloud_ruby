require "digest"

module RongCloudInterface
  # 调用 /user/getToken
  # RongCloudInterface::Client.rc_user_gettoken({"userId" => 1, "name" => "八戒", "portraitUri" => ""})
  # 返回结果 {"code"=>200,"userId"=>"1","token"=>"BYEcj8+ZuI2j1il2Ct95wGsZIWqFz4yhisrG9lYZbbfRLs6ZDhjuMPFizILWp0eYqo53/dBq+DDmw5Ueleu0Rw=="}
  # =======================================
  # 调用 /chatroom/create
  # 例如：RongCloudInterface::Client.rc_chatroom_create({"chatroom[3]" => "南山大佛"})
  # 返回结果 {"code"=>200}
  # =======================================
  # 调用 /chatroom/user/gag/add 
  # RongCloudInterface::Client.rc_chatroom_user_gag_add({"userId" => 1, "chatroomId" => 3, "minute" => 300})
  # 返回结果 {"code"=>200}
  class Client
    urls = %w(
      /user/getToken
      /user/refresh 
      /user/checkOnline 
      /user/block
      /user/unblock
      /user/block/query
      /user/blacklist/add
      /user/blacklist/remove
      /user/blacklist/query
      /message/private/publish
      /message/private/publish_template
      /message/system/publish
      /message/system/publish_template
      /message/group/publish
      /message/discussion/publish
      /message/chatroom/publish
      /message/broadcast
      /wordfilter/add
      /wordfilter/delete
      /wordfilter/list
      /message/history
      /message/history/delete
      /group/sync
      /group/create
      /group/join
      /group/quit
      /group/dismiss
      /group/refresh
      /group/user/query
      /group/user/gag/add
      /group/user/gag/rollback
      /group/user/gag/list
      /chatroom/create 
      /chatroom/join
      /chatroom/destroy 
      /chatroom/query 
      /chatroom/user/query 
      /chatroom/user/gag/add 
      /chatroom/user/gag/rollback
      /chatroom/user/gag/list
      /chatroom/user/block/add
      /chatroom/user/block/rollback
      /chatroom/user/block/list
      /chatroom/message/stopDistribution
      /chatroom/message/resumeDistribution
    )
    urls.each do |url|
      method_name = "rc"+url.gsub("/","_").downcase
      Client.instance_eval <<-EOF
        def #{method_name}(params, tries = 2)
          begin
            MultiJson.load(post("#{url}", params))
          rescue Exception => e
            Rails.logger.info e
            retry unless (tries -= 1).zero?
          end
        end
      EOF
  end

  private
   def self.post(url, params)
    nonce, timestamp = rand(), Time.now.to_i
    local_signature = generate_signature(RongCloudInterface.config.app_secret, nonce, timestamp)
    header = {"App-key"=> RongCloudInterface.config.app_key, "Nonce"=> nonce, "Timestamp"=> timestamp, "signature"=> local_signature}
    header = header.merge(params['header']) if params['header'].is_a?(Hash)
    RestClient.post("#{RongCloudInterface.config.server_api_url}#{url}.#{RongCloudInterface.config.format}", 
     params, 
     header)
   end

   def self.generate_signature(secret, nonce, timestamp)
    Digest::SHA1.hexdigest("#{secret}#{nonce}#{timestamp}")
   end
  end
end