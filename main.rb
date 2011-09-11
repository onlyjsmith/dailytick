require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
# require 'active_record'

require 'awesome_print' if development?
require 'date'


class Challenge
  attr_accessor :aim, :description, :first, :longest_chain, :time_since_longest, :current_chain, :duration, :chain_record, :time_since_tick, :done, :missed
  
  def setup_sample
    self.chain_record = [1,1,1,1,1,0,0,1,1]
    self.aim = "Go running"
    self.description = "At least 15 minutes every day"
    self.first = Date.parse('2011-09-11')
    self.longest_chain = 5
    self.time_since_tick = 0
    self.duration = 9
    self.done = 7
    self.missed = 2
    self.current_chain = 2
    self.time_since_longest = 4
    self.save
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

  set :environment, :development
  
  get '/' do
    haml :index
  end

  get '/setup' do
    @c = Challenge.new
    @c.setup_sample
    "Done setting up"
  end
  
  get '/display' do
    @c = Challenge.new#.setup_sample
    @c.setup_sample
    haml :display
  end
end
  
    

# c.get_input