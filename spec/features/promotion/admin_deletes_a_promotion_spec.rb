require 'rails_helper'

feature 'Admin deletes a promotion' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'and it succeeds' do
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'
    click_on 'Deletar'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and it fails, so not found page is rendered' do
    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                  description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15,
                                  expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'
    promotion.destroy!
    click_on 'Deletar'

    expect(page).to have_content '404'
  end
end
