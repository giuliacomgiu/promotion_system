require 'rails_helper'

feature 'Admin deletes a promotion' do
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
end
