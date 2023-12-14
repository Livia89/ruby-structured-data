#example:
#188.83.64.154 - 10
#63.141.251.236 - 5
#Total 2 ip's

#open the file
fileOpened = File.open("teambuilder.log")
data = fileOpened.read
fileOpened.close

rows = data.split("\n")

arrayData = []
ips = {}
ips_year = {}

rows.each do |row|
  rowArr = row.gsub(/ - - | - |"/, '|').split("|")

  ip, date, req, error = rowArr[0], rowArr[1], rowArr[2], rowArr[3].strip

  yearReq =  date.gsub(/[\/|:]/, ',').split(",")[2]

  ips[ip] = 0 unless !ips.empty?
  ips.include?(ip) ? (ips[ip] = ips[ip] + 1) : (ips[ip] = 1)

  #cria uma nova posição ao menos que a chave do ano ja exista
  ips_year[yearReq] = {} unless ips_year.include?(yearReq)

  ips_year.each{|year, list|

    if(year == yearReq)
      ips_year[year].include?(ip) ?
      (list.merge!(ip => ips_year[year][ip] + 1)) :
      (list.merge!(ip => 1))
    end
  }

end

puts "\n\nTotal IPs that made requests to the server\n\n"
ips.each do |key, value, index|
  puts "#{key} => #{value}"
end


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

puts "*------------*" * 8
