class CreateTimesheets < ActiveRecord::Migration[6.0]
  def change
    create_table :timesheets do |t|
      t.date :date_of_entry
      t.datetime :start_time
      t.datetime :finish_time
      t.float :amount

      t.timestamps
    end
  end
end
