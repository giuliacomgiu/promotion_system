require 'rails_helper'

def create_promotion_with_product_category
  create :product_category do |product_category|
    promotion = create :promotion, product_categories: [product_category]
  end
end

feature 'Admin views promotions' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and there is 1 previews on index' do
    create_promotion_with_product_category

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Wordpress')
    expect(page).to have_content('R$ 50,00') 
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y')) 

  end

  scenario 'and there are 2 previews on index' do
    create :product_category do |product_category|
      create :promotion, product_categories: [product_category]
      create :promotion, name: 'Cyber Monday', code: 'CYBER', product_categories: [product_category]
    end

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('10,00%', count: 2)
    expect(page).to have_content('Wordpress', count: 2)
    expect(page).to have_content('R$ 50,00', count: 2) 
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'), count: 2) 

  end

  scenario 'and no promotion are created' do
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and view details' do
    create_promotion_with_product_category

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_content('Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('NATAL10')
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y')) 
    expect(page).to have_content('5')
    expect(page).to have_content('50') 
  end

  scenario 'and return to promotions page' do
    create_promotion_with_product_category

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end
