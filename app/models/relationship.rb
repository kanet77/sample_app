# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  leader_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :leader_id

  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"

  validates :follower_id, presence: true
  validates :leader_id, presence: true
end
