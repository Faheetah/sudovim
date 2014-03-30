module Post

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.slugify title
    return title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.new title: nil, summary: nil, content: nil, tags: nil, date: DateTime.now
    if title and content
      slug = self.slugify(title)
      post = @@sequel[:posts].insert :title => title, :slug => slug, :summary => summary, :content => content, :date => date
      if tags
        tags.split(',').each do |tag|
          Tag.new :tag => tag, :posts_id => post
        end
      end
      return post
    end
  end

  def self.all paginate: 0, length: 10
    posts = @@sequel[:posts].select(:id,:title,:slug,:summary,:date).limit(length).offset(paginate).reverse_order(:date).all.each do |post|
      post[:tags] = Tag.find post[:id]
    end
    return posts
  end

  def self.find id, paginate: 0, length: 10
    if id.is_a? Integer
      return @@sequel[:posts].select(:id,:title,:slug,:content,:date).where(:id => id).first
    elsif id.is_a? Array
      posts = @@sequel[:posts].select(:id,:title,:slug,:summary,:date).where(:id => id).limit(length).offset(paginate).reverse_order(:date).all.each do |post|
        post[:tags] = Tag.find post[:id]
      end
      return posts
    end
  end

end
