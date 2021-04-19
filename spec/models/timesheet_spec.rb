require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  context 'date of entry' do
    let(:record){ Timesheet.new }

    it 'validates presence' do
      record.date_of_entry = ''
      record.validate
      expect(record.errors[:date_of_entry]).to include("can't be blank")

      record.date_of_entry = '2021-04-18'
      record.start_time = '2021-04-18 20:00:00'
      record.validate
      expect(record.errors[:date_of_entry]).to_not include("can't be blank")
    end

    it 'validates that its not in the future' do
      record.date_of_entry = '2022-04-18'
      record.validate
      expect(record.errors[:date_of_entry]).to include("Date of entry can't be in the future")

      record.date_of_entry = '2021-04-18'
      record.start_time = '2021-04-18 20:00:00'
      record.validate
      expect(record.errors[:date_of_entry]).to_not include("Date of entry can't be in the future")
    end
  end

  context 'start time' do
    let(:record){ Timesheet.new }

    it 'validates presence' do
      record.start_time = ''
      record.validate
      expect(record.errors[:start_time]).to include("can't be blank")

      record.start_time = '2021-04-18 20:00:00'
      record.validate
      expect(record.errors[:start_time]).to_not include("can't be blank")
    end
  end

  context 'finish time' do
    let(:record){ Timesheet.new }

    it 'validates presence' do
      record.finish_time = ''
      record.validate
      expect(record.errors[:finish_time]).to include("can't be blank")

      record.finish_time = '2021-04-18 20:00:00'
      record.validate
      expect(record.errors[:finish_time]).to_not include("can't be blank")
    end

    it 'validates its not before start time' do
      record.start_time = '2021-04-18 20:00:00'
      record.finish_time = '2021-04-18 15:00:00'
      record.validate
      expect(record.errors[:finish_time]).to include("Finish time can't be before start time")

      record.start_time = '2021-04-18 15:00:00'
      record.finish_time = '2021-04-18 20:00:00'
      record.validate
      expect(record.errors[:finish_time]).to_not include("Finish time can't be before start time")
    end
  end

  context 'overlapping entries' do
    Timesheet.create date_of_entry: '2021-04-18', start_time: '2021-04-18 15:00:00', finish_time: '2021-04-18 20:00:00'
    let(:record){ Timesheet.new }

    it 'validates that entries do not overlap' do
      record.date_of_entry = '2021-04-18'
      record.start_time = '2021-04-18 08:00:00'
      record.finish_time = '2021-04-18 16:00:00'
      record.validate
      expect(record.errors[:start_time]).to include("You can't have overlapping timesheet entries")
      expect(record.errors[:finish_time]).to include("You can't have overlapping timesheet entries")
    end
  end

  context 'calculated amount' do
    let(:record){ Timesheet.new }

    it 'calculates rates for Monday' do
      record.date_of_entry = '2021-04-12'
      record.start_time = '2021-04-12 10:00:00'
      record.finish_time = '2021-04-12 17:00:00'
      record.calculated_amount
      expect(record[:amount]).to eq(154)
    end

    it 'calculates rates for Tuesday' do
      record.date_of_entry = '2021-04-13'
      record.start_time = '2021-04-13 12:00:00'
      record.finish_time = '2021-04-13 20:15:00'
      record.calculated_amount
      expect(record[:amount]).to eq(238.75)
    end

    it 'calculates rates for Wednesday' do
      record.date_of_entry = '2021-04-14'
      record.start_time = '2021-04-14 04:00:00'
      record.finish_time = '2021-04-14 21:30:00'
      record.calculated_amount
      expect(record[:amount]).to eq(445.5)
    end

    it 'calculates rates for Thursday' do
      record.date_of_entry = '2021-04-15'
      record.start_time = '2021-04-15 12:00:00'
      record.finish_time = '2021-04-15 20:15:00'
      record.calculated_amount
      expect(record[:amount]).to eq(238.75)
    end

    it 'calculates rates for Friday' do
      record.date_of_entry = '2021-04-16'
      record.start_time = '2021-04-16 10:00:00'
      record.finish_time = '2021-04-16 17:00:00'
      record.calculated_amount
      expect(record[:amount]).to eq(154)
    end

    it 'calculates rates for Weekends' do
      record.date_of_entry = '2021-04-17'
      record.start_time = '2021-04-17 15:30:00'
      record.finish_time = '2021-04-17 20:00:00'
      record.calculated_amount
      expect(record[:amount]).to eq(211.5)
    end

  end
end
