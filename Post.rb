require 'redis'

module Post
  # Grab the last 10 entries
  def self.all
    'all'
  end
  # Paginate based on offset

  #Grab by ID
  def self.find id
    id
  end
end
