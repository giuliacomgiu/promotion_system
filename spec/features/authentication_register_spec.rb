require 'rails_helper'

feature 'Registers' do
  scenario 'and fails if domain is not locaweb.com.br' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Email', with: 'teste@email.com.br'
    fill_in 'Senha', with: 'teste1'
    fill_in 'Confirme sua senha', with: 'teste1'
    click_on 'Cadastrar'

    expect(page).to have_current_path '/users'
    expect(page).to have_content('Email não é válido')
  end

  scenario 'and password cant be blank' do
    visit new_user_registration_path
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Cadastrar'

    expect(page).to have_current_path '/users'
    expect(page).to have_content('Password não pode ficar em branco')
  end

  scenario 'successfully' do
    visit new_user_registration_path
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: 'teste1'
    fill_in 'Confirme sua senha', with: 'teste1'
    click_on 'Cadastrar'

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('teste@locaweb.com.br')
    expect(page).not_to have_link('Login')
    expect(page).to have_link('Sair')
  end
end
