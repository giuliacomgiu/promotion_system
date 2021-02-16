require 'rails_helper'

feature 'Admin edits a product category' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and succeeds' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit root_path
    click_on 'Categorias de produto'
    click_on product_category.name
    click_on 'Editar'

    fill_in 'Nome',	with: 'Novo'
    fill_in 'Código',	with: 'novo'
    click_on 'Salvar'

    expect(page).to have_current_path product_category_path(product_category), ignore_query: true
    expect(page).to have_content('Novo')
    expect(page).to have_content('NOVO')
    expect(page).not_to have_content(product_category.name)
    expect(page).not_to have_content(product_category.code)
  end

  scenario 'and items cannot be blank' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit product_category_path(product_category)
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end

  scenario 'and code must be unique' do
    login_as(user, scope: :user)
    original_product_category = create :product_category
    new_product_category = create :product_category

    visit product_category_path(new_product_category)
    click_on 'Editar'

    fill_in 'Código', with: original_product_category.code
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
