class Subscription < ActiveRecord::Base
  attr_accessor :billing_first_name, :billing_last_name,
          :credit_card_name, :credit_card_type, :credit_card_number, :credit_card_month, :credit_card_year,
          :credit_card_cvv_code, :credit_card_expire,
          :billing_first_name, :billing_last_name, :billing_country,
          :billing_company, :billing_address, :billing_address2, :billing_city,
          :billing_state, :billing_zipcode, :fee
  validates_presence_of :credit_card_number
  validates_presence_of :credit_card_name
  validates_presence_of :credit_card_type
  validates_presence_of :credit_card_month, :credit_card_year, :credit_card_cvv_code
  validates_presence_of :billing_first_name, :billing_last_name, :billing_country,
          :billing_address, :billing_city, :billing_state, :billing_zipcode


  validate :expiration_date_cannot_be_in_the_past
  def expiration_date_cannot_be_in_the_past
    errors.add(:credit_card_expire, "can't be in the past") if
      !credit_card_month.blank? and !credit_card_year.blank? and (Integer(credit_card_year) < Date.today.year() or (Integer(credit_card_year) ==Date.today.year() and Integer(credit_card_month) < Date.today.month()))
  end

end
