require 'rails_helper'

feature 'Admin searches for a coupon' do
  background do
    user = User.create!(email: 'teste@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'successfully' do
    promo = Promotion.create!(name: 'Pascoa', coupon_quantity: 2,
                              discount_rate: 10, code: 'PASCOA10',
                              expiration_date: 1.day.from_now)
    Coupon.create!([{ promotion: promo, code: 'PASCOA10-0001' },
                    { promotion: promo, code: 'PASCOA10-0002' }])

    visit root_path

    fill_in 'Buscar cupom',	with: 'PASCOA10'
    click_on 'Buscar'

    expect(page).to have_content 'PASCOA10-0001'
    expect(page).to have_content 'PASCOA10-0002'
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and displays blank message' do
    visit root_path

    fill_in 'Buscar cupom',	with: 'PASCOA10'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum resultado foi encontrado'
    expect(page).to have_link('Voltar', href: root_path)
  end
end
