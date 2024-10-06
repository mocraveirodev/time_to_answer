class WelcomeController < ApplicationController
  http_basic_authenticate_with name: "monica", password: "12345678"
  def index
  end
end
