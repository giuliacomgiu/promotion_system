require 'rails_helper'

feature 'User tries to edit an approved promotion spec' do
  let!(:user) { create :user }
  let!(:creator) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and user fails' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit promotion_path(promotion)

    expect(page).not_to have_link('Editar', href: edit_promotion_path(promotion))
  end

  scenario 'and cant visit path directly' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit edit_promotion_path(promotion)

    expect(page).to have_http_status :forbidden
  end

  xscenario 'and there is a forbidden alert' do
    # TODO: solve redirecting issue on redirect_back method
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit edit_promotion_path(promotion)

    expect(page).to have_content 'Forbidden'
  end
end
