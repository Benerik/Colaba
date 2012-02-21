class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      t.string :email
      t.string :login_id
      t.string :customer_id
      t.string :business_name
      t.string :business_phone
      t.integer :business_type
      t.string :contact_name
      t.string :contact_email
      t.boolean :tc_accepted
      t.boolean :is_active
      t.datetime :create_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :merchants
  end
end
