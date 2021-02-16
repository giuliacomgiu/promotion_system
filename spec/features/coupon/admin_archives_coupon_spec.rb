require 'rails_helper'

feature 'Admin archives coupon' do
  let!(:user) { create :user, email: 'maria@locaweb.com.br' }

  scenario 'successfully' do
    # TODO: does promotion have to be approved?
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, :with_coupons, coupon_quantity: 1, creator: user
    coupon = promotion.coupons.first

    visit promotion_path(promotion)
    click_on 'Arquivar'

    expect(page).to have_content('Cupom arquivado com sucesso')
    expect(page).to have_content('NATAL10-0001 (Arquivado)')
    expect(page).not_to have_link('Arquivar')
    expect(coupon.reload).to be_archived
  end

  scenario 'but cant archive burned coupon' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, :with_coupons, coupon_quantity: 1, creator: user
    coupon = promotion.coupons.first
    coupon.burned!

    visit promotion_path(promotion)

    expect(page).to have_content("#{coupon.code} (Utilizado)")
    expect(page).not_to have_link('Arquivar')
  end
end
