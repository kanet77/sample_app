require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in_test user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do
      before(:all) { (User.per_page + 1).times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        for i in (1..(User.count/Float(User.per_page)).ceil) do
          visit users_path << "?page=#{i}"
          User.paginate(page: i).each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in_test admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

	  before { visit user_path(user) }

	  it { should have_selector('h1',    text: user.name) }
	  it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
	end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create account" }

    describe "with blank information" do
      it "should not create a user" do
        expect { click_button :submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_selector('div', text: "The form contains 6 errors.") }

        it { should have_selector('li', text: "Password can't be blank") }
        it { should have_selector('li', text: "Name can't be blank") }
        it { should have_selector('li', text: "Email can't be blank") }
        it { should have_selector('li', text: "Email is invalid") }
        it { should have_selector('li', text: "Password is too short (minimum is 6 characters)") }
        it { should have_selector('li', text: "Password confirmation can't be blank") }
      end
    end

    describe "with invalid information" do
      before { fill_in_user('k'*51, 'user@example', 'foo', '') }

      it "should not create a user" do
        expect { click_button :submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_selector('div', text: "The form contains 5 errors.") }

        it { should have_selector('li', text: "Password doesn't match confirmation") }
        it { should have_selector('li', text: "Password is too short (minimum is 6 characters)") }
        it { should have_selector('li', text: "Name is too long (maximum is 50 characters)") }
        it { should have_selector('li', text: "Email is invalid") }
        it { should have_selector('li', text: "Password confirmation can't be blank") }
      end
    end

    describe "with valid information" do
      before { fill_in_user('barf', 'barf@barf.com', 'barfbarf', 'barfbarf') }

      it "should create a user" do
        expect { click_button :submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user_f) { User.find_by_email('barf@barf.com') }

        it { should have_selector('title', text: user_f.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }

        describe "after signing out the user" do
          before { click_link 'Sign out' }
          it { should have_selector('div', text: "Successfuly signed out" ) }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in_test user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end