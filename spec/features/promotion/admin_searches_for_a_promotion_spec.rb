require 'rails_helper'

feature 'Admin searches for a promotion' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'successfully' do
    login_as(user, scope: :user)
    promotions = create_list :promotion, 2, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'
    fill_in('promo-search',	with: 'NATAL')
    click_on 'promo-search-button'

    expect(page).to have_content 'Os seguintes resultados foram encontrados'
    expect(page).to have_content promotions[0].name
    expect(page).to have_content promotions[1].name
    expect(page).to have_content 'Categorias de produtos', count: 3 # Results and menu
    expect(page).to have_content 'Wordpress', count: 2
    expect(page).to have_content 'Valor máximo de desconto', count: 2
    expect(page).to have_content 'R$ 50,00', count: 2
    expect(page).to have_content 'Data de término', count: 2
    expect(page).to have_content 1.day.from_now.strftime('%d/%m/%Y'), count: 2
    expect(page).to have_link('Voltar', href: promotions_path)
  end

  scenario 'and displays message if search field is blank' do
    login_as(user, scope: :user)

    visit root_path
    click_on 'Promoções'
    click_on 'promo-search-button'

    expect(page).to have_content 'não pode ficar em branco'
    expect(page).not_to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_current_path promotions_path, ignore_query: true
  end

  scenario 'and no results message is displayed' do
    login_as(user, scope: :user)

    visit promotions_path
    fill_in 'promo-search',	with: 'NATAL', match: :prefer_exact
    click_on 'promo-search-button'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_link('Voltar', href: promotions_path)
  end
end
