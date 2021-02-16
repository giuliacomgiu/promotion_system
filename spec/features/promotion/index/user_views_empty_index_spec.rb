require 'rails_helper'

feature 'User views empty index' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'and no promotions message are created' do
    login_as(user, scope: :user)

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    login_as(user, scope: :user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(page).to have_current_path root_path, ignore_query: true
  end
end
