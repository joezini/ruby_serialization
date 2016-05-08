require "csv"

def clean_phone_number(number)
	number_no_symbols = number.gsub(/\.|\s+|-|\(|\)|\+/,'').strip
	if number_no_symbols.length < 10 || number_no_symbols.length > 11
		"-- No number --"
	elsif number_no_symbols.length == 11
		if number_no_symbols[0] == '1'
			format_phone_number(number_no_symbols[1..10])
		else
			"-- No number --"
		end
	else
		format_phone_number(number_no_symbols)
	end
end

def format_phone_number(number)
	"#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
	name = "#{row[:first_name]} #{row[:last_name]}"
	number = clean_phone_number(row[:homephone])

	puts "#{name} - #{number}"
end