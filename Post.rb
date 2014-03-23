module Post

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.slugify title
    return title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.new title: nil, content: nil, tags: nil, date: DateTime.now
    if title and content
      slug = self.slugify(title)
      @post = @@sequel[:posts].insert :title => title, :slug => slug, :content => content, :date => date
      if tags
        tags.split(',').each do |tag|
          Tag.new :tag => tag, :posts_id => @post
        end
      end
      return @post
    end
  end

  def self.all paginate: 0, length: 10
    return @@sequel[:posts].limit(length).offset(paginate).reverse_order(:date).all
  end

  def self.find id, paginate: 0, length: 10
    if id.is_a? String
      return @@sequel[:posts].where(:id => id).all
    elsif id.is_a? Array
      return @@sequel[:posts].where(:id => id).limit(length).offset(paginate).reverse_order(:date).all
    end
  end

end
