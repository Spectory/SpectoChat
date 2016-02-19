require 'yaml'

class ChatChannel < ApplicationCable::Channel
  def subscribed
    get_all_groups(current_user.to_i).each do |group|
      stream_from "group_#{group.name}"
    end
  end

  def unsubscribed
    puts "unsub"
  end

  def custom(data)
    puts "custom"
  end

  def receive(data)
    ActionCable.server.broadcast "group_#{data['room']}", data if in_group?(current_user.to_i, data['room'])
  end

  def in_group?(id, group)
    begin
      user = User.find(id)
      return user.group.where(name: group).length > 0
    rescue
      return false
    end
  end

  def get_all_groups(id)
    begin
      user = User.find(id)
      return user.group
    rescue
      return []
    end
  end
end