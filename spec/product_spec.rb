require 'spec_helper'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with code, name, and price' do
      product = Product.new('GR1', 'Green tea', 3.11)
      
      expect(product.code).to eq('GR1')
      expect(product.name).to eq('Green tea')
      expect(product.price).to eq(3.11)
    end
  end

end
