require 'mizlab'
require 'csv'
require 'bio'
require 'json'
require 'net/http'
require 'uri'

class Genome
    # def get_seq(acc)
    #     ent = Mizlab.getobj(acc)
    #     return  ent.seq
    # end

    def parse(entries)
        Bio::FlatFile.auto(StringIO.new(entries)).each_entry do |e|
          yield e
        end
    end

    def get_seq(acc)
        # GenBank形式のファイルを開く
        gb_file =  Bio::NCBI::REST::EFetch.nucleotide(acc)
        if !gb_file.match?("complete genome")
            return false
        else 
            parse(gb_file) do |entry|
                # エントリーの情報を表示する
                # puts "Definition: #{entry.definition}"
                # puts "Accession: #{entry.accession}"
                return entry.naseq
            end
        end
    end

    def deepL(acc)

        seq = get_seq(acc)

        return false if seq == false  

        uri = URI.parse("https://train-api-y1sk.onrender.com/")
        request = Net::HTTP::Get.new(uri)

        request.content_type = "application/json"
        request.body = JSON.dump({
            "#{acc}" => "#{seq}"
        })
        

        req_options = {
            use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
        
        # label番号から分類情報を求める
        res = response.body.delete("^0-9").to_i
        data = Hash.new()
        File.open("lib/machine-genome-classification/data/json/label.json") do |f|
            data = JSON.load(f)
        end

        return data.key(res)
    end

    # def cacl_cood(seq) ##ruby上でグラフ画像を作成する場合

    #     def size_gain(object)
    #         answer = object.size() - 1
    #         return answer
    #     end
        
    #     coordinate = [[0], [0]]  #座標の配列([x], [y])
    #     x, y = 0, 0
    #     base_sequence = String.new

    #     base_sequence += seq
        
    #     mapping = { "a" => [1, 1], "t" => [-1, 1], "g" => [-1, -1], "c" => [1, -1] }
        
    #     base_sequence_length = size_gain(base_sequence)
        
    #     for element in 0..base_sequence_length do
    #         base = base_sequence[element]
        
    #         if !(mapping.keys.include?(base)) && base != nil
    #             puts base
    #             base_sequence.delete!(base)
    #         end
    #     end
        
    #     for element in 0..1 do
    #         x += mapping[base_sequence[element]][0]
    #         y += mapping[base_sequence[element]][1]
    #         coordinate[0].push(x)
    #         coordinate[1].push(y)
    #     end
        
    #     base_sequence_length = size_gain(base_sequence)
    #     File.open("./lib/weight.json") do |f|
    #         codon_cost = JSON.load(f)

    #         for element in 2..base_sequence_length do
    #             codon = base_sequence[element-2..element]
    #             x += mapping[base_sequence[element]][0] * codon_cost[codon]
    #             y += mapping[base_sequence[element]][1] * codon_cost[codon]
    #             coordinate[0].push(x)
    #             coordinate[1].push(y)
    #         end
    #     end
        
    #     coordinate_lenght = size_gain(coordinate[0])
        
    #     for element in 0..coordinate_lenght do
    #         puts "#{coordinate[0][element]} #{coordinate[1][element]}"
    #     end
    # end

end