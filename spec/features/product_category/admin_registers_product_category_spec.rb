require 'rails_helper'

feature 'Admin views product category' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and succeeds' do
    visit root_path
    click_on 'Categorias de produto'
    click_on 'Cadastrar categoria'

    fill_in 'Nome', with: 'Wordpress'
    fill_in 'Código', with: 'WORDP'

    click_on 'Salvar'

    expect(current_path).to eq product_category_path(ProductCategory.last)
  end

  scenario 'and fields cant be blank' do
    visit new_product_category_path
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end

  scenario 'and code is unique' do
    ProductCategory.create!(name: 'Wordpress', code: 'WORDP')

    visit new_product_category_path
    fill_in 'Nome',	with: 'teste'
    fill_in 'Código',	with: 'WORDP'
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
