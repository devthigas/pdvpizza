# Criar usuários de teste
admin = User.find_or_initialize_by(email_address: "admin@pizzaria.com")
admin.name = "Administrador Master"
admin.password = "admin123"
admin.role = :admin
admin.active = true
admin.save!

operador = User.find_or_initialize_by(email_address: "op@pizzaria.com")
operador.name = "Operador de Caixa"
operador.password = "operador123"
operador.role = :operador
operador.active = true
operador.save!

cozinha = User.find_or_initialize_by(email_address: "chef@pizzaria.com")
cozinha.name = "Chef de Cozinha"
cozinha.password = "chef123"
cozinha.role = :cozinha
cozinha.active = true
cozinha.save!

puts "Usuários criados com sucesso!"

# Criar Categorias
cat_pizzas = Category.find_or_create_by!(name: "Pizzas", description: "Pizzas artesanais", position: 1, active: true)
cat_bebidas = Category.find_or_create_by!(name: "Bebidas", description: "Refrigerantes, sucos e cervejas", position: 2, active: true)
cat_sobremesas = Category.find_or_create_by!(name: "Sobremesas", description: "Doces e pizzas doces", position: 3, active: true)

puts "Categorias criadas com sucesso!"

# Criar Sabores de Pizza
sabores = [
  { name: "Calabresa", description: "Molho, mussarela, calabresa fatiada, cebola e orégano", ingredients: "calabresa, cebola, mussarela" },
  { name: "Margherita", description: "Molho, mussarela, rodelas de tomate, manjericão fresco e orégano", ingredients: "mussarela, tomate, manjericão" },
  { name: "Quatro Queijos", description: "Molho, mussarela, catupiry, provolone, gorgonzola e orégano", ingredients: "mussarela, catupiry, provolone, gorgonzola" },
  { name: "Frango com Catupiry", description: "Molho, mussarela, frango desfiado temperado, catupiry e orégano", ingredients: "frango, catupiry, mussarela" },
  { name: "Portuguesa", description: "Molho, mussarela, presunto, ovos, cebola, ervilha, azeitonas e orégano", ingredients: "presunto, ovos, cebola, ervilha, azeitonas, mussarela" },
  { name: "Chocolate", description: "Chocolate ao leite cremoso com granulado", ingredients: "chocolate, granulado" }
]

sabores.each do |s|
  Flavor.find_or_create_by!(name: s[:name]) do |f|
    f.description = s[:description]
    f.ingredients = s[:ingredients]
    f.active = true
  end
end

puts "Sabores criados com sucesso!"

# Criar Adicionais
adicionais = [
  { name: "Borda de Catupiry", description: "Borda recheada com catupiry original", price: 8.00 },
  { name: "Borda de Cheddar", description: "Borda recheada com queijo cheddar cremoso", price: 8.00 },
  { name: "Bacon Extra", description: "Porção extra de bacon crocante", price: 5.00 },
  { name: "Cebola Extra", description: "Cebola fatiada extra", price: 1.50 }
]

adicionais.each do |a|
  Additional.find_or_create_by!(name: a[:name]) do |ad|
    ad.description = a[:description]
    ad.price = a[:price]
    ad.active = true
  end
end

puts "Adicionais criados com sucesso!"

# Criar Clientes fictícios
clientes = [
  { name: "Thigas Dev", phone: "11999998888", address: "Rua do Código, 101", neighborhood: "Bairro Central", reference_point: "Perto do Terminal" },
  { name: "Maria Oliveira", phone: "11988887777", address: "Av. das Américas, 500", neighborhood: "Jardins", reference_point: "Ao lado da Farmácia" }
]

clientes.each do |c|
  Customer.find_or_create_by!(phone: c[:phone]) do |cust|
    cust.name = c[:name]
    cust.address = c[:address]
    cust.neighborhood = c[:neighborhood]
    cust.reference_point = c[:reference_point]
  end
end

