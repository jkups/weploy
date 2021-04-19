require 'rails_helper'

RSpec.describe User, type: :model do
  context 'login authentication' do
    User.create email: 'example@mail.com', password: 'chicken'

    it 'validates email' do
      user = User.find_by email: 'unregistered@mail.com'
      expect(user.present?).to eq(false)

      user = User.find_by email: 'example@mail.com'
      expect(user.present?).to eq(true)
    end

    it 'validates password' do
      user = User.find_by email: 'example@mail.com'
      expect(user.authenticate('grumpy')).to eq(false)
      expect(user.authenticate('chicken')).equal?(user)
    end
  end
end
