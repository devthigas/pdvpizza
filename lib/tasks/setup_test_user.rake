namespace :db do
  desc "Garante a existencia de um usuario administrador para testes no deploy"
  task setup_test_user: :environment do
    email = "admin@pizzaria.com"
    password = ENV.fetch("ADMIN_PASSWORD", "admin123")
    name = "Administrador"

    user = User.find_or_initialize_by(email_address: email)

    if user.new_record?
      user.name = name
      user.password = password
      user.password_confirmation = password
      user.role = :admin
      user.active = true

      if user.save
        puts "[Setup Test User] Usuario administrador (#{email}) criado com sucesso!"
      else
        puts "[Setup Test User] Erro ao criar o usuario administrador: #{user.errors.full_messages.join(', ')}"
      end
    else
      puts "[Setup Test User] Usuario administrador (#{email}) ja existe. Nenhuma acao necessaria."
    end
  end
end
