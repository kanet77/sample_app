include ApplicationHelper

def sign_in_test(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def fill_in_user(name, email, password, confirmation)
  fill_in "Name",         with: name
  fill_in "Email",        with: email
  fill_in "Password",     with: password
  fill_in "Confirm Password", with: confirmation
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end
