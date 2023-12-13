#1º
#Numero contactos por ip diferentes.
#(Contar quantas vezes um determinado ip contactou o servidor.)
#(Total de Ips que contactaram o servidor)

#exemplo:
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

for row in rows
  auxArr = row.gsub(/ - - | - |"/, '|').split("|")
  arrayData.append(auxArr[0], auxArr[1], auxArr[2], auxArr[3].strip)

  year =  auxArr[1].gsub(/[\/|:]/, ',').split(",")[2]

  ips[auxArr[0]] = 0 unless !ips.empty?
  ips.include?(auxArr[0]) ? (ips[auxArr[0]] = ips[auxArr[0]] + 1) : (ips[auxArr[0]] = 1)

end
