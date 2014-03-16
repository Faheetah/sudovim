require 'redis'

module Post

  @@redis = Redis.new

  def self.slugify title
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    if @@redis.hexists(slug, 'title') == false
      return slug
    else
      self.slugify(title+'1')
    end

  end

  def self.list paginate: 0
    redis = Redis.new
    redis.hgetall 1
  end

  def self.find id
    id
  end

  def self.new
  end

end
