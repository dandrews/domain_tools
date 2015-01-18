class CreateDomainNames < ActiveRecord::Migration
  def change
    create_table :domain_names do |t|
      t.string :name
      t.string :tlds, array: true, default: []

      t.timestamps
    end
  end
end
