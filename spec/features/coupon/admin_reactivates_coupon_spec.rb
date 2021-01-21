require 'rails_helper'

feature 'Admin attemps to reactivate coupon' do
  background do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    login_as user, scope: :user
  end

  scenario 'and there is a reactivate button' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, expiration_date: 1.day.from_now,
                              code: 'PASCOA10', maximum_discount: 10)
    Coupon.create!(promotion: promo, code: 'PASCOA10-0001', status: 'archived')

    visit root_path
    click_on 'Promoções'
    click_on 'Pascoa'

    expect(page).to have_content 'PASCOA10-0001'
    expect(page).to have_link 'Reativar'
  end

  scenario 'and succeeds if coupon is archived' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, expiration_date: 1.day.from_now,
                              code: 'PASCOA10', maximum_discount: 10)
    coupon = Coupon.create!(promotion: promo, code: 'PASCOA10-0001', status: 'archived')

    visit promotion_path(promo)
    click_on 'Reativar'

    expect(page).to have_content 'Cupom reativado com sucesso'
    expect(page).to have_content 'Disponível'
    expect(page).to have_link 'Arquivar'
    expect(coupon.reload).to be_active
  end

  scenario 'and cant do it if coupon is active' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2, 
                              discount_rate: 10, expiration_date: 1.day.from_now,
                              code: 'PASCOA10', maximum_discount: 10)
    Coupon.create!(promotion: promo, code: 'PASCOA10-0001', status: 'active')

    visit promotion_path(promo)

    expect(page).not_to have_link 'Reativar'
  end
end
