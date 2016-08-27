class Player 
	attr_accessor :color, :name

	def initialize(color)
		@color = color 
	end 

	def get_name 
		puts "#{color.to_s.capitalize}: Please enter your name:"
		@name = gets.chomp.scan(/.{1,25}/).first
	end 

	def get_move 
		begin 
			input = gets.chomp.upcase
			if (options = input.scan(/save|back|exit|\d.?\w/i)).empty?
				raise 
			else 
				return options.first 
			end 
		rescue 
			puts "Your entry is not a valid option"
			retry 
		end 
	end  
end 