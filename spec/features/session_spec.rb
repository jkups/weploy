require 'rails_helper'

RSpec.feature "Login", js: true, type: :feature do
  background do
    User.create(email: 'example@mail.com', password: 'chicken')
  end

  scenario "Log in with unregistered email" do
    visit login_path
    fill_in 'Email', with: 'unregistered@mail.com'
    fill_in 'Password', with: 'chicken'
    click_button 'Login'
    expect(page).to have_content 'Invalid Email or Password.'
  end

  scenario "Log in with invalid password" do
    visit login_path
    fill_in 'Email', with: 'example@mail.com'
    fill_in 'Password', with: 'drumsticks'
    click_button 'Login'
    expect(page).to have_content 'Invalid Email or Password.'
  end

  scenario "Log in with correct credentials" do
    visit login_path
    fill_in 'Email', with: 'example@mail.com'
    fill_in 'Password', with: 'chicken'
    click_button 'Login'
    expect(page).to have_content 'Timesheet Entries'
  end
end
