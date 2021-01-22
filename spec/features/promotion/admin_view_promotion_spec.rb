require 'rails_helper'

feature 'Admin views promotions' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and there is 1 previews on index' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Wordpress')
    expect(page).to have_content('R$ 10,00') 
    expect(page).to have_content('22/12/2033') 

  end

  scenario 'and there are 2 previews on index' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)
    Promotion.create!(product_categories: [product], name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('Wordpress', count: 2)
    expect(page).to have_content('R$ 10,00', count: 2) 
    expect(page).to have_content('22/12/2033', count: 2) 

  end

  scenario 'and no promotion are created' do
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and view details' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)
    Promotion.create!(product_categories: [product], name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
  end

  scenario 'and return to promotions page' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promotion = Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: '22/12/2033', maximum_discount:10)

    visit promotion_path(promotion)
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end
