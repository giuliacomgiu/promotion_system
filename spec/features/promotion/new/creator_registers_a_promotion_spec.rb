require 'rails_helper'

feature 'Creator registers a promotion' do
  let!(:user){ create :user, email: 'maria@locaweb.com.br' }

  scenario 'from index page' do
    login_as(user, scope: :user)

    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Cadastrar promoção', href: new_promotion_path)
  end

  scenario 'all fields are filled correctly with 1 product category' do
    login_as(user, scope: :user)
    product_category = create :product_category

    visit promotions_path
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Valor máximo de desconto (R$)', with: '20'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check product_category.name
    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_content('Wordpress')
    expect(page).to have_content "Criada por: #{user.email}"
    expect(page).to have_link('Voltar')
  end

  scenario 'and there are 2 product categories' do
    login_as(user, scope: :user)
    category1 = create :product_category
    category2 = create :product_category, name: 'Email', code: 'MAILER'

    visit promotions_path
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Valor máximo de desconto (R$)', with: '20'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check category1.name
    check category2.name
    click_on 'Salvar'

    expect(page).to have_content('Wordpress')
    expect(page).to have_content('Email')
  end

  scenario 'and attributes cannot be blank' do
    login_as(user, scope: :user)

    visit promotions_path
    click_on 'Cadastrar promoção'
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 7)
  end

  scenario 'and code must be unique' do
    login_as(user, scope: :user)

    create :product_category
    promotion = create :promotion, :with_product_category, creator: user

    visit root_path
    click_on 'Promoções'
    click_on 'Cadastrar promoção'
    fill_in 'Código', with: promotion.code
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
