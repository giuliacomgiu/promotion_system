require 'rails_helper'

feature 'Admin searches for a coupon' do

  let!(:user){ create :user }

  scenario 'and includes coupon status' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :with_coupons, creator: user

    visit root_path
    fill_in 'coupon-search',	with: promotion.coupons.first.code
    click_on 'coupon-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content promotion.coupons.first.name
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and shows a promotion preview' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :with_coupons, creator: user

    visit root_path
    fill_in 'coupon-search',	with: promotion.coupons.first.code
    click_on 'coupon-search-button'

    expect(page).to have_content "Promoção #{promotion.name}"
    expect(page).to have_link promotion.name, href: promotion_path(promotion)
    expect(page).to have_content "Desconto (%) #{promotion.discount_rate}"
    expect(page).to have_content "Data de término #{promotion.expiration_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Valor máximo de desconto (R$) R$ 50,00"
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and search is case sensitive' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :with_coupons, creator: user
    coupon =  promotion.coupons.first.code

    visit root_path
    fill_in 'coupon-search',	with: coupon.downcase
    click_on 'coupon-search-button'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).not_to have_content coupon
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'returns exact match only' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :with_coupons, creator: user
    coupon =  promotion.coupons.first.code

    visit root_path
    fill_in 'coupon-search',	with: coupon
    click_on 'coupon-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content coupon
    expect(page).not_to have_content promotion.coupons[1].code
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and no results message is displayed' do
    login_as(user, scope: :user)
    
    visit root_path
    fill_in 'coupon-search',	with: 'PASCOA10'
    click_on 'coupon-search-button'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and field cant be blank' do
    login_as(user, scope: :user)
    
    visit root_path
    click_on 'coupon-search-button'

    expect(page).to have_content 'Campo não pode ficar em branco'
  end
end

