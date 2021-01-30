require 'rails_helper'

feature 'Curator tries to edit an approved promotion spec' do

  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'and fails' do
    promotion = create :promotion, :with_product_category, :approved, creator: creator
    login_as(promotion.curator, scope: :user)

    visit promotion_path(promotion)

    expect(page).not_to have_link('Editar', href: edit_promotion_path(promotion)) 
  end

  scenario 'and cant visit path directly' do
    promotion = create :promotion, :with_product_category, :approved, creator: creator
    login_as(promotion.curator, scope: :user)

    visit edit_promotion_path(promotion)

    expect(page).to have_http_status :forbidden
  end

  xscenario 'and there is a forbidden alert' do
    #TODO: solve redirecting issue on redirect_back method
    promotion = create :promotion, :with_product_category, :approved, creator: creator
    login_as(promotion.curator, scope: :user)

    visit edit_promotion_path(promotion)

    expect(page).to have_content 'Forbidden'
  end
end