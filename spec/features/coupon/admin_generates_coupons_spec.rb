require 'rails_helper'

feature 'Admin generates coupons' do
  background do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
  end

  scenario 'and there are coupons available to be generated' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promotion = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 5,
                                  discount_rate: 10, code: 'PASCOA10',
                                  expiration_date: 1.day.from_now, maximum_discount: 10)
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Emitir cupons'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('PASCOA10-0001 (Disponível)')
    expect(page).to have_content('PASCOA10-0002 (Disponível)')
    expect(page).to have_content('PASCOA10-0003 (Disponível)')
    expect(page).to have_content('PASCOA10-0004 (Disponível)')
    expect(page).to have_content('PASCOA10-0005 (Disponível)')
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).not_to have_link('Emitir cupons')
  end

  scenario 'but they had already been generated' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promotion = Promotion.create!(product_categories: [product], name: 'Pascoa', 
                                  coupon_quantity: 5, discount_rate: 10, code: 'PASCOA10',
                                  expiration_date: 1.day.from_now, maximum_discount: 10)
    coupon = promotion.coupons.create(code: 'ABCD')

    visit promotion_path(promotion)

    expect(page).not_to have_link('Emitir cupons')
    expect(page).to have_content(coupon.code)
  end

  scenario 'but it was after promotions expiration date' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promotion = Promotion.create!(product_categories: [product], name: 'Pascoa', 
                                  coupon_quantity: 5, discount_rate: 10, code: 'PASCOA10',
                                  expiration_date: '10/01/1910', maximum_discount: 10)

    visit promotion_path(promotion)

    expect(page).not_to have_link('Emitir cupons')
  end
end
