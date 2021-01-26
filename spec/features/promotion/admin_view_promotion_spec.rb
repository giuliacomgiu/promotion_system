require 'rails_helper'

def create_promotion_with_product_category
  create :product_category do |product_category|
    promotion = create :promotion, product_categories: [product_category]
  end
end

feature 'Admin views promotions' do

  let!(:user){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'and there is 1 previews on index' do
    login_as(user, scope: :user)
    create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Wordpress')
    expect(page).to have_content('R$ 50,00') 
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y')) 

  end

  scenario 'and there are 2 previews on index' do
    login_as(user, scope: :user)
    create :product_category do |product_category|
      create :promotion, product_categories: [product_category], creator: user
      create :promotion, name: 'Cyber Monday', code: 'CYBER', 
                         product_categories: [product_category], creator: user
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
    login_as(user, scope: :user)
  
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    login_as(user, scope: :user)
  
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and view details' do
    login_as(user, scope: :user)
    create :promotion, :with_product_category, creator: user

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
    login_as(user, scope: :user)
    create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end
