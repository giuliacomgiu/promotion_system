require 'rails_helper'

feature 'Admin edits a promotion' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'there is an editing path' do
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    expect(page).to have_link('Editar',
                              href: edit_promotion_path(Promotion.last))
  end

  scenario 'and it succeeds' do
    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                  description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15,
                                  expiration_date: '22/12/2033', maximum_discount: 10)

    visit promotion_path(promotion)
    click_on 'Editar'

    fill_in 'Nome', with: 'Black Friday'
    fill_in 'Descrição', with: 'Promoção de Black Friday'
    fill_in 'Código', with: 'FRIDAY15'
    click_on 'Salvar promoção'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Black Friday')
    expect(page).to have_content('Promoção de Black Friday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('FRIDAY15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_link('Voltar')
  end

  scenario 'and fails if items are blank' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Valor máximo de desconto',	with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Salvar promoção'

    expect(page).to have_content('não pode ficar em branco', count: 6)
  end

  scenario 'and fails if code isnt unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)
    Promotion.create!(name: 'Natal Melhor', description: 'Promoção de Natal',
                      code: 'NATAL20', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar'

    fill_in 'Código', with: 'NATAL20'
    click_on 'Salvar promoção'

    expect(page).to have_content('já está em uso')
  end
end
