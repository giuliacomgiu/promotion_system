require 'rails_helper'

feature 'Creator views a pending promotion' do

  let!(:user){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'and view details' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_content(promotion.name)
    expect(page).to have_content('10,00%')
    expect(page).to have_content(promotion.code)
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y')) 
    expect(page).to have_content('5')
    expect(page).to have_content('50') 
    expect(page).to have_content "Criada por: #{user.email}"
  end

  scenario 'there is a pending message' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit promotions_path
    click_on promotion.name

    expect(page).to have_content 'Aguardando aprovação'
  end

  scenario 'and creator cant approve own promotion' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit promotions_path
    click_on promotion.name

    expect(page).not_to have_link 'Aprovar'
  end

  scenario 'and return to promotions page' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit promotions_path
    click_on promotion.name
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end