require 'date'

class Challenge
  # To start, will only have one challenge - "go running"
  attr_accessor :aim, :description, :first, :longest_chain, :time_since_longest, :current_chain, :duration, :chain_record, :time_since_tick, :done, :missed

  def initialize
    system('clear')
    @aim = "Go running"
    @description = "At least 15 minutes every day"
    @first = Date.parse('2011-09-11')
    @longest_chain = 0
    @time_since_longest = 0 
    @current_chain = 0
    @duration = 0
    @chain_record = [1,1,1,1,1,0,0,1,1]
    @time_since_tick = 0
    @done = 0
    @missed = 0
    parse_record
  end  

  def display_detail
    system('clear')
    puts "===="
    puts "Aim: #{@aim}" 
    puts "Description: #{@description}"
    puts "Longest chain: #{@longest_chain} days, which was #{@time_since_longest} days ago"
    puts "Current chain: #{@current_chain} days"
    puts "Done: #{@done}"
    puts "Missed: #{@missed}"
    puts "Time since tick: #{@time_since_tick}" if @time_since_tick != 0
    puts "Record: #{@chain_record}"# (last 20 days only)"
    puts "----"
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
        add_new_tick
      when 'd' 
        display_detail
      when 'm'
        miss_a_day
      when 'p'
        parse_record
      when 'q' 
        exit
      when 's'
        miss_a_day
    end
    get_input
    system('clear')
  end      
   
  def parse_record
    @duration = @chain_record.size
    @current_chain = 0; @longest_chain = 0
    count = 0; @chain_record.each{|r| count += 1 if r == 0}; @missed = count
    @chain_record.each do |record|
      if record == 1
        @current_chain += 1
        @time_since_tick = 0
        check_if_longest
      else
        @current_chain = 0
        @time_since_tick += 1
      end
    end
    check_time_since_longest
    shorten_record
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

  def display_chain
    @chain_record.each do |r|
      print r
    end
  end          


  def add_new_tick
    # puts "Adding new tick - well done!"
    @chain_record << 1
    parse_record
  end

  def miss_a_day
    @chain_record << 0
    parse_record
  end  



  def shorten_record
  #   length = @chain_record.size
  #   if length > 20
  #     @chain_record = @chain_record[length-20..length]
  #   end
  end    
end


c = Challenge.new
c.get_input