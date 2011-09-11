require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'datamapper'
require 'ruby-debug'

require 'awesome_print' if development?
require 'date'

DataMapper::setup(:default, "sqlite3:challenge.db")

class Challenge
  # To start, will only have one challenge - "go running"
  # attr_accessor :aim, :description, :first, :longest_chain, :time_since_longest, :current_chain, :duration, :chain_record, :time_since_tick, :done, :missed
  include DataMapper::Resource

  property :id, Serial
  property :aim, String
  property :description, String
  # property :first, DateTime
  property :duration, Integer
  property :longest_chain, Integer
  property :current_chain, Integer 
  property :done, Integer
  property :missed, Integer

  
  def setup_sample
    DataMapper.auto_migrate!
    # DataMapper.setup(:default, "sqlite3:challenge.db")    
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
    if self.longest_chain > self.current_chain
      self.time_since_longest += 1
    else self.time_since_longest = 0
    end
  end

  def update(action) # 0 = missed, 1 = done
    if action == 1
      self.current_chain += 1
      self.done += 1
      # @time_since_tick = 0
      # @chain_record << 1
    else
      self.current_chain = 0
      # @time_since_tick += 1
      self.missed += 1
      # @chain_record << 0
    end
    self.duration += 1
    check_if_longest
    self.save
    # check_time_since_longest
  end

  def shorten_record
  #   length = @chain_record.size
  #   if length > 20
  #     @chain_record = @chain_record[length-20..length]
  #   end
  end    
end

Challenge.auto_migrate! unless Challenge.storage_exists?

class Web
  set :environment, :development
  
  get '/' do
    # 'Helo wod'
    @c = Challenge.get(:all)
    haml :index
  end

  get '/setup' do
    # @c = Challenge.new
    # @c.setup_sample
    Challenge.create(
      :aim => "new one", 
      :description => "Go running for 15 mins", 
      :duration => 9,
      :longest_chain => 5,
      :current_chain => 2,
      :done => 7,
      :missed => 2
      )
    "Made new resource"
  end
  
  get '/display' do
    # @c = Challenge.new#.setup_sample
    # @c.setup_sample
    @c = Challenge.first
    puts "@c is #{@c}" 
    haml :display
  end
  
  
  get '/done' do
    @c = Challenge.first
    # debugger
    @c.update(1)
    haml :display
  end

  get '/missed' do
    @c = Challenge.first
    @c.update(0)
    haml :display
  end

  # get '/create' do
  #   haml :
  # end
  
    
end

# c.get_input