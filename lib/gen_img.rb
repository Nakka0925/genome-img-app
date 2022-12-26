require 'bio'
require '~/sotuken/omomi/get_entry'

class Genome

    def size_gain(object)
        answer = object.size() - 1
        return answer
    end

    def accession_number_gain

        data_list = CSV.read('organelles.csv')
        length = data_list[0].size()

        for i in 0..length do
            if data_list[0][i] == "Replicons"  
            n = i
            end
        end

        data_list = data_list.map{|row| row[n]}
        data_list.each do |s|
            if s.include?("/")
                s.sub!(/\/.*/m, "")
            end

            if s.include?("MT:")
                s.gsub!(/MT:/, "")
            end

            if s.include?("MIT:")
                s.gsub!(/MIT:/, "")
            end

            if s.include?("mt:")
                s.gsub!(/mt:/, "")
            end
        end

        data_list.delete_at(0)

        return data_list
    end

    def get_entry
        accession_number_list = accession_number_gain.uniq
        accession_number_list = accession_number_list[0..10]
        #ゲノム配列ダウンロード

=begin
        accession_number_list.each do |lang|
            ent = Mizlab.getobj(lang)
            Mizlab.savefile("#{ent.accession}.gbk", ent)
            #sleep(0.5)
        end
=end

        codon_sum = Hash.new(0)
        $codon_cost = Hash.new(0)

        atgc = ['a', 't', 'g', 'c']
        check = []

        atgc.repeated_permutation(3).to_a.each do |elm|
            check.push(elm.join)
        end

        accession_number_list.each do |number|
            number_length = number.size() - 3
            Bio::FlatFile.auto(number.slice!(0..number_length) + ".gbk") do |ff|
                ff.each_entry do |entry|
                    entry.seq.window_search(3) do |dna_codon|
                        if check.include?(dna_codon)
                            codon_sum[dna_codon] += 1
                        end
                    end
                end
            end
        end

        codon_sum = codon_sum.sort.to_h

        codon_sum.each do |codon, value|
            cacl = (codon_sum[codon[0..1]+'a'] + codon_sum[codon[0..1]+'t'] + codon_sum[codon[0..1]+'g'] + codon_sum[codon[0..1]+'c']).to_f
            cacl = (value / cacl)
            $codon_cost[codon] = -(Math.log2(cacl))
        end

        File.open('weight.json', 'w') do |file|
            JSON.dump($codon_cost, file)
        end
    end

    def gen_pixel_data

        coordinate = [[0], [0]]  #座標の配列([x], [y])
        x, y = 0, 0
        base_sequence = String.new

        mapping = { "a" => [1, 1], "t" => [-1, 1], "g" => [-1, -1], "c" => [1, -1] }

        Bio::FlatFile.auto(ARGF) do |ff|
            ff.each_entry do |entry|
                base_sequence += entry.seq.to_s
            end
        end

        base_sequence_length = size_gain(base_sequence)

        for element in 0..base_sequence_length do
            base = base_sequence[element]

            if !(mapping.keys.include?(base)) && base != nil
                puts base
                base_sequence.delete!(base)
            end
        end

        for element in 0..1 do
            x += mapping[base_sequence[element]][0]
            y += mapping[base_sequence[element]][1]
            coordinate[0].push(x)
            coordinate[1].push(y)
        end

        base_sequence_length = size_gain(base_sequence)

        for element in 2..base_sequence_length do
            codon = base_sequence[element-2..element]
            x += mapping[base_sequence[element]][0] * $codon_cost[codon]
            y += mapping[base_sequence[element]][1] * $codon_cost[codon]
            coordinate[0].push(x)
            coordinate[1].push(y)
        end

        coordinate_lenght = size_gain(coordinate[0])

        for element in 0..coordinate_lenght do
            puts "#{coordinate[0][element]} #{coordinate[1][element]}"
        end
    end