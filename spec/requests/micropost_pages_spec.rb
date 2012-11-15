require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { sign_in_test user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: Faker::Lorem.sentence }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "pagination" do
    before(:all) { (Micropost.per_page * 2).times { FactoryGirl.create(:micropost, user: user) } }
    before(:all) { (Micropost.per_page * 3).times { FactoryGirl.create(:micropost, user: other_user) } }

    it { should have_selector('div.pagination') }

    it "should list each micropost on root" do
      for i in (1..(user.microposts.count/Float(Micropost.per_page)).ceil) do
        visit root_path << "?page=#{i}"
        user.microposts.paginate(page: i).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end

    it "should list each micropost on profile" do
      for i in (1..(other_user.microposts.count/Float(Micropost.per_page)).ceil) do
        visit user_path(other_user) << "?page=#{i}"
        other_user.microposts.paginate(page: i).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
