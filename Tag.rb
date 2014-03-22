module Tag

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.striptags tags
    return tags.downcase.strip.gsub(/[^a-z0-9+,.\-\#\s]+/i,'')
  end

  def self.new tag: nil, posts_id: nil
    if @@sequel[:posts].select(:id).where(:id => posts_id).exists
      p posts_id
    end
    return @@sequel[:tags].insert :tag => tag, :posts_id => posts_id
  end

  def self.all
    @@sequel[:tags].select(:tag).distinct.all
  end

end
