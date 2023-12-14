#open the file
fileOpened = File.open("teambuilder.log")
data = fileOpened.read
fileOpened.close

rows = data.split("\n")

ips = {}
ips_year = {}
reqErrors = {}
reqTotal = 0
rows.each do |row|
  rowArr = row.gsub(/ - - | - |"/, '|').split("|")
  ip, date, req, error = rowArr[0], rowArr[1], rowArr[2], rowArr[3].strip.split[0].to_s #data setted to variables
  yearRow =  date.gsub(/[\/|:]/, ',').split(",")[2]

  # ip hash started & add ips made req to the server
  ips[ip] = 0 unless !ips.empty?
  ips.include?(ip) ? (ips[ip] = ips[ip] + 1) : (ips[ip] = 1)

  # new position created unless the year key already exists &
  ips_year[yearRow] = {} unless ips_year.include?(yearRow)
  # hash iteration over to count the number of ips requisitions to the server
  ips_year.each{|year, list|
    if(year == yearRow)
      ips_year[year].include?(ip) ?
      (list.merge!(ip => ips_year[year][ip] + 1)) :
      (list.merge!(ip => 1))
    end
  }

  #ips requisition verification indicating 4** errors
  error[0].to_i == 4 && reqErrors.merge!({ip => "#{error} - #{req}"})

end

#example:
#188.83.64.154 - 10
#63.141.251.236 - 5
#Total 2 ip's

puts "\n\nTotal IPs that made requests to the server\n\n"
ips.each do |key, value, index|
  puts "#{key} => #{value}"
  reqTotal += value
end
puts "\nTotal: #{reqTotal} ip's \n\n"

print "*------------*" * 8

#example:
#2021 - 188.83.64.154 - 10
#2021 - 63.141.251.236 - 5
#2022 - 188.83.64.154 - 25

puts "\n\nSum requisition of all contacts by ip per year\n\n"
ips_year.each do |year, list|
  list.each do |ip, amount|
    print "#{year} - #{ip} => #{amount}"
    puts ("\n")
  end
end
puts  "\n\n"
puts "*------------*" * 8
puts  "\n\n"

#example:
#188.83.64.154 => 404 - GET /robots.txt HTTP/1.1
#188.83.64.154 => 404 - GET /sitemap.xml HTTP/1.1

puts "\n\nIps requisition that resulted 4** errors\n\n"
reqErrors.each do |ip, info|
  puts "#{ip} => #{info}"
end
