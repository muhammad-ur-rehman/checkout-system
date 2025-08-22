require 'spec_helper'

RSpec.describe PricingRules do
  let(:green_tea) { Product.new('GR1', 'Green tea', 3.11) }
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:coffee) { Product.new('CF1', 'Coffee', 11.23) }

  describe '#initialize' do
    it 'creates an empty rules collection' do
      pricing_rules = PricingRules.new
      expect(pricing_rules.instance_variable_get(:@rules)).to be_empty
    end
  end

  describe '#add_rule' do
    it 'adds a rule to the collection' do
      pricing_rules = PricingRules.new
      rule = PricingRuleTypes::BuyOneGetOneFree.new('GR1')
      
      pricing_rules.add_rule(rule)
      expect(pricing_rules.instance_variable_get(:@rules)).to include(rule)
    end
  end

  describe '#apply' do
    context 'with no special rules' do
      it 'calculates total at regular prices' do
        pricing_rules = PricingRules.new
        items = [green_tea, strawberries]
        
        expect(pricing_rules.apply(items)).to eq(8.11)
      end
    end

    context 'with multiple rules' do
      it 'applies rules in order and calculates remaining items at regular price' do
        pricing_rules = PricingRules.new
        pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))
        pricing_rules.add_rule(PricingRuleTypes::BulkDiscount.new('SR1', 3, 4.50))
        
        items = [green_tea, green_tea, strawberries, strawberries, strawberries, coffee]

        expect(pricing_rules.apply(items)).to eq(27.84)
      end
    end

    context 'with rule order affecting results' do
      it 'maintains original items array unchanged' do
        pricing_rules = PricingRules.new
        pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))
        
        original_items = [green_tea, green_tea]
        pricing_rules.apply(original_items)
        
        expect(original_items.size).to eq(2)
      end
    end

    context 'with empty cart' do
      it 'returns 0' do
        pricing_rules = PricingRules.new
        pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))
        
        expect(pricing_rules.apply([])).to eq(0.0)
      end
    end
  end
end
