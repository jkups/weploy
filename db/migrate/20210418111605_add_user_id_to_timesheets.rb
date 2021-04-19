class AddUserIdToTimesheets < ActiveRecord::Migration[6.0]
  def change
    add_column :timesheets, :user_id, :integer
  end
end
