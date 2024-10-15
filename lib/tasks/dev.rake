namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    
    if Rails.env.development?
      show_spinner("Apagando Banco de Dados ...") do
        %x(rails db:drop)
      end

      # Outra forma de mandar o parametro do yeld para o spinner equivalente ao do/end
      show_spinner("Criando Banco de Dados ...") { %x(rails db:create) }

      show_spinner("Migrando banco de dados ..."){ %x(rails db:migrate) }

      show_spinner("Populando banco de dados ..."){ %x(rails dev:add_default_admin dev:add_default_user) }
    else
      puts "Você não esta no ambiente de desenvolvimento."
    end
  end

  desc "Adiciona administrador padrao"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD, 
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona usuário padrao"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD, 
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
