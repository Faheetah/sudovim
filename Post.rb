require 'redis'

module Post

  @@redis=Redis.new

  def self.slugify title
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    if @@redis.hexists(slug, 'title') == false
      return slug
    else
      self.slugify(title+'1')
    end

  end

  def self.new post
    slug = self.slugify(post[:title])
    @@redis.hmset slug, 'date', post[:date], 'title', post[:title], 'content', post[:content]
    @@redis.lpush 'post::list', slug
  end

  def self.list paginate: 0, length: 10
    slugs = @@redis.lrange 'post::list', 0+paginate, 9+paginate
    posts = []
    slugs.each do |slug|
      post = @@redis.hgetall slug
      post["slug"] = slug
      posts.push post
    end
    return posts
  end

  def self.find id
    return @@redis.hgetall id
  end

end
