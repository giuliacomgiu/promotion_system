# LocaPromo

Este é um sistema de gerenciamento de promoções, cupons e categorias de produtos. Nele, um usuário autorizado com e-mail '@locaweb.com.br' pode:
- Cadastrar, Visualizar, Editar e Deletar uma Categoria de Produto
- Cadastrar, Visualizar, Editar, Deletar, Buscar e Aprovar uma Promoção, desde que vinculada a uma Categoria de Produto
- Emitir cupons para a promoção, caso esteja aprovada.
- Buscar, Arquivar e Reativar um cupom

Há também uma api onde podem ser verificada validade de um cupom, bem como realizar sua "queima", ou seja, utilizá-lo efetivamente caso um código de compra e uma categoria de produto sejam fornecidos.

## Promoção

Toda promoção tem:
- Nome
- Descrição (opcional)
- Código
- Quantidade de cupons
- Desconto (%)
- Valor máximo de desconto (R$)
- Prazo de expiração
- Categoria(s) de produto(s)
- Criador
- Curador

## Cupom

Todo cupom tem:
- Código
- Ordem de compra (em caso de "queima")
- Status (Ativo, arquivado, queimado)

## Categoria de produto

Toda categoria de produto tem:
- Nome
- Código

# Dependências

Ruby 2.7.2
Rails 6.1.1
Rspec-rails 4.0.1
Capybara
Devise
Factory-bot-rails

# Execução

Para executar o programa, clone o projeto em sua máquina, execute o comando `bin/setup`, execute o comando `rails s` e acesse o endereço http://localhost:3000/