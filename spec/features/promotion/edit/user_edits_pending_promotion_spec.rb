require 'rails_helper'

feature 'User attempts to edit a promotion' do
  let!(:creator) { create :user, email: 'maria@locaweb.com.br' }
  let!(:user) { create :user, email: 'user@locaweb.com.br' }

  scenario 'there is no editing path' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).not_to have_link('Editar',
                                  href: edit_promotion_path(promotion))
  end

  scenario 'cant visit path directly' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit edit_promotion_path(promotion)

    expect(page).to have_http_status :forbidden
  end

  xscenario 'there is forbidden alert' do
    # TODO: solve redirecting issue on redirect_back method
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit edit_promotion_path(promotion)

    expect(page).to have_content 'Forbidden'
  end

  xscenario 'and there is a forbidden alert' do
    # TODO: solve redirecting issue on redirect_back method
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit edit_promotion_path(promotion)

    expect(page).to have_content 'Forbidden'
  end
end
