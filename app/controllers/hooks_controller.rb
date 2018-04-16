require 'line/bot'

class HooksController < ApplicationController
  before_action :set_hook, only: [:show, :destroy]
  protect_from_forgery except: :callback

  # GET /hooks
  # GET /hooks.json
  def index
    @hooks = Hook.all
  end

  # GET /hooks/1
  # GET /hooks/1.json
  def show
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request and return
    end

    h = Hook.new
    h.payload = params
    h.save

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: "This is in response to:: #{event.message['text']}"
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Sticker
          message = {
            type: 'sticker',
            packageId: event.message['packageId'],
            stickerId: event.message['stickerId']
          }
          client.reply_message(event['replyToken'], message)
        # when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        #   response = client.get_message_content(event.message['id'])
        #   tf = Tempfile.open("content")
        #   tf.write(response.body)
        end
      end
    end
    head :ok
  end

  # DELETE /hooks/1
  # DELETE /hooks/1.json
  def destroy
    @hook.destroy
    respond_to do |format|
      format.html { redirect_to hooks_url, notice: 'Hook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hook
    @hook = Hook.find(params[:id])
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
