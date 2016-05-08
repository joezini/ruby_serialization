require "csv"

hourly_frequencies = Array.new(24, 0)

contents = CSV.open "full_event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
	registration_date = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M')
	registration_hour = registration_date.hour
	hourly_frequencies[registration_hour] += 1
end

hourly_frequencies_sorted = hourly_frequencies.sort.reverse

hourly_frequencies_sorted.each_with_index do |order_freq, popularity|
	hourly_frequencies.each_with_index do |this_freq, hour|
		if this_freq == order_freq
			puts "Top #{popularity + 1} hour: #{hour} - #{this_freq}" 
			next
		end
	end
end