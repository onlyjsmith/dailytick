require 'sinatra'
require 'date'

class Challenge
  # To start, will only have one challenge - "go running"
  attr_accessor :aim, :description, :first, :longest_chain, :time_since_longest, :current_chain, :duration, :chain_record, :time_since_tick, :done, :missed

  def initialize
    system('clear')
    # parse_record
  end 
  
  def setup_sample
    @chain_record = [1,1,1,1,1,0,0,1,1]
    @aim = "Go running"
    @description = "At least 15 minutes every day"
    @first = Date.parse('2011-09-11')
    @longest_chain = 5
    @time_since_tick = 0
    @duration = 9
    @done = 7
    @missed = 2
    @current_chain = 2
    @time_since_longest = 4
  end 

  def display_detail
    system('clear')
    puts "===="
    puts "Aim: #{@aim}" 
    puts "Description: #{@description}" 
    puts "Started on: #{@first}"
    puts "Duration: #{@duration}"
    puts "Longest chain: " + "#{@longest_chain}".green + " days, which was #{@time_since_longest} days ago"
    puts "Current chain: "+ "#{@current_chain}".yellow + " days"
    puts "Done: #{@done}"
    puts "Missed: #{@missed}"
    puts "Total: #{@done + @missed}"
    puts "Time since tick: "+ "#{@time_since_tick}".red# if @time_since_tick != 0
    puts "Record: #{@chain_record}"# (last 20 days only)"
    puts "----"
  end

  def display_chain
    @chain_record.each do |r|
      print r
    end
  end          

  def get_input
    display_detail
    puts; puts "Menu"; puts "----"
    puts "Enter 'a' to add another link"
    puts "Enter 'd' to get description of challenge"
    puts "Enter 'm' to miss a day"
    puts "Enter 'p' to force parsing"
    puts "Enter 'q' to quit"  
    a = gets.chomp
    case a
      when 'a' 
        update(1)
      when 'd' 
        display_detail
      when 'm'
        update(0)
      when 'p'
        parse_record
      when 'q' 
        exit
      when 's'
        update(0)
    end
    get_input
    system('clear')
  end      
   
  def check_if_longest
    if @current_chain >= @longest_chain
      then @longest_chain = @current_chain
    end
  end

  def check_time_since_longest
    if @longest_chain > @current_chain
      @time_since_longest += 1
    else @time_since_longest = 0
    end
  end

  def update(action) # 0 = missed, 1 = done
    if action == 1
      @current_chain += 1
      @done += 1
      @time_since_tick = 0
      @chain_record << 1
    else
      @current_chain = 0
      @time_since_tick += 1
      @missed += 1
      @chain_record << 0
    end
    @duration += 1
    check_if_longest
    check_time_since_longest
  end

  def shorten_record
  #   length = @chain_record.size
  #   if length > 20
  #     @chain_record = @chain_record[length-20..length]
  #   end
  end    
end

class String

    def red; colorize(self, "\e[1m\e[31m"); end
    def green; colorize(self, "\e[1m\e[32m"); end
    def dark_green; colorize(self, "\e[32m"); end
    def yellow; colorize(self, "\e[1m\e[33m"); end
    def blue; colorize(self, "\e[1m\e[34m"); end
    def dark_blue; colorize(self, "\e[34m"); end
    def pur; colorize(self, "\e[1m\e[35m"); end
    def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end

c = Challenge.new
c.setup_sample
c.get_input