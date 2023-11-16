require './table'

t1 = GoogleDriveLib::Table.new(0)
t2 = GoogleDriveLib::Table.new(1)

t1 - t2
t1.update_cells

#p t1.indeks.rn8021

#p t1.drugaKolona.select {|elem| elem.even?}
# p t1.table
