require 'csv'

head = CSV.table("/home/nakanishi/rails/genome-img-app/db/csv/creatures.csv").headers.push("img_path")

CSV.open("/home/nakanishi/rails/genome-img-app/db/csv/write-sample.csv", "w") do |test|
    test << head
    CSV.foreach("/home/nakanishi/rails/genome-img-app/db/csv/creatures.csv", headers: true) do |row|
        test << row.push("/db/img/#{row[1]}.png")
    end
end