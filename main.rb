require 'sinatra'
# require 'sinatra/reloader' if development?
require 'haml'
require 'datamapper'
require 'ruby-debug'

require 'awesome_print' if development?
require 'date'

# DataMapper::setup(:default, "sqlite3:challenge.db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

class Challenge
  include DataMapper::Resource

  property :id, Serial
  property :aim, String
  property :description, String
  property :duration, Integer
  property :longest_chain, Integer
  property :current_chain, Integer
  # property :time_since_longest, Integer 
  property :done, Integer
  property :missed, Integer
  property :chain_record, String
  
  def check_if_longest
    if self.current_chain >= self.longest_chain
      then self.longest_chain = self.current_chain
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
      new_chain = self.chain_record.split("")
      new_chain = new_chain.push("1").join
      self.chain_record = new_chain
    else
      self.current_chain = 0
      # @time_since_tick += 1
      self.missed += 1
      new_chain = self.chain_record.split("")
      new_chain = new_chain.push("0").join
      self.chain_record = new_chain
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
  
  def format_table
    chain_record = Challenge.last.chain_record
    chain_record_array = chain_record.split("")
    chain_record_array.push("2")
    table = chain_record_array.each_slice(7).to_a
  end    
end

Challenge.auto_migrate! unless Challenge.storage_exists?

class Web
  set :environment, :development
  
  get '/' do
    haml :index
  end

  get '/setup' do
    Challenge.create(
      :aim => "new one", 
      :description => "Go running for 15 mins", 
      :duration => 9,
      :longest_chain => 5,
      :current_chain => 2,
      :done => 7,
      :missed => 2,
      :chain_record => '110011'
      )
    "Made new resource"

    @c = Challenge.last
    @table = @c.format_table
    haml :table
  end
  
  get '/display' do
    @c = Challenge.last
    haml :display
  end
  
  
  get '/done' do
    @c = Challenge.last
    @c.update(1)
    @table = @c.format_table
    @id = Challenge.last.id
    haml :table
  end

  get '/missed' do
    @c = Challenge.last
    @c.update(0) 
    @table = @c.format_table
    @id = Challenge.last.id
    haml :table
  end

  # get '/create' do
  #   haml :
  # end
  
  get '/table' do
    @c = Challenge.last
    @table = @c.format_table
    @id = Challenge.last.id
    haml :table
  end
    
end