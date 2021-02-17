# LocaPromo

![Badge](https://img.shields.io/static/v1?label=build&message=passing&color=green)
![Badge](https://img.shields.io/static/v1?label=coverage&message=99.49%&color=green)

Este é um sistema de gerenciamento de promoções, cupons e categorias de produtos. Nele, um usuário autorizado com e-mail '@locaweb.com.br' pode:
- Cadastrar, Visualizar, Editar e Deletar uma Categoria de Produto
- Cadastrar, Visualizar, Editar, Deletar, Buscar e Aprovar uma Promoção, desde que vinculada a uma Categoria de Produto
- Emitir cupons para a promoção, caso esteja aprovada.
- Buscar, Arquivar e Reativar um cupom

Há também uma api onde podem ser verificada validade de um cupom, bem como realizar sua "queima", ou seja, utilizá-lo efetivamente caso um código de compra e uma categoria de produto sejam fornecidos.


## Gerenciamento de Promoção
Criação, edição, aprovação e exclusão de promoções, com um nome, descrição (opcional), código, quantidade de cupons, desconto (%), valor máximo de desconto (R$), prazo de expiração.
Além disso, toda promoção precisa ter ao menos uma categoria de produto. Ela tem um criador e deve ser aprovada por um curador. Após sua aprovação, é impossível editá-la.

## Cupom
Os cupons são atrelados a uma e somente uma promoção específica. Ele pode estar ativo, arquivado ou queimado e inclui um código gerado à partir da promoção, uma ordem de compra em caso de "queima" e um status (Ativo, arquivado, queimado).

É possível ver os dados do cupom através de uma requisição `GET` na url `http://localhost:3000/api/v1/coupons/:code`. Ela retornará dados da forma:
```
{
  "status": "expired",
  "discount_rate": "5.0",
  "expiration_date": "17/02/2021",
  "maximum_discount": "R$ 20.0"
}
```

Para fazer a queima de um cupom, é preciso fazer um `PATCH` na url `http://localhost:3000/api/v1/coupons/:code`, incluindo no corpo da mensagem a ordem de compra e a categoria do produto que deseja utilizar o cupom, como no exemplo:
```
{ 
  order: { 
    code: 'ORDER123' 
  },
  product_category: { 
    code: '1234' 
  } 
}
```
A queima falhará caso algum destes parâmetros falhe ou caso a categoria de produto não seja válida para aquele cupom/promoção.

## Categoria de produto
Gerenciamento de categorias de produtos, que incluem nome e código. Caso seja deletada, todas as promoções pertencentes a ela e somente ela serão excluídas também.

# Dependências
 - Ruby 2.7.2
 - Rails 6.1.1
 - Yarn 1.22.5
 - Node 12.18.3

# Tecnologias utilizadas
 - Capybara
 - Devise
 - Factory-bot-rails
 - RSpec
 - Rubocop
 - SimpleCov

# Execução
## Da aplicação

Para executar o programa, clone o projeto em sua máquina e instale as dependências citadas acima,
```
git clone git@qsd.campuscode.com.br:giuliacomgiu/promotion-system-vfix.git
```
Para configurar o projeto, execute o comando 
```
bin/setup
```

Caso deseje popular o banco de dados, execute o comando 
```
rails db:setup
```

Finalmente, execute o comando 
```
rails s
``` 
E acesse o endereço `http://localhost:3000/`!

## Dos testes
No terminal, digite o comando 
```
rspec
```

E para testar a sintaxe, formatação, etc, digite
```
rubocop
```

# Autora
Giulia Ciprandi @giuliacomgiu