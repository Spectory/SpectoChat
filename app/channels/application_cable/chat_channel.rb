class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "group_#{params[:group]}"
  end

  def unsubscribed
    puts "unsub"
  end

  def custom(data)
    puts "custom"
  end

  def receive(data)
    ActionCable.server.broadcast "group_#{params[:group]}", data
  end
end