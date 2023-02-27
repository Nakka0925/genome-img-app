class RenameGroupColumnToOrganisms < ActiveRecord::Migration[5.2]
  def change
    rename_column :organisms, :group, :class
  end
end
