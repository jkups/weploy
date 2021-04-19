require 'rails_helper'

RSpec.describe TimesheetsController, type: :controller do
  describe "GET index" do
    before do
      session[:user_id] = 1
      timesheets = [
        { user_id: 1, date_of_entry: '2021-04-18', start_time: '2021-04-18 10:00:00', finish_time: '2021-04-18 20:00:00' },
        { user_id: 1, date_of_entry: '2021-04-17', start_time: '2021-04-18 10:00:00', finish_time: '2021-04-18 20:00:00' },
        { user_id: 2, date_of_entry: '2021-04-18', start_time: '2021-04-18 10:00:00', finish_time: '2021-04-18 20:00:00' }
      ]
      timesheets.each { |t| Timesheet.create t }
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    it "assigns @timesheets" do
      timesheets = Timesheet.where(user_id: 1)
      expect(assigns(:timesheets)).to eq(timesheets)
    end
  end

  describe "GET new" do
    before do
      session[:user_id] = 1
      get :new
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      expect(response).to render_template(:new)
    end

    it "assigns @timesheet" do
      timesheet = Timesheet.new
      expect(assigns(:timesheet)).equal?(timesheet)
    end
  end

  describe "POST create" do
    before do
      session[:user_id] = 1
      @timesheet_params = { date_of_entry: '2021-04-18', start_time: '2021-04-18 10:00:00', finish_time: '2021-04-18 20:00:00' }
      post :create, params: { timesheet: @timesheet_params }
    end

    it "redirect http on success" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(timesheets_path)
      expect(flash[:success]).to include('Timesheet successfully created.')
    end

    it "assigns timesheet and calculates correct amount" do
      timesheet = Timesheet.new @timesheet_params
      timesheet.user_id = 1
      timesheet.calculated_amount

      expect(assigns(:timesheet)[:user_id]).to eq(timesheet[:user_id])
      expect(assigns(:timesheet)[:amount]).to eq(timesheet[:amount])
    end
  end

end
