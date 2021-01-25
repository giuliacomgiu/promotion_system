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

  scenario 'and if its the only member of a promotion, its deleted as well' do
    product = ProductCategory.create!(name: 'test', code: 'test')
    Promotion.create!(name: 'Natal', code: 'NATAL10', discount_rate: 10, maximum_discount: 50,
                      coupon_quantity: 5, expiration_date: 1.day.from_now, product_categories: [product])
    product.destroy

    visit root_path
    click_on 'Promoções'

    expect(page).not_to have_link('Natal')
  end

  scenario 'and it fails' do
    product_category = ProductCategory.create!(name: 'test', code: 'test')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'test'
    product_category.destroy!

    expect { click_on 'Deletar' }.to raise_error NoMethodError
  end

  xscenario 'and it fails and redirects to not found page'
end
