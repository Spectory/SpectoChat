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
    ActionCable.server.broadcast "private_#{data['to']}", data if are_sharing_group(current_user.to_i, data['to'].to_i)
  end

  def are_sharing_group(id1, id2)
    begin
      user1 = User.find(id1)
      user2 = User.find(id2)

      conn = ActiveRecord::Base.connection
      res = conn.execute('SELECT group_id FROM groups_users WHERE (user_id = ' + user1.id.to_s + ' OR user_id = ' + user2.id.to_s + ') GROUP BY group_id HAVING COUNT(group_id) > 1')

      return res.count > 0
    rescue
      return false
    end
  end

  def member_exists?(id)
    begin
      User.find(id)
      return true
    rescue
      return false
    end
  end
end
