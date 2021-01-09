require 'rails_helper'

feature 'Admin views product category' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'index view is successful' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    ProductCategory.create!(name: 'E-mail', code: 'EMAIL')

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('HOSP')
    expect(page).to have_content('E-mail')
    expect(page).to have_content('EMAIL')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'code is displayed uppercase' do
    ProductCategory.create!(name: 'Hospedagem', code: 'hosp')

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('HOSP')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and shows empty message' do
    visit product_categories_path

    expect(page).to have_content('Nenhuma categoria de produto cadastrada')
  end

  scenario 'and views details' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    visit product_categories_path
    click_on 'Hospedagem'

    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('HOSP')
    expect(page).to have_link('Voltar', href: product_categories_path)
  end
end
