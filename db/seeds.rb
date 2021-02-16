creator = User.create!(email: 'creator@locaweb.com.br', password: '123456')

curator = User.create!(email: 'curator@locaweb.com.br', password: '123456')

product_categories = ProductCategory.create!([{name: 'Wordpress', code: 'WORDP'},
                                              {name: 'Email', code: 'EMAIL'}])

# Pending promotion
Promotion.create!(name: 'Natal Dez', description: 'O espírito natalino na Locaweb!',
                  code: 'NATAL10', discount_rate: 5, coupon_quantity: 10,
                  maximum_discount: 20, expiration_date: 1.day.from_now,
                  product_category_ids: product_categories.map(&:id), creator: creator)

# Expired pending promotion
Promotion.create!(name: 'Pascoa Dez', description: 'O espírito natalino na Locaweb!',
                  code: 'PASCOA10', discount_rate: 5, coupon_quantity: 10,
                  maximum_discount: 20, expiration_date: 1.year.ago,
                  product_category_ids: product_categories.map(&:id), creator: creator)

# Approved promotion
Promotion.create!(name: 'Carnaval Dez', description: 'O espírito natalino na Locaweb!',
                  code: 'CARNA10', discount_rate: 5, coupon_quantity: 10,
                  maximum_discount: 20, expiration_date: 1.day.from_now, curator: curator,
                  product_category_ids: product_categories.map(&:id), creator: creator)

# Approved promotion with coupons
promo = Promotion.create!(name: 'Locaweb Dez', description: 'O espírito natalino na Locaweb!',
                          code: 'LOCAW10', discount_rate: 5, coupon_quantity: 3,
                          maximum_discount: 20, expiration_date: 1.day.from_now, curator: curator,
                          product_category_ids: product_categories.map(&:id), creator: creator)
promo.coupons.create!([{code: 'LOCAW10-0001'}, 
                       {code: 'LOCAW10-0002', status: :archived},
                       {code: 'LOCAW10-0003', status: :burned, order: '12345'}])