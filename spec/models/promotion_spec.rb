require 'rails_helper'

describe Promotion do
  context 'validation on create' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors.of_kind?(:name, :blank)).to be true
      expect(promotion.errors.of_kind?(:code, :blank)).to be true
      expect(promotion.errors.of_kind?(:discount_rate, :blank)).to be true
      expect(promotion.errors.of_kind?(:coupon_quantity, :blank)).to be true
      expect(promotion.errors.of_kind?(:expiration_date, :blank)).to be true
      expect(promotion.errors.of_kind?(:maximum_discount, :blank)).to be true
      expect(promotion.errors.of_kind?(:product_categories, :blank)).to be true
    end

    it 'code must be uniq' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      Promotion.create!(product_categories: [product], name: 'Natal',
                        code: 'NATAL10', discount_rate: 10, maximum_discount: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(product_categories: [product], code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end

    it 'code is case insensitive' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      Promotion.create!(product_categories: [product], name: 'Natal',
                        code: 'NATAL10', discount_rate: 10, maximum_discount: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(product_categories: [product], code: 'natal10')
      promotion.valid?

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end
  end

  context 'validation on edit' do
    it 'code must be unique' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      Promotion.create!(product_categories: [product], name: 'Natal', 
                        code: 'NATAL10', discount_rate: 10, maximum_discount: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.create!(product_categories: [product], name: 'Natal', 
                                    code: 'NATAL20', discount_rate: 10, maximum_discount: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')

      promotion.update(code: 'NATAL10')

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end

    it 'attributes cannot be blank' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Natal',
                                    code: 'NATAL20', discount_rate: 10, maximum_discount: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')

      promotion.update(name: '', code: '', discount_rate: '', maximum_discount: '',
                       coupon_quantity: '', expiration_date: '')

      expect(promotion.errors.of_kind?(:name, :blank)).to be true
      expect(promotion.errors.of_kind?(:code, :blank)).to be true
      expect(promotion.errors.of_kind?(:discount_rate, :blank)).to be true
      expect(promotion.errors.of_kind?(:coupon_quantity, :blank)).to be true
      expect(promotion.errors.of_kind?(:expiration_date, :blank)).to be true
      expect(promotion.errors.of_kind?(:maximum_discount, :blank)).to be true
      expect(promotion.errors.of_kind?(:product_categories, :blank)).to be true
    end
  end

  context '#code' do
    it 'must save in uppercase' do
      promotion = Promotion.new(code: 'test')

      expect(promotion.code).to eq 'TEST'
    end

    it 'code is case insensitive' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      Promotion.create!(product_categories: [product], name: 'Natal',
                        code: 'test', discount_rate: 10, maximum_discount: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(code: 'TEST')
      promotion.valid?

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end
  end

  context '#issue_coupons!' do
    it 'for the first time in a promotion' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Cyber Monday', 
                                    coupon_quantity: 2, code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033', maximum_discount: 10)
      promotion.issue_coupons!
      coupons = promotion.coupons

      expect(coupons.count).to eq 2
      expect(coupons.map(&:persisted?)).to all be_truthy
      expect(coupons.map(&:code)).to contain_exactly('CYBER15-0001', 'CYBER15-0002')
    end

    it 'cant be issued twice' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Cyber Monday', 
                                    coupon_quantity: 2, code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033', maximum_discount: 10)
      promotion.issue_coupons!
      coupons = promotion.coupons

      expect { promotion.issue_coupons! }.to raise_error('Cupons já foram gerados!')
      expect(coupons.count).to eq 2
      expect(coupons.map(&:code)).to contain_exactly('CYBER15-0001', 'CYBER15-0002')
    end

    it 'cant issue coupons after promotion\'s expiration date' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Cyber Monday', 
                                    code: 'CYBER15', discount_rate: 15, coupon_quantity: 2,
                                    expiration_date: '22/12/1933', maximum_discount: 10)

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
