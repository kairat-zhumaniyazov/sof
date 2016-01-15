class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :value, default: 0
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
