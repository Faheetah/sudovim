module Tag

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.strip tags
    return tags.downcase.strip.gsub(/[^a-z0-9+,.\-\#\s]+/i,'')
  end

  def self.new tag: nil, posts_id: nil
    if @@sequel[:posts].select(:id).where(:id => posts_id).exists
      return @@sequel[:tags].insert :tag => self.strip(tag), :link => self.strip(tag).tr(' ','-').gsub('#','%23'), :posts_id => posts_id
    end
  end

  def self.all
    return @@sequel[:tags].select(:tag, :link).distinct.all
  end

  def self.find id
    return @@sequel[:tags].where(:posts_id => id).all
  end
end
