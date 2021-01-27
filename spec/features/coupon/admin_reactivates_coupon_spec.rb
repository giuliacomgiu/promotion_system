require 'rails_helper'

feature 'Admin attemps to reactivate coupon' do

  let!(:user){ create :user }

  scenario 'and there is a reactivate button' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, creator: user
    coupon = create :coupon, :archived, promotion: promotion

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_content coupon.code
    expect(page).to have_link 'Reativar'
  end

  scenario 'and succeeds if coupon is archived' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, creator: user
    coupon = create :coupon, :archived, promotion: promotion

    visit promotion_path(promotion)
    click_on 'Reativar'

    expect(page).to have_content 'Cupom reativado com sucesso'
    expect(page).to have_content 'Disponível'
    expect(page).to have_link 'Arquivar'
    expect(coupon.reload).to be_active
  end

  scenario 'and succeeds if coupon is burned' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, creator: user
    coupon = create :coupon, :burned, promotion: promotion

    visit promotion_path(promotion)
    click_on 'Reativar'

    expect(page).to have_content 'Cupom reativado com sucesso'
    expect(page).to have_content 'Disponível'
    expect(page).to have_link 'Arquivar'
    expect(coupon.reload).to be_active
  end

  scenario 'and cant do it if coupon is active' do
    login_as user, scope: :user
    promotion = create :promotion, :with_product_category, creator: user
    create :coupon, promotion: promotion

    visit promotion_path(promotion)

    expect(page).not_to have_link 'Reativar'
  end
end
