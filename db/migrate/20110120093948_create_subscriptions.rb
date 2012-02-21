class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :status
      t.string :plan_id
      t.string :sub_id
      t.string :cc_token
      t.string :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
