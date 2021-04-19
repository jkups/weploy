class AddStatusToTimesheets < ActiveRecord::Migration[6.0]
  def change
    add_column :timesheets, :status, :string, default: 'pending'
  end
end
