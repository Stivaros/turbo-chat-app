class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  before_create :confirm_participant
  after_create_commit { broadcast_append_to self.room }

  private

  def confirm_participant
    if self.room.private
      participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first
      throw :abort unless participant
    end
  end
end
