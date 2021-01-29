require 'rails_helper'

feature 'User views a pending promotion' do

  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }
  let!(:user){ create :user, email: 'user@locaweb.com.br' }

  scenario 'and view details' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_content(promotion.name)
    expect(page).to have_content('10,00%')
    expect(page).to have_content(promotion.code)
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y')) 
    expect(page).to have_content('5')
    expect(page).to have_content('50') 
    expect(page).to have_content "Criada por: #{creator.email}"
  end

  scenario 'and can approve promotion' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotions_path
    click_on promotion.name

    expect(page).to have_link 'Aprovar'
  end

  scenario 'and return to promotions page' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotions_path
    click_on promotion.name
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end