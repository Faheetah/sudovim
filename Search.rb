module Search

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.for terms
    terms
  end

  def self.tags tags
    posts = @@sequel[:tags].select(:posts_id).where(:tags => tags)
    p posts
  end
end
