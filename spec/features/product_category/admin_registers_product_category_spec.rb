require 'rails_helper'

feature 'Admin views product category' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and succeeds' do
    login_as(user, scope: :user)

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Cadastrar categoria'
    fill_in 'Nome', with: 'Wordpress'
    fill_in 'Código', with: 'WORDP'

    click_on 'Salvar'

    expect(page).to have_current_path product_category_path(ProductCategory.last), ignore_query: true
  end

  scenario 'and fields cant be blank' do
    login_as(user, scope: :user)

    visit new_product_category_path
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end

  scenario 'and code is unique' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit new_product_category_path
    fill_in 'Nome',	with: 'teste'
    fill_in 'Código',	with: product_category.code
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
