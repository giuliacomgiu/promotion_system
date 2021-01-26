require 'rails_helper'

feature 'Promotion has a curator' do
  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }
  let!(:curator){ create :user, email: 'dandara@locaweb.com.br' }
  let!(:product_category){ create :product_category }
  let!(:promotion){ create :promotion, product_categories: [product_category], creator: creator }

  scenario 'and approves promotion' do
    login_as(curator, scope: :user)
    
    visit promotions_path
    click_on promotion.name
    click_on 'Aprovar'

    expect(page).to have_content 'Promoção aprovada com sucesso'
    expect(page).to have_content "Aprovada por: #{curator.email}"
    expect(page).not_to have_link 'Aprovar'
    expect(promotion.reload.curator).to be_present
  end
end