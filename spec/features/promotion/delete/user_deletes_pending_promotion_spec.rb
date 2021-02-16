require 'rails_helper'

feature 'User attempts to delete a promotion' do
  let!(:creator) { create :user, email: 'maria@locaweb.com.br' }
  let!(:user) { create :user, email: 'user@locaweb.com.br' }

  scenario 'there is no deletion path' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).not_to have_link('deletar',
                                  href: promotion_path(promotion))
  end
end
