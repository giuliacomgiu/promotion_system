require 'rails_helper'

feature 'Curator attemps to delete an approved promotion' do
  let!(:creator) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and there is a delete button' do
    promotion = create :promotion, :with_product_category, :approved, creator: creator
    login_as(promotion.curator, scope: :user)

    visit promotion_path(promotion)

    expect(page).to have_link('Deletar')
  end

  scenario 'and succeeds' do
    promotion = create :promotion, :with_product_category, :approved, creator: creator
    login_as(promotion.curator, scope: :user)

    visit promotion_path(promotion)
    click_on 'Deletar'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end
end
