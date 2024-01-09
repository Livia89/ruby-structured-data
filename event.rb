require "win32/eventLog"
include Win32

log = Win32::EventLog.open("System")
result = ""
puts "Records number: #{log.total_records}"
result = result + "Records number: #{log.total_records}"
log.read { |record|

    if record.event_id == 6013 # 6013 - system uptime
      seconds = record.description.split
      hours = seconds[4].to_i / 3600
      days = hours/24
      hours = hours-days * 24

      puts "In #{record.time_generated} the computer was turned on in #{record.time_generated}: #{days} days - #{hours} hours"
      result = result + "\nIn #{record.time_generated} the computer was turned on in #{record.time_generated}: #{days} days - #{hours} hours"
    end
}
File.open("events-log.txt", "w") { |f| f.write result }
