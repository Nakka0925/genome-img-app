class Organism < ApplicationRecord
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      organism = find_by(replicon: row["replicon"]) || new
      organism.attributes = row.to_hash.slice(*updatable_attributes)
      organism.save
    end
  end

  def self.updatable_attributes
    ["replicon", "name", "classes"]
  end

end
