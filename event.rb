require "win32/eventLog"
include Win32

log = Win32::EventLog.open("System")

puts "Records number: #{log.total_records}"

log.read { |record|
  if record.event_id == 6013 # 6013 - system uptime
    date = record.time_generated
    seconds = record.description.split
    hours = seconds[4].to_i / 3600
    days = hours/24
    hours = hours-days * 24

    puts "The computer was turned on in #{date}: #{days} days - #{hours} hours"
  end
}
