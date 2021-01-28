require 'rails_helper'

feature 'Creator edits a promotion' do

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

  scenario 'and succeeds if admin is the promotion creator' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotion_path(promotion)
    click_on 'Editar'

    fill_in 'Nome', with: 'Black Friday'
    fill_in 'Descrição', with: 'Promoção de Black Friday'
    fill_in 'Código', with: 'FRIDAY15'
    fill_in 'Desconto', with: '15'
    fill_in 'Valor máximo de desconto',	with: '20'
    fill_in 'Quantidade de cupons', with: '2'
    fill_in 'Data de término', with: 2.day.from_now.strftime('%d/%m/%Y')
    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Black Friday')
    expect(page).to have_content('Promoção de Black Friday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('FRIDAY15')
    expect(page).to have_content(2.day.from_now.strftime('%d/%m/%Y'))
    expect(page).to have_content('2')
    expect(page).to have_link('Voltar')
  end

  scenario 'and fails if items are blank' do
    login_as(creator, scope: :user)
    promotion = create :promotion, :with_product_category, creator: creator

    visit promotion_path(promotion)
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
    promotions = create_list :promotion, 2, :with_product_category, creator: creator

    visit promotion_path(promotions[0])
    click_on 'Editar'

    fill_in 'Código', with: promotions[1].code
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
