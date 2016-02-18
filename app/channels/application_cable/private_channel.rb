class PrivateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "private_#{current_user}" if member_exists?(current_user.to_i)
  end

  def unsubscribed
    puts "unsub"
  end

  def custom(data)
    puts "custom"
  end

  def receive(data)
    groups = YAML::load(File.open('config/groups.yml'))
    groups.each do |group|
    end

    ActionCable.server.broadcast "private_#{data['to']}", data if are_sharing_group(current_user.to_i, data['to'].to_i)
  end

  def are_sharing_group(id1, id2)
    groups = YAML::load(File.open('config/groups.yml'))
    groups["groups"].values.each do |group|
      id1_present = false
      id2_present = false
      group.each do |member|
        id1_present = true if member == id1
        id2_present = true if member == id2

        return true if id1_present && id2_present
      end
    end

    false
  end

  def member_exists?(id)
    groups = YAML::load(File.open('config/groups.yml'))
    groups["groups"].values.each do |group|
      group.each do |member|
        return true if id == member
      end
    end

    false
  end
end