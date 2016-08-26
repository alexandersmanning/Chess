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
			input = gets.chomp.scan(/(\d).*(\w)/).first
			raise if input.count < 2
		rescue 
			puts "you must enter a valid set of coordinates"
			retry 
		end

		input 
	end 

end 