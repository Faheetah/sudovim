require 'sequel'
require './Tag'

describe Tag do

  describe '#all' do
    it 'lists all unique tags' do
      expect(Tag.all.uniq).to eq Tag.all
    end
  end

end
