require 'redis'

module Post

  @@redis = Redis.new

  def self.slugify title
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    if @@redis.hexists(slug, 'title') == false
      return slug
    else
      # This will later need to implement a much better duplicates handling
      self.slugify(title+'1')
    end

  end

  def self.new post
    slug = self.slugify(post[:title])
    @@redis.hmset slug, 'date', post[:date], 'title', post[:title], 'content', post[:content]
    @@redis.lpush 'post::list', slug
  end

  def self.list paginate: 0, length: 10
    titles = @@redis.lrange 'post::list', 0+paginate, 9+paginate
    posts = []
    titles.each do |title|
      posts.push @@redis.hgetall title
    end
    return posts
  end

  def self.find id
    return @@redis.hgetall id
  end

end
