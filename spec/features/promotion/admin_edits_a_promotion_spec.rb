require 'rails_helper'

feature 'Admin edits a promotion' do

  let!(:creator){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'there is an editing path' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_link('Editar',
                              href: edit_promotion_path(promotion))
  end

  scenario 'and it succeeds' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotion_path(promotion)
    click_on 'Editar'

    fill_in 'Nome', with: 'Black Friday'
    fill_in 'Descrição', with: 'Promoção de Black Friday'
    fill_in 'Código', with: 'FRIDAY15'
    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Black Friday')
    expect(page).to have_content('Promoção de Black Friday')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('R$ 50,00')
    expect(page).to have_content('FRIDAY15')
    expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
    expect(page).to have_content('5')
    expect(page).to have_link('Voltar')
  end

  scenario 'and fails if items are blank' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

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
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 6)
  end

  scenario 'and fails if code isnt unique' do
    login_as(creator, scope: :user)
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10, creator: creator)
    Promotion.create!(product_categories: [product], name: 'Natal Melhor', description: 'Promoção de Natal',
                      code: 'NATAL20', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10, creator: creator)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar'

    fill_in 'Código', with: 'NATAL20'
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
