class PagesController < ApplicationController
  layout false

  def home
    render template: "pages/home"
  end
end
