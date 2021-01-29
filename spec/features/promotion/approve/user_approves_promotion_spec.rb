require 'rails_helper'

feature 'User approves promotion' do
  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }
  let!(:curator){ create :user, email: 'dandara@locaweb.com.br' }

  scenario 'and succeeds' do
    login_as(curator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotions_path
    click_on promotion.name
    click_on 'Aprovar'

    expect(page).to have_content 'Promoção aprovada com sucesso'
    expect(page).to have_content "Aprovada por: #{curator.email}"
    expect(page).not_to have_link 'Aprovar'
    expect(promotion.reload.curator).to be_present
  end
end