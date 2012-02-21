class HomeController < ApplicationController
  def index
    logger.info Braintree::Address::CountryNames
  end

end
