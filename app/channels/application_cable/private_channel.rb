class PrivateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "private_#{current_user}"
  end

  def unsubscribed
    puts "unsub"
  end

  def custom(data)
    puts "custom"
  end

  def receive(data)
    ActionCable.server.broadcast "private_#{data['to']}", data
  end
end