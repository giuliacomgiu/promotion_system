require 'rails_helper'

feature 'Admin deletes a product category' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'from show view and it succeeds' do
    ProductCategory.create!(name: 'test', code: 'test')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'test'
    click_on 'Deletar'

    expect(current_path).to eq product_categories_path
    expect(page).to have_content('Nenhuma categoria de produto cadastrada')
  end

  xscenario 'and it fails' do
    product_category = ProductCategory.create!(name: 'test', code: 'test')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'test'
    product_category.destroy!
    click_on 'Deletar'

    expect(page).to have_content('Algo deu errado')
  end
end
