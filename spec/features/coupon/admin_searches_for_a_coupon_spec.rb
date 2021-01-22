require 'rails_helper'

feature 'Admin searches for a coupon' do
  background do
    user = User.create!(email: 'teste@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and includes coupon status' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, code: 'PASCOA10',
                              expiration_date: 1.day.from_now, maximum_discount: 10)
    Coupon.create!({ promotion: promo, code: 'PASCOA10-0001' })

    visit root_path
    fill_in 'coupon-search',	with: 'PASCOA10-0001'
    click_on 'coupon-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content 'PASCOA10-0001 (Disponível) '
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and shows a promotion preview' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, code: 'PASCOA10',
                              expiration_date: 1.day.from_now, maximum_discount: 10)
    Coupon.create!({ promotion: promo, code: 'PASCOA10-0001' })

    visit root_path
    fill_in 'coupon-search',	with: 'PASCOA10-0001'
    click_on 'coupon-search-button'

    expect(page).to have_content "Promoção: #{promo.name}"
    expect(page).to have_link promo.name, href: promotion_path(promo)
    expect(page).to have_content "Desconto (%): #{promo.discount_rate}"
    expect(page).to have_content "Data de término: #{promo.expiration_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Valor máximo de desconto (R$): R$ 10.0" #TODO: use I18n
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and search is case insensitive' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, code: 'PASCOA10',
                              expiration_date: 1.day.from_now, maximum_discount: 10)
    Coupon.create!({ promotion: promo, code: 'PASCOA10-0001' })

    visit root_path
    fill_in 'coupon-search',	with: 'pascoa10-0001'
    click_on 'coupon-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content 'PASCOA10-0001'
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'returns exact match only' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promo = Promotion.create!(product_categories: [product], name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, code: 'PASCOA10',
                              expiration_date: 1.day.from_now, maximum_discount: 10)
    Coupon.create!([{ promotion: promo, code: 'PASCOA10-0001' },
                    { promotion: promo, code: 'PASCOA10-0002' }])

    visit root_path
    fill_in 'coupon-search',	with: 'PASCOA10-0001'
    click_on 'coupon-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content 'PASCOA10-0001'
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and no results message is displayed' do
    visit root_path

    fill_in 'coupon-search',	with: 'PASCOA10'
    click_on 'coupon-search-button'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_link('Voltar', href: root_path)
  end
end
