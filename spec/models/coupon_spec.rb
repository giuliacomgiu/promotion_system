require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context '#title' do
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
end
