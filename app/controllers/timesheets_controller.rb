class TimesheetsController < ApplicationController
  before_action :check_if_user_logged_in

  def index
    @timesheets = Timesheet.where(user_id: @current_user.id)
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new timesheet_params
    @timesheet.user_id = @current_user.id
    @timesheet.calculated_amount
    @timesheet.save

    if @timesheet.persisted?
      flash[:success] = 'Timesheet successfully created.'
      redirect_to timesheets_path
    else
      render :new and return
    end
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(
      :date_of_entry, :start_time, :finish_time
    )
  end
end
