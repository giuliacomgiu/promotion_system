require 'rails_helper'

feature 'Admin archives coupon' do
  background do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    login_as user, scope: :user
  end

  scenario 'successfully' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    promotion = Promotion.create!(product_categories: [product], name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday', code: 'CYBER15', 
                      discount_rate: 15, expiration_date: '22/12/2033', maximum_discount: 10)
    coupon = Coupon.create!(promotion: promotion, code: 'CYBER15-0001')

    visit promotion_path(promotion)
    click_on 'Arquivar'

    expect(page).to have_content('Cupom arquivado com sucesso')
    expect(page).to have_content('CYBER15-0001 (Arquivado)')
    expect(page).not_to have_link('Arquivar')
    expect(coupon.reload).to be_archived
  end
end
