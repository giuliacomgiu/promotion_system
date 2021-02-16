require 'rails_helper'

feature 'Admin views product category' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'index view is successful' do
    login_as(user, scope: :user)
    product_categories = create_list :product_category, 2

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content(product_categories[0].name)
    expect(page).to have_content(product_categories[0].code)
    expect(page).to have_content(product_categories[1].name)
    expect(page).to have_content(product_categories[1].code)
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'code is displayed uppercase' do
    login_as(user, scope: :user)
    create :product_category, code: 'wordp'

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('WORDP')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and shows empty message' do
    login_as(user, scope: :user)

    visit product_categories_path

    expect(page).to have_content('Nenhuma categoria de produto cadastrada')
  end

  scenario 'and views details' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit product_categories_path
    click_on product_category.name

    expect(page).to have_content(product_category.name)
    expect(page).to have_content(product_category.code)
    expect(page).to have_link('Voltar', href: product_categories_path)
  end
end
