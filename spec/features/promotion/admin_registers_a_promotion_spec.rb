require 'rails_helper'

feature 'Admin registers a promotion' do
  background do
    user = User.create!(email: 'test@locaweb.com.br', password: 'f4k3p455w0rd')
    login_as(user, scope: :user)
  end

  scenario 'from index page' do
    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Cadastrar promoção',
                              href: new_promotion_path)
  end

  scenario 'successfully with 1 product category' do
    ProductCategory.create!(name: 'Wordpress', code: 'WORDP')

    visit promotions_path
    click_on 'Cadastrar promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Valor máximo de desconto (R$)', with: '20'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check 'Wordpress'
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
    expect(page).to have_link('Voltar')
  end

  scenario 'successfully with 2 product categories' do
    ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    ProductCategory.create!(name: 'Email', code: 'MAILER')

    visit promotions_path
    click_on 'Cadastrar promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Valor máximo de desconto (R$)', with: '20'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check 'Wordpress'
    check 'Email'
    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_content('Email')
    expect(page).to have_content('Wordpress')
    expect(page).to have_link('Voltar')
  end

  scenario 'and attributes cannot be blank' do
    visit promotions_path
    click_on 'Cadastrar promoção'
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 7)
  end

  scenario 'and code must be unique' do
    product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
    Promotion.create!(product_categories: [product], name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', maximum_discount: 10)

    visit root_path
    click_on 'Promoções'
    click_on 'Cadastrar promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Salvar'

    expect(page).to have_content('já está em uso')
  end
end
