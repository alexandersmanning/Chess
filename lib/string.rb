class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def color(input = nil)

    case input
    when :black then colorize(30)
    when :white then colorize(37)
    else colorize(31)
    end
  end
end 

  