require 'base64'
require 'net/smtp'

system 'cls'

destNome = 'YourName'
dest = 'yourEmail'
subject = 'Sending email test'
bodyDetail = 'OK. Test successful'

body = <<MESSAGE_END
From: Dual mail <emailFrom>
To: #{destNome} <#{dest}>
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/Mixed; boundary=PART_SEPARATOR
--PART_SEPARATOR

Content-Type: text/plain; charset=
#{bodyDetail}
.
--PART_SEPARATOR

MESSAGE_END

filename ="events-log.txt"
filesize=File.size(filename)
filecontent = File.read(filename)
encodedfile = Base64.encode64(filecontent)

attachment =<<ATTACHMENT
Content-Type: application/octet-stream; name="#{filename}"
Content-Transfer-Enconding:base-64
Content-Disposition: attachment; filename="#{filename}";size=#{filesize}

#{encodedfile}
--PART_SEPARATOR
ATTACHMENT

account = "emailSend"
pass="passSend"
smtp=Net::SMTP.new('emailServer', 587)
smtp.enable_starttls

begin
  smtp.start('serverName', account,pass,:login) do |smtp|
  smtp.send_message body+attachment,account,dest
end

puts "OK"

rescue Exception => e
  puts "Error: #{e.message}"
end
