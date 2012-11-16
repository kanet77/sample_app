# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  MAX_LENGTH = 140

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: MAX_LENGTH }

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    leader_ids = "SELECT leader_id FROM relationships
                     WHERE follower_id = :user_id"
    where("user_id IN (#{leader_ids}) OR user_id = :user_id",
      user_id: user)
  end

end
