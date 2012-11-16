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

require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:leader) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(leader_id: leader.id) }

  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:leader) }
    its(:follower) { should == follower }
    its(:leader) { should == leader }
  end

  describe "when leader id is not present" do
    before { relationship.leader_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
