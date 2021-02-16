require 'rails_helper'

feature 'Visitor visits home page' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_current_path new_user_session_path, ignore_query: true
    expect(page).to have_link(href: new_user_session_path)
    expect(page).to have_link(href: new_user_registration_path)
  end

  scenario 'and doesnt see the website\'s paths' do
    visit root_path

    expect(page).not_to have_link('Promoções', href: promotions_path)
    expect(page).not_to have_link('Categorias de produto', href: product_categories_path)
    expect(page).not_to have_content('Buscar cupom')
    expect(page).not_to have_button('Buscar')
  end
end
