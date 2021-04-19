require 'rails_helper'

RSpec.feature "Timesheet", js: true, type: :feature do
  background do
    visit login_path
    fill_in 'Email', with: 'example@mail.com'
    fill_in 'Password', with: 'chicken'
    click_button 'Login'
  end

  scenario "Date of entry in the future" do
    visit new_timesheet_path
    fill_in 'Date of Entry', with: '2021-10-01'
    fill_in 'Start Time', with: '08:00'
    fill_in 'Finish Time', with: '15:00'
    click_button 'Create Entry'
    expect(page).to have_content "Date of entry can't be in the future"
  end

  scenario "Finish time before start time" do
    visit new_timesheet_path
    fill_in 'Date of Entry', with: '2021-02-01'
    fill_in 'Start Time', with: '15:00'
    fill_in 'Finish Time', with: '08:00'
    click_button 'Create Entry'
    expect(page).to have_content "Finish time can't be before start time"
  end

  scenario "Overlapping timesheet entries" do
    visit new_timesheet_path
    fill_in 'Date of Entry', with: '2021-02-01'
    fill_in 'Start Time', with: '10:00'
    fill_in 'Finish Time', with: '17:00'
    click_button 'Create Entry'

    visit new_timesheet_path
    fill_in 'Date of Entry', with: '2021-02-01'
    fill_in 'Start Time', with: '15:00'
    fill_in 'Finish Time', with: '20:00'
    click_button 'Create Entry'
    expect(page).to have_content "You can't have overlapping timesheet entries"
  end

  scenario "Successful timesheet entry" do
    visit new_timesheet_path
    fill_in 'Date of Entry', with: '2021-02-01'
    fill_in 'Start Time', with: '10:00'
    fill_in 'Finish Time', with: '17:00'
    click_button 'Create Entry'
    expect(page).to have_content "Timesheet successfully created."
    expect(page).to have_content "01/02/2021"
    expect(page).to have_content "10:00 - 17:00"
    expect(page).to have_content "$154.00"
  end

  scenario "Go back to timesheet index" do
    visit new_timesheet_path
    click_link 'Go Back'
    expect(page).to have_content "Timesheet Entries"
  end

  scenario "Show timesheet entries" do
    visit timesheets_path
    expect(page).to have_content "S/N"
    expect(page).to have_content "Date of Entry"
    expect(page).to have_content "Start Time - Finish Time"
    expect(page).to have_content "Calculated Amount"
    expect(page).to have_content "Status"
  end

  scenario "Create timesheet entry" do
    visit timesheets_path
    click_link 'Create Timesheet Entry'
    expect(page).to have_content "Date of Entry"
    expect(page).to have_content "Start Time"
    expect(page).to have_content "Finish Time"
  end
end
