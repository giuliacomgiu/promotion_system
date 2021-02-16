require 'rails_helper'

feature 'Admin visits home page' do
  let!(:user) { create :user }

  scenario 'successfully' do
    login_as user, scope: :user

    visit root_path

    expect(page).to have_current_path root_path, ignore_query: true
  end

  scenario 'and sees the website\'s paths' do
    login_as user, scope: :user

    visit root_path

    expect(page).to have_link('Promoções', href: promotions_path)
    expect(page).to have_link('Categorias de produto', href: product_categories_path)
    expect(page).to have_field('coupon-search')
  end
end
