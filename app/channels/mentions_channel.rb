class MentionsChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a channel specific to this user
    stream_from "mentions:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
