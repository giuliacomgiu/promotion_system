require 'rails_helper'

feature 'Admin edits a product category' do
  background do
    user = User.create!(email: 'teste@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and succeeds' do
    product_category = ProductCategory.create!(name: 'test', code: 'test')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'test'
    click_on 'Editar'

    fill_in 'Nome',	with: 'Novo'
    fill_in 'Código',	with: 'novo'
    click_on 'Salvar'

    expect(current_path).to eq product_category_path(product_category)
    expect(page).to have_content('Novo')
    expect(page).to have_content('NOVO')
    expect(page).not_to have_content('test')
    expect(page).not_to have_content('TEST')
  end

  scenario 'and items cannot be blank' do
    product_category = ProductCategory.create!(name: 'test', code: 'test')

    visit product_category_path(product_category)
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end

  scenario 'and code must be unique' do
    ProductCategory.create!(name: 'test', code: 'test')
    product_category = ProductCategory.create!(name: 'novo', code: 'novo')

    visit product_category_path(product_category)
    click_on 'Editar'

    fill_in 'Código', with: 'test'
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
