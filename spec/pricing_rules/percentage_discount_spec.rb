require 'spec_helper'

RSpec.describe PricingRuleTypes::PercentageDiscount do
  let(:coffee) { Product.new('CF1', 'Coffee', 11.23) }
  let(:rule) { PricingRuleTypes::PercentageDiscount.new('CF1', 3, 0.25) } # 25% discount

  describe '#initialize' do
    it 'sets product code, minimum quantity, and discount percentage' do
      expect(rule.product_code).to eq('CF1')
      expect(rule.minimum_quantity).to eq(3)
      expect(rule.discount_percentage).to eq(0.25)
    end
  end

  describe '#apply' do
    it 'applies percentage discount when minimum quantity is met' do
      items = [coffee, coffee, coffee]
      
      # 11.23 * 0.75 (25% discount) * 3 = 25.27
      expected_price = (3 * 11.23 * 0.75).round(2)
      expect(rule.apply(items)).to eq(expected_price)
      expect(items).to be_empty
    end

    it 'applies discount to all items when more than minimum' do
      items = [coffee, coffee, coffee, coffee]
      
      expected_price = (4 * 11.23 * 0.75).round(2)
      expect(rule.apply(items)).to eq(expected_price)
      expect(items).to be_empty
    end

    it 'does not apply discount when minimum quantity is not met' do
      items = [coffee, coffee]
      
      expect(rule.apply(items)).to eq(0)
      expect(items.size).to eq(2)
    end

    it 'handles 100% discount correctly' do
      free_rule = PricingRuleTypes::PercentageDiscount.new('CF1', 2, 1.0)
      items = [coffee, coffee]
      
      expect(free_rule.apply(items)).to eq(0.0)
      expect(items).to be_empty
    end
  end
end
