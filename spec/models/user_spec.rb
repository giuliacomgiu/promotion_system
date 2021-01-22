require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Validation' do
    it 'Validates email domain' do
      user = User.new(email: 'test@wrong.com', password: '123456')
      user.valid?

      expect(user.errors.of_kind?(:email, :invalid)).to be true
    end

    it 'password cannot be blank' do
      user = User.new(email: 'test@locaweb.com.br', password: '')
      user.valid?

      expect(user.errors.of_kind?(:password, :blank)).to be true
    end

    it 'password cannot be too short' do
      user = User.new(email: 'test@locaweb.com.br', password: '12345')
      user.valid?

      expect(user.errors.of_kind?(:password, :too_short)).to be true
    end

    it 'password has minimal lenght' do
      user = User.new(email: 'test@locaweb.com.br', password: '123456')

      expect(user.valid?).to be true
    end
  end
end
