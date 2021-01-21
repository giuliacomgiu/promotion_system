require 'rails_helper'

feature 'Promotion has a creator' do
  scenario 'and creator is maria@locaweb.com.br' do
    user = User.create!(email: 'maria@locaweb.com.br', password: 'f4k3p455w0rd')
    @promotion = Promotion.create!(name: 'NATALMELHOR', description: 'Promoção de Natal',
                      code: 'NATAL17', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: 1.day.from_now, maximum_discount: 10,
                      creator: user)
    
    login_as(user, scope: :user)
    visit promotion_path(@promotion)

    expect(page).to have_content('Criada por: maria@locaweb.com.br')
  end

  scenario 'and approval is pending' do
    user = User.create!(email: 'maria@locaweb.com.br', password: 'f4k3p455w0rd')
    @promotion = Promotion.create!(name: 'NATALMELHOR', description: 'Promoção de Natal',
                      code: 'NATAL17', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: 1.day.from_now, maximum_discount: 10,
                      creator: user)
    
    login_as(user, scope: :user)
    visit promotion_path(@promotion)

    expect(page).not_to have_link('Aprovar')
    expect(page).to have_content('Aprovação pendente') 
  end
end