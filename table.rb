require "google_drive"
require './tablecolumn'

module GoogleDriveLib
    class Table

        attr_reader :table

        # part 1. of the assignment

        $SESSION = GoogleDrive::Session.from_config("config.json")
        $SPREADSHEET_KEY = "1T4u5P_D2OjJiVqPA7JSC0IPnHdpmm2FrmgW6X561Urk"

        def initialize(index) 
            @index ||= index #index of the worksheet in the given spreadsheet
            @worksheet ||= $SESSION.spreadsheet_by_key($SPREADSHEET_KEY).worksheets[index] 
            @x, @y = 0, 0;
        end

        def table
            @table ||= update_table # if @table is nil, update_table initializes
        end

        def update_table # used for updating table based on the changed values in the sheet and for first initialization of the @table variable            
            @worksheet.rows.each_with_index do |row, index|
                if row.any? {|elem| elem != ""}
                    @x = index;
                    @y = row.find_index {|elem| elem != ""}

                    @table = @worksheet.rows(@x).map do |row|
                        row.drop(@y)
                    end

                    @table.each_with_index do |row, index1| # the values in @table matrix are strings, convert them to integer if possible
                        row.each_with_index do |value, index2|
                            @table[index1][index2] = value.to_i if value.to_i.to_s == value
                        end
                    end
                    return @table
                end
            end
        end

        def update_cells
            table.each_with_index do |row, index1|
                row.each_with_index do |value, index2|
                    @worksheet[index1+@x+1,index2+@y+1] = value
                end
            end
            @worksheet.synchronize
            update_table
        end

        # part 2. & 5. of the assignment

        def [](arg)
            if arg.is_a? String
                index = table[0].find_index(arg)
                return TableColumn.new(self, index)
            end

            return table[arg]
        end

        def row(index)
            return table[index]
        end

        # part 3. of the assignment

        include(Enumerable)

        def each(&block)
            table.each do |row|
                row.each do |value|
                    yield value
                end
            end
        end

        # part 4. of the assignment -> the 'google_drive' gem can only merge cells, but can't recognise merged cells

        # part 6. of the assignment

        def method_missing(name, *args)
            name = name.to_s # convert name form symbol to string
            name = name.chars.map do |char|
                res = String.new
                res << " " if char.capitalize == char
                res << char
            end.join("")
            name[0] = name[0].capitalize
            self[name]
        end

        # part 8. of the assignment
        
        def +(obj)
            if row(0) == obj.row(0)
                obj.table.drop(1).each do |row|
                    @table << row
                end
            end
        end

        # part 9. of the assignment

        def -(obj)
            if row(0) == obj.row(0)
                obj.table.drop(1).each do |obj_row|
                    table.each_with_index do |row, index|
                        if obj_row == row
                            @table.delete_at index
                            @worksheet.delete_rows(index+@x+1,1)
                        end
                    end
                end
            end
        end
    end
end