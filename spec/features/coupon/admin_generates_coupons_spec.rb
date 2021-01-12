require 'rails_helper'

feature 'Admin generates coupons' do
  xscenario 'with coupon quantity available' do
    promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                  discount_rate: 10, code: 'PASCOA10',
                                  expiration_date: 1.day.from_now)
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Emitir cupons'

    expect(current_page).to eq(promotion_path(promotion))
    expect(page).to have_content('PASCOA10-0001')
    expect(page).to have_content('PASCOA10-0002')
    expect(page).to have_content('PASCOA10-0003')
    expect(page).to have_content('PASCOA10-0004')
    expect(page).to have_content('PASCOA10-0005')
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).not_to have_link('Emitir cupons')
  end
end
