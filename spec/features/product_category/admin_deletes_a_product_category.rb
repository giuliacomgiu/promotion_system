require 'rails_helper'

feature 'Admin deletes a product category' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'from show view and it succeeds' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit root_path
    click_on 'Categorias de produto'
    click_on product_category.name
    click_on 'Deletar'

    expect(page).to have_current_path product_categories_path, ignore_query: true
    expect(page).to have_content('Nenhuma categoria de produto cadastrada')
  end

  scenario 'and if its the only member of a promotion, its deleted as well' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user
    product_category = promotion.product_categories.first

    product_category.destroy

    visit root_path
    click_on 'Promoções'

    expect(page).not_to have_link(promotion.name)
  end

  scenario 'and it fails and redirects to not found page' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit root_path
    click_on 'Categorias de produto'
    click_on product_category.name
    product_category.destroy!
    click_on 'Deletar'

    expect(page).to have_http_status :not_found
  end
end
