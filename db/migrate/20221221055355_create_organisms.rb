class CreateOrganisms < ActiveRecord::Migration[5.2]
  def change
    create_table :organisms do |t|
      t.string :replicon
      t.string :name
      t.string :group

      t.timestamps
    end
  end
end
