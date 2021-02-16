require 'rails_helper'

feature 'User attemps to delete an approved promotion' do
  let!(:user) { create :user }
  let!(:creator) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and there is no delete button' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit promotion_path(promotion)

    expect(page).not_to have_link('Deletar')
  end
end
