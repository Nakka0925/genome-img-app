class AddPathToOrganisms < ActiveRecord::Migration[5.2]
  def change
    add_column :organisms, :img_path, :string
  end
end
