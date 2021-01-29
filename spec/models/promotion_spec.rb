require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = build :promotion, :blank

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
      original_promotion = create :promotion, :with_product_category
      copy_promotion = build :promotion, code: original_promotion.code

      copy_promotion.valid?

      expect(copy_promotion.errors.of_kind?(:code, :taken)).to be true
    end

    it 'code is case insensitive' do
      original_promotion = create :promotion, :with_product_category
      copy_promotion = build :promotion, code: original_promotion.code.downcase

      copy_promotion.valid?

      expect(copy_promotion.errors.of_kind?(:code, :taken)).to be true
    end
  end

  context '#code' do
    it 'must save in uppercase' do
      promotion = create :promotion, :with_product_category, code: 'test'

      expect(promotion.code).to eq 'TEST'
    end

    it 'code is case insensitive' do
      original_promotion = create :promotion, :with_product_category
      promotion = build :promotion, code: original_promotion.code.downcase

      promotion.valid?

      expect(promotion.errors.of_kind?(:code, :taken)).to be true
    end
  end

  context '#issue_coupons!' do
    it 'for the first time in a promotion' do
      promotion = create :promotion, :with_product_category, :approved, coupon_quantity: 2

      promotion.issue_coupons!
      coupons = promotion.coupons

      expect(coupons.count).to eq 2
      expect(coupons.map(&:persisted?)).to all be_truthy
      expect(coupons.map(&:code)).to contain_exactly("#{promotion.code}-0001", "#{promotion.code}-0002")
    end

    it 'cant be issued twice' do
      promotion = create :promotion, :with_product_category, :approved, coupon_quantity: 2

      promotion.issue_coupons!
      coupons = promotion.coupons

      expect { promotion.issue_coupons! }.to raise_error('Cupons já foram gerados!')
      expect(coupons.count).to eq 2
      expect(coupons.map(&:code)).to contain_exactly("#{promotion.code}-0001", "#{promotion.code}-0002")
    end

    it 'cant issue coupons after promotion\'s expiration date' do
      promotion = create :promotion, :with_product_category, :approved, expiration_date: 1.day.ago

      expect { promotion.issue_coupons! }.to raise_error('A promoção já expirou')
      expect(promotion.coupons).to be_empty
    end

    it 'cant issue coupons if promotion isnt approved' do
      promotion = create :promotion, :with_product_category

      expect { promotion.issue_coupons! }.to raise_error('A promoção deve estar aprovada')
    end
  end

  context '#expired?' do
    it 'returns true if expired' do
      promotion = build :promotion, :with_product_category, expiration_date: 1.day.ago

      expect(promotion.expired?).to be true
    end

    it 'returns false if not expired' do
      promotion = build :promotion, :with_product_category, expiration_date: 1.day.from_now

      expect(promotion.expired?).to be false
    end
  end

  context '#not_expired?' do
    it 'returns false if expired' do
      promotion = build :promotion, :with_product_category, expiration_date: 1.day.ago

      expect(promotion.not_expired?).to be false
    end

    it 'returns true if not expired' do
      promotion = build :promotion, :with_product_category, expiration_date: 1.day.from_now

      expect(promotion.not_expired?).to be true
    end
  end
end
