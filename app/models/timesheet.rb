class Timesheet < ApplicationRecord
  belongs_to :user
  validates :date_of_entry, :start_time, :finish_time, presence: true
  validate :date_of_entry_cant_be_in_the_future, :finish_time_cant_be_before_start_time, :timesheet_entries_cant_overlap

  def date_of_entry_cant_be_in_the_future
    if date_of_entry.present? && date_of_entry > Date.today
      errors.add(:date_of_entry, "Date of entry can't be in the future")
    end
  end

  def finish_time_cant_be_before_start_time
    return unless finish_time.present? && start_time.present?

    if finish_time < start_time
      errors.add(:finish_time, "Finish time can't be before start time")
    end
  end

  def timesheet_entries_cant_overlap
    timesheets = Timesheet.where(date_of_entry: date_of_entry, user_id: user_id)

    if timesheets.present?
      timesheets.each do |timesheet|
        if start_time.between?(timesheet.start_time, timesheet.finish_time) || finish_time.between?(timesheet.start_time, timesheet.finish_time)
          errors.add(:start_time, "You can't have overlapping timesheet entries")
          errors.add(:finish_time, "You can't have overlapping timesheet entries")
          break
        end
      end
    end
  end

  def calculated_amount
    return unless date_of_entry.present? && finish_time.present? && start_time.present?

    week_day = date_of_entry.strftime("%A")
    self.amount = 0

    case week_day
    when 'Monday', 'Wednesday', 'Friday'
      min_rate_start_time =  DateTime.new(start_time.year, start_time.month, start_time.day, 7, 00).utc
      min_rate_finish_time = DateTime.new(start_time.year, start_time.month, start_time.day, 19, 00).utc
      min_rate = 22
      max_rate = 33

      calculate_amount min_rate_start_time, min_rate_finish_time, min_rate, max_rate

    when 'Tuesday', 'Thursday'
      min_rate_start_time =  DateTime.new(start_time.year, start_time.month, start_time.day, 5, 00).utc
      min_rate_finish_time = DateTime.new(start_time.year, start_time.month, start_time.day, 17, 00).utc
      min_rate = 25
      max_rate = 35

      calculate_amount min_rate_start_time, min_rate_finish_time, min_rate, max_rate

    else
      self.amount = (finish_time - start_time)/3600 * 47
    end
  end

  def calculate_amount min_rate_start_time, min_rate_finish_time, min_rate, max_rate
    if start_time < min_rate_start_time
      self.amount += (min_rate_start_time - start_time)/3600 * max_rate
    else
      min_rate_start_time = start_time
    end

    if finish_time > min_rate_finish_time
      self.amount += (finish_time - min_rate_finish_time)/3600 * max_rate
    else
      min_rate_finish_time = finish_time
    end

    self.amount += (min_rate_finish_time - min_rate_start_time)/3600 * min_rate
  end
end