puts "Clientes criados com sucesso!"

# Criar Mesas
(1..10).each do |num|
  DiningTable.find_or_create_by!(number: num) do |table|
    table.seats = num.even? ? 4 : 2
    table.status = :available
  end
end

puts "Mesas criadas com sucesso!"

# Criar Entregadores
entregadores = [
  { name: "Carlos Moto", phone: "11977776666" },
  { name: "Alex Bike", phone: "11966665555" }
]

entregadores.each do |e|
  DeliveryPerson.find_or_create_by!(phone: e[:phone]) do |dp|
    dp.name = e[:name]
    dp.active = true
  end
end

puts "Entregadores criados com sucesso!"

# Criar os Produtos (Pizzas e Bebidas)
# 1. Produto Pizza Salgada
p_salgada = Product.find_or_initialize_by(name: "Pizza Salgada")
p_salgada.category = cat_pizzas
p_salgada.description = "Monte sua pizza salgada escolhendo os sabores e adicionais."
p_salgada.is_pizza = true
p_salgada.unit = "un"
p_salgada.active = true

tamanhos_salgada = [
  { size_name: "P", price: 30.00, max_flavors: 1 },
  { size_name: "M", price: 42.00, max_flavors: 2 },
  { size_name: "G", price: 55.00, max_flavors: 2 },
  { size_name: "GG", price: 68.00, max_flavors: 2 }
]

tamanhos_salgada.each do |t|
  existing = p_salgada.product_sizes.find { |ps| ps.size_name == t[:size_name] }
  if existing
    existing.price = t[:price]
    existing.max_flavors = t[:max_flavors]
  else
    p_salgada.product_sizes.build(size_name: t[:size_name], price: t[:price], max_flavors: t[:max_flavors])
  end
end
p_salgada.save!

# 2. Produto Pizza Doce
p_doce = Product.find_or_initialize_by(name: "Pizza Doce")
p_doce.category = cat_sobremesas
p_doce.description = "Monte sua pizza doce."
p_doce.is_pizza = true
p_doce.unit = "un"
p_doce.active = true

tamanhos_doce = [
  { size_name: "P", price: 35.00, max_flavors: 1 },
  { size_name: "G", price: 60.00, max_flavors: 2 }
]

tamanhos_doce.each do |t|
  existing = p_doce.product_sizes.find { |ps| ps.size_name == t[:size_name] }
  if existing
    existing.price = t[:price]
    existing.max_flavors = t[:max_flavors]
  else
    p_doce.product_sizes.build(size_name: t[:size_name], price: t[:price], max_flavors: t[:max_flavors])
  end
end
p_doce.save!

# 3. Bebidas comuns
bebidas = [
  { name: "Coca-Cola 2L", barcode: "789123456001", sku: "COCA-2L", base_price: 10.00, cost_price: 5.50, current_stock: 100 },
  { name: "Guaraná 2L", barcode: "789123456002", sku: "GUAR-2L", base_price: 8.50, cost_price: 4.80, current_stock: 120 },
  { name: "Cerveja Heineken Long Neck", barcode: "789123456003", sku: "HEIN-LN", base_price: 9.00, cost_price: 5.00, current_stock: 80 },
  { name: "Água Mineral Sem Gás", barcode: "789123456004", sku: "AGUA-SG", base_price: 4.00, cost_price: 1.50, current_stock: 150 }
]

bebidas.each do |b|
  Product.find_or_create_by!(barcode: b[:barcode]) do |prod|
    prod.category = cat_bebidas
    prod.name = b[:name]
    prod.description = b[:name]
    prod.sku = b[:sku]
    prod.is_pizza = false
    prod.base_price = b[:base_price]
    prod.cost_price = b[:cost_price]
    prod.current_stock = b[:current_stock]
    prod.unit = "un"
    prod.min_stock = 10
    prod.active = true
  end
end

puts "Produtos (Pizzas e Bebidas) criados com sucesso!"
