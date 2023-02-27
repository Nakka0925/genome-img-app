class RenameClassColumnToOrganisms < ActiveRecord::Migration[5.2]
  def change
    rename_column :organisms, :class, :classes
  end
end
