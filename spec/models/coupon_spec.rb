require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context '#name' do
    it 'status default é ativo' do
      coupon = Coupon.new(code: 'PASCOA10')

      expect(coupon.name).to eq 'PASCOA10 (Disponível)'
    end

    it 'status active' do
      coupon = Coupon.new(code: 'PASCOA10', status: :active)

      expect(coupon.name).to eq 'PASCOA10 (Disponível)'
    end

    it 'status inactive' do
      coupon = Coupon.new(code: 'PASCOA10', status: :archived)

      expect(coupon.name).to eq 'PASCOA10 (Arquivado)'
    end
  end

  context 'validation' do
    it 'code cant be blank' do
      coupon = Coupon.new

      coupon.valid?

      expect(coupon.errors.of_kind?(:code, :blank)).to be true
    end

    it 'order cant be blank on #burn' do
      coupon = Coupon.new

      coupon.valid? :burn!

      expect(coupon.errors.of_kind?(:order, :blank)).to be true
    end
  end
end
