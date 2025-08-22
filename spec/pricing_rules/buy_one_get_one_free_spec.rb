require 'spec_helper'

RSpec.describe PricingRuleTypes::BuyOneGetOneFree do
  let(:green_tea) { Product.new('GR1', 'Green tea', 3.11) }
  let(:rule) { PricingRuleTypes::BuyOneGetOneFree.new('GR1') }

  describe '#apply' do
    it 'charges for one item when two are present' do
      items = [green_tea, green_tea]
      
      expect(rule.apply(items)).to eq(3.11)
      expect(items).to be_empty
    end

    it 'charges for one item when three are present (leaves one)' do
      items = [green_tea, green_tea, green_tea]
      
      expect(rule.apply(items)).to eq(3.11)
      expect(items.size).to eq(1)
    end

    it 'charges nothing when no matching items' do
      strawberries = Product.new('SR1', 'Strawberries', 5.00)
      items = [strawberries]
      
      expect(rule.apply(items)).to eq(0)
      expect(items.size).to eq(1)
    end

    it 'charges nothing when only one item is present' do
      items = [green_tea]
      
      expect(rule.apply(items)).to eq(0)
      expect(items.size).to eq(1)
    end

    it 'handles empty cart' do
      items = []
      
      expect(rule.apply(items)).to eq(0)
      expect(items).to be_empty
    end

    it 'charges for two items when four are present' do
      items = [green_tea, green_tea, green_tea, green_tea]
      
      expect(rule.apply(items)).to eq(6.22)
      expect(items).to be_empty
    end
  end
end
