require 'rails_helper'

feature 'Creator attemps to delete an approved promotion' do

  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'and there is a delete button' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit promotion_path(promotion)

    expect(page).to have_link('Deletar')
  end

  scenario 'and succeeds' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, :approved, creator: creator

    visit promotion_path(promotion)
    click_on 'Deletar'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end
end
