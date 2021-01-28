require 'rails_helper'

feature 'Creator deletes a promotion' do
  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'and it succeeds' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Deletar'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and it fails, so not found page is rendered' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotion_path(promotion.name)
    promotion.destroy!
    click_on 'Deletar'

    expect(page).to have_content '404'
  end
end
