require 'sequel'

module Post

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.slugify title
    slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.new title: nil, content: nil, tags: '', date: DateTime.now
    if title and content
      slug = self.slugify(title)
      return @@sequel[:posts].insert :title => title, :slug => slug, :content => content, :tags => tags, :date => date
    end
  end

  def self.all paginate: 0, length: 10
    return @@sequel[:posts].limit(length).offset(paginate).order(:date).all
  end

  def self.find id
    return @@sequel[:posts].where(:id => id).all
  end

end
