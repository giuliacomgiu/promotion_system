require 'rails_helper'

describe Promotion do
  context 'validation on create' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
    end

    it 'code must be uniq' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end

    it 'code is case insensitive' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(code: 'natal10')
      promotion.valid?

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end
  end

  context 'validation on edit' do
    it 'code must be unique' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL20', discount_rate: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')

      promotion.update(code: 'NATAL10')

      expect(promotion.errors[:code]).to include('já está em uso')
    end

    it 'attributes cannot be blank' do
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL20', discount_rate: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')

      promotion.update(name: '', code: '', discount_rate: '',
                       coupon_quantity: '', expiration_date: '')

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em branco')
    end
  end

  context '#code' do
    it 'must save in uppercase' do
      promotion = Promotion.new(code: 'test')

      expect(promotion.code).to eq 'TEST'
    end
  end

  context '#issue_coupons!' do
    it 'for the first time in a promotion' do
      promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 2,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033')
      promotion.issue_coupons!
      coupons = promotion.coupons

      expect(coupons.count).to eq 2
      expect(coupons.map(&:persisted?)).to all be_truthy
      expect(coupons.map(&:code)).to contain_exactly('CYBER15-0001', 'CYBER15-0002')
    end

    it 'cant be issued twice' do
      promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 2,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033')
      promotion.issue_coupons!
      coupons = promotion.coupons

      expect { promotion.issue_coupons! }.to raise_error('Cupons já foram gerados!')
      expect(coupons.count).to eq 2
      expect(coupons.map(&:code)).to contain_exactly('CYBER15-0001', 'CYBER15-0002')
    end

    it 'cant issue coupons after promotion\'s expiration date' do
      promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 2,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/1933')

      expect { promotion.issue_coupons! }.to raise_error('A promoção já expirou')
      expect(promotion.coupons).to be_empty
    end
  end

  context '#expired?' do
    it 'returns true if expired' do
      promotion = Promotion.new(expiration_date: 1.day.ago)

      expect(promotion.expired?).to be true
    end

    it 'returns false if not expired' do
      promotion = Promotion.new(expiration_date: 1.day.from_now)

      expect(promotion.expired?).to be false
    end
  end

  context '#not_expired?' do
    it 'returns false if expired' do
      promotion = Promotion.new(expiration_date: 1.day.ago)

      expect(promotion.not_expired?).to be false
    end

    it 'returns true if not expired' do
      promotion = Promotion.new(expiration_date: 1.day.from_now)

      expect(promotion.not_expired?).to be true
    end
  end
end
