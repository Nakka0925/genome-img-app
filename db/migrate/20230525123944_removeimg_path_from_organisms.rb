class RemoveimgPathFromOrganisms < ActiveRecord::Migration[5.2]
  def change
    remove_column :organisms, :img_path, :string
  end
end
