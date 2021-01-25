require 'rails_helper'

feature 'Admin views product category' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'index view is successful' do
    create :product_category
    create :product_category, name: 'E-mail', code: 'EMAIL'

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('Wordpress')
    expect(page).to have_content('WORD')
    expect(page).to have_content('E-mail')
    expect(page).to have_content('EMAIL')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'code is displayed uppercase' do
    create :product_category, code: 'wordp'

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('WORDP')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and shows empty message' do
    visit product_categories_path

    expect(page).to have_content('Nenhuma categoria de produto cadastrada')
  end

  scenario 'and views details' do
    create :product_category

    visit product_categories_path
    click_on 'Wordpress'

    expect(page).to have_content('Wordpress')
    expect(page).to have_content('WORDP')
    expect(page).to have_link('Voltar', href: product_categories_path)
  end
end
