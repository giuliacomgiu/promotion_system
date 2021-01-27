require 'rails_helper'


feature 'Promotion has a creator' do
  #TODO: figure out why let() doesnt work
  let!(:user){ create :user, email: 'maria@locaweb.com.br' }
  let!(:product_category){ create :product_category }

  scenario 'creator added successfully' do
    login_as(user, scope: :user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Desconto', with: '10'
    fill_in 'Valor máximo de desconto (R$)', with: '50'
    fill_in 'Quantidade de cupons', with: '5'
    fill_in 'Data de término', with: 1.day.from_now.strftime('%d/%m/%Y')
    check product_category.name
    click_on 'Salvar'

    expect(page).to have_content "Criada por: #{user.email}"
  end

  scenario 'there is a pending message' do
    login_as(user, scope: :user)
    promotion = create :promotion, :with_product_category, creator: user

    visit promotions_path
    click_on promotion.name

    expect(page).to have_content 'Aguardando aprovação'
    expect(page).not_to have_link 'Aprovar'
  end
end