class Merchant < ActiveRecord::Base
  validates_presence_of :email
  validates_presence_of :login_id
  validates_presence_of :business_name
  validates_presence_of :business_phone
  validates_presence_of :business_type
  validates_presence_of :contact_name
  validates_format_of :contact_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"
end
