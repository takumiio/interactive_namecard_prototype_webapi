class NamecardRequsetingController < ApplicationController
  def create
    image_base64 = params[:namecard_image].gsub("data:image/png;base64,", "")
    image_bin = Base64.decode64(image_base64)
    filename = Time.now.strftime('%Y%m%d%H%M%S.png')
    File.binwrite("#{Rails.root}/public/#{filename}", image_bin)

    Slack.configure do |config|
      config.token = ENV["SLACK_API_TOKEN"]
    end
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: ENV["SLACK_POST_CHANNEL_ID"], text: "名刺の作成が依頼されています!!\nhttp://api.proto.namecard.takumi.io/#{filename}")
    client.files_upload(
      channels: 'CFKF1MKFW',
      file: Faraday::UploadIO.new("#{Rails.root}/public/#{filename}", 'image/png'),
      title: 'Request to create Namecard',
      filename: filename,
      initial_comment: 'イメージはこんなかんじです!!'
    )

    render json: { "message": "is OK" }
  end
end
