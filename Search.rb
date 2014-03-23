module Search

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.find terms
    return @@sequel[:posts].full_text_search(:content, terms).all
  end

  def self.tags tags
    return @@sequel[:tags].select(:posts_id).where(:link => tags).distinct
  end
end
