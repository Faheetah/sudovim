require 'sequel'

module Post

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.slugify title
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.new title: nil, content: nil, tags: '', date: DateTime.now
    slug = self.slugify(title)
    if title and content
      return @@sequel[:posts].insert :title => title, :slug => slug, :content => content, :tags => tags, :date => date
    end
  end

  def self.all paginate: 0, length: 10
    results = @@sequel[:posts]
    return results.limit(length).offset(paginate).all
  end

  def self.find id
    return @@sequel[:posts].where(:id => id)
  end

end
