require 'rails_helper'

feature 'Admin views promotions on index' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and there is 1 preview on index' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content(promotion.name)
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Wordpress')
    expect(page).to have_content('R$ 50,00')
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
    expect(page).to have_content('Aguardando aprovação')
    expect(page).not_to have_link 'Aprovar'
  end

  scenario 'and there are 2 previews on index' do
    login_as(user, scope: :user)
    promotions = create_list :promotion, 2, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content(promotions[0].name)
    expect(page).to have_content(promotions[1].name)
    expect(page).to have_content('10,00%', count: 2)
    expect(page).to have_content('Wordpress', count: 2)
    expect(page).to have_content('R$ 50,00', count: 2)
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'), count: 2)
    expect(page).to have_content('Aguardando aprovação', count: 2)
    expect(page).not_to have_link('Aprovar', count: 2)
  end
end
