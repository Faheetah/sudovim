module Search

  @@sequel = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

  def self.find terms, paginate: 0, length: 10
    return @@sequel[:posts].full_text_search(:content, terms).limit(length).offset(paginate).reverse_order(:date).all.each do |post|
      post[:tags] = Tag.find post[:id]
    end
    return posts
  end

  def self.tags tags
    return @@sequel[:tags].select(:posts_id).where(:link => tags).distinct
  end
end
