module Search

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.for terms
    terms
  end

  def self.tags tags
    p tags
    p @@sequel[:tags].select(:posts_id).where(:link => tags).distinct
  end
end
