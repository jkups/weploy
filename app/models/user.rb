class User < ApplicationRecord
  has_many :timesheet
  has_secure_password
end
