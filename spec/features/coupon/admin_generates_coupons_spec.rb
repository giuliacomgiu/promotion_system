require 'rails_helper'

feature 'Admin generates coupons' do

  let!(:user){ create :user, email: 'maria@locaweb.com.br' }

  xscenario 'fails if promotion is not approved'

  scenario 'and there are coupons available to be generated' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Emitir cupons'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content("#{promotion.code}-0001 (Disponível)")
    expect(page).to have_content("#{promotion.code}-0002 (Disponível)")
    expect(page).to have_content("#{promotion.code}-0003 (Disponível)")
    expect(page).to have_content("#{promotion.code}-0004 (Disponível)")
    expect(page).to have_content("#{promotion.code}-0005 (Disponível)")
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).not_to have_link('Emitir cupons')
  end

  scenario 'but they had already been generated' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, :with_coupons, 
                       coupon_quantity: 1, creator: user

    visit promotion_path(promotion)

    expect(page).not_to have_link('Emitir cupons')
    expect(page).to have_content(promotion.coupons.first.code)
  end

  scenario 'but it was after promotions expiration date' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, :expired, creator: user

    visit promotion_path(promotion)

    expect(page).not_to have_link('Emitir cupons')
  end
end
