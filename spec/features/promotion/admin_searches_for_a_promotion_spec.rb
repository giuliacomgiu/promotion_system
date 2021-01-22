require 'rails_helper'

feature 'Admin searches for a promotion' do
  background do
    user = User.create!(email: 'teste@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'successfully' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL20', discount_rate: 15, coupon_quantity: 100,
                      expiration_date: 1.day.from_now, maximum_discount: 10)
    Promotion.create!(product_categories: [product], name: 'NATALMELHOR', description: 'Promoção de Natal',
                      code: 'NATAL17', discount_rate: 15, coupon_quantity: 100,
                      expiration_date: 1.day.from_now, maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    fill_in('promo-search',	with: 'NATAL')
    click_on 'promo-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content 'Natal'
    expect(page).to have_content 'NATALMELHOR'
    expect(page).to have_content 'Categorias de produtos', count: 3 # Results and menu
    expect(page).to have_content 'Wordpress', count: 2
    expect(page).to have_content 'Valor máximo de desconto', count: 2
    expect(page).to have_content 'R$ 10,00', count: 2
    expect(page).to have_content 'Data de término', count: 2
    expect(page).to have_content  1.day.from_now.strftime('%d/%m/%Y') , count: 2
    expect(page).to have_link('Voltar', href: promotions_path)
  end

  scenario 'and displays message if search field is blank' do
    visit root_path
    click_on 'Promoções'
    click_on 'promo-search-button'

    expect(page).to have_content 'não pode ficar em branco'
    expect(page).not_to have_content 'Nenhum resultado foi encontrado'
    expect(current_path).to eq promotions_path
  end

  scenario 'and no results message is displayed' do
    visit promotions_path
    fill_in 'promo-search',	with: 'NATAL', match: :prefer_exact
    click_on 'promo-search-button'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_link('Voltar', href: promotions_path)
  end
end
