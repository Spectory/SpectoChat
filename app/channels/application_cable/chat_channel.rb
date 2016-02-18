require 'yaml'

class ChatChannel < ApplicationCable::Channel
  def subscribed
    get_all_groups(current_user.to_i).each do |group|
      stream_from "group_#{group}"
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
    groups = YAML::load(File.open('config/groups.yml'))
    group_members = groups["groups"][group]
    return false unless group_members
    group_members.each do |member|
      return true if member == id
    end
    false
  end

  def get_all_groups(id)
    groups = YAML::load(File.open('config/groups.yml'))
    groups = groups["groups"]

    id_groups = []

    groups.keys.each do |group_key|
      groups[group_key].each do |member|
        if member == id
          id_groups.push(group_key)
          break
        end
      end
    end
    id_groups
  end
end