require 'google_drive'
require './table'

# part of the assignment part 5.

module GoogleDriveLib
    class TableColumn

        # part of the assignment part 5.

        def initialize(google_table, col_index)
            @col_index = col_index
            @google_table = google_table
        end

        def [](arg)
            @google_table[arg][col_index];
        end

        def []=(*args)
            @google_table[args[0]][@col_index] = args[1]
        end

        # part of the assignment part 6.

        def sum
            sum = 0
            @google_table.table.transpose[@col_index].drop(1).each do |value|
                sum += value.to_i
            end
            sum
        end

        def avg
            1.0*sum/(@google_table.table.transpose[@col_index].drop(1).size)
        end

        def method_missing(name, *args)
            name = name.to_s
            index = @google_table.table.transpose[@col_index].find_index(name).to_i
            return @google_table[index]
        end

        def map(&block)
            @google_table.table.transpose[@col_index].drop(1).each_with_index do |row, index|
                @google_table[index+1][@col_index] = yield @google_table[index+1][@col_index]
            end
        end

        def select(&block)
            @google_table.table.transpose[@col_index].drop(1).select &block
        end
    end
end