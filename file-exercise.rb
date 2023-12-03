require 'Date'
#system("cls")

# file read
file = File.open("manageData.csv")
data = file.read()
file.close()

# handle data
rows = data.split("\n")
rows.delete_at(0) # remove first line
rows.delete_at(rows.length - 1 ) # remove last line -> nil

# declare variables
categoriesArr = [] # categories, amount and total
totalMonth=Array.new(12)
totalAllCategories = 0

# populate categories
for row in rows
  categoryRow = row.split(";")
  categoryName = categoryRow[1]
  hasCategory = false

  for category in categoriesArr
    hasCategory=true unless !category.include?(categoryName) #If category not exists it's to change hasCategory value
  end
   categoriesArr.append([categoryName]) unless hasCategory #Added new category if not exists
end

#sort array by category name
categoriesArr = categoriesArr.sort()

# sum + populate category total by month, total by each month and total of all categories
for cat in categoriesArr
  category = cat[0]
  totalCatByMonth = []
  totalCategory = 0

  for m in 1..totalMonth.length #Number of months
    sum=0.0
    totalM = 0

    for row in rows
      categoryRow = row.split(";")
      # getting category, month and amount from current Line
      categoryName, month, amount  = categoryRow[1], Date.strptime(categoryRow[3]).month, categoryRow[5].delete("$").gsub(",", ".").to_f

      if(category.downcase === categoryName.downcase && month === m)
        sum += amount
      end

      if month === m
        totalM += amount
      end
    end

    totalMonth[m-1] = totalM.to_f.ceil(2).round(1)
    totalCatByMonth.push(sum.round(2))
    totalCategory += sum
    totalAllCategories += sum
  end

  index = categoriesArr.index{|c|c.include?(category)} || 0
  totalCategory = totalCategory == 0 ? nil : totalCategory.round(2)
  categoriesArr[index].append(totalCatByMonth, totalCategory)
end

# creating bars structure
bar = 0
for category in categoriesArr
  bar = bar < category[0].length ? category[0].length + (12 * 9.4) : bar
  break
end

bar = "-" * bar
puts "\n"
puts bar

# creating table structure for presentation
def arrToTable(array, totalMonth, bar)
  #showing months
  for m in 1..totalMonth.length
    print  m === 1 ? "                         #{m}": "      #{m}"
  end

  puts "\n"
  puts bar
  #transposes the rows and columns and returns max length
  colWidth = array.transpose.map{|col| col.map{|cell| cell.to_s.length}.max}
  #setting the column width to each element in the array
  array.each_with_index{|row, i| puts "|"+ row.zip(colWidth).map{|cell, w| cell.to_s.ljust(w)}.join(' | ')+ '|' }
  puts bar
  puts "\n"

end

#showing data in table structure
categoriesArr.push(["Grand Total: ", totalMonth, totalAllCategories.round(2)])
arrToTable(categoriesArr, totalMonth, bar)
