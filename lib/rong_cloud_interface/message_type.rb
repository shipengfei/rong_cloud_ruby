module RongCloudInterface
  class MessageType

    TYPES = %w{RC:TxtMsg RC:ImgMsg RC:VcMsg RC:ImgTextMsg RC:LBSMsg RC:ContactNtf RC:InfoNtf RC:ProfileNtf RC:CmdNtf RC:CmdMsg}

    TYPES.each_with_index do |type, index|
      method = type.gsub(":","_").downcase
      MessageType.instance_eval <<-EOF
        def #{method}
          TYPES[#{index}]
        end
      EOF
    end
  end
end