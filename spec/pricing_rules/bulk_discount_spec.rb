require 'spec_helper'

RSpec.describe PricingRuleTypes::BulkDiscount do
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:rule) { PricingRuleTypes::BulkDiscount.new('SR1', 3, 4.50) }

  describe '#initialize' do
    it 'sets product code, minimum quantity, and discounted price' do
      expect(rule.product_code).to eq('SR1')
      expect(rule.minimum_quantity).to eq(3)
      expect(rule.discounted_price).to eq(4.50)
    end
  end

  describe '#apply' do
    it 'applies discount when minimum quantity is met' do
      items = [strawberries, strawberries, strawberries]
      
      expect(rule.apply(items)).to eq(13.50)
      expect(items).to be_empty
    end

    it 'applies discount when more than minimum quantity' do
      items = [strawberries, strawberries, strawberries, strawberries]
      
      expect(rule.apply(items)).to eq(18.00)
      expect(items).to be_empty
    end

    it 'does not apply discount when minimum quantity is not met' do
      items = [strawberries, strawberries]
      
      expect(rule.apply(items)).to eq(0)
      expect(items.size).to eq(2)
    end

    it 'handles empty cart' do
      items = []
      
      expect(rule.apply(items)).to eq(0)
      expect(items).to be_empty
    end

    it 'does not affect non-matching items' do
      coffee = Product.new('CF1', 'Coffee', 11.23)
      items = [strawberries, strawberries, coffee]
      
      expect(rule.apply(items)).to eq(0)
      expect(items.size).to eq(3)
    end
  end
end
