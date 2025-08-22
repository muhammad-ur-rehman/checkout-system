require 'spec_helper'

RSpec.describe PricingRuleTypes::Base do
  let(:green_tea) { Product.new('GR1', 'Green tea', 3.11) }
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  
  let(:test_rule) do
    Class.new(PricingRuleTypes::Base) do
      def apply(items)
        matching_items = find_matching_items(items)
        remove_all_matching_items(items)
        matching_items.size * get_item_price(matching_items)
      end
    end.new('GR1')
  end

  describe '#initialize' do
    it 'sets the product code' do
      rule = PricingRuleTypes::Base.new('GR1')
      expect(rule.product_code).to eq('GR1')
    end
  end

  describe '#apply' do
    it 'raises NotImplementedError for base class' do
      rule = PricingRuleTypes::Base.new('GR1')
      expect { rule.apply([]) }.to raise_error(NotImplementedError)
    end
  end

  describe 'protected helper methods' do
    describe '#find_matching_items' do
      it 'finds items matching the product code' do
        items = [green_tea, strawberries, green_tea]
        matching = test_rule.send(:find_matching_items, items)
        expect(matching.size).to eq(2)
        expect(matching.all? { |item| item.code == 'GR1' }).to be true
      end
    end

    describe '#remove_all_matching_items' do
      it 'removes all items matching the product code' do
        items = [green_tea, strawberries, green_tea]
        test_rule.send(:remove_all_matching_items, items)
        expect(items.size).to eq(1)
        expect(items.first.code).to eq('SR1')
      end
    end

    describe '#remove_matching_items' do
      it 'removes specific number of matching items' do
        items = [green_tea, strawberries, green_tea, green_tea]
        removed = test_rule.send(:remove_matching_items, items, 2)
        expect(removed).to eq(2)
        expect(items.size).to eq(2)
        expect(items.select { |item| item.code == 'GR1' }.size).to eq(1)
      end
    end

    describe '#minimum_quantity_met?' do
      it 'returns true when minimum quantity is met' do
        items = [green_tea, green_tea, green_tea]
        result = test_rule.send(:minimum_quantity_met?, items, 3)
        expect(result).to be true
      end

      it 'returns false when minimum quantity is not met' do
        items = [green_tea, green_tea]
        result = test_rule.send(:minimum_quantity_met?, items, 3)
        expect(result).to be false
      end
    end

    describe '#get_item_price' do
      it 'returns price of first matching item' do
        items = [green_tea, strawberries]
        price = test_rule.send(:get_item_price, items)
        expect(price).to eq(3.11)
      end

      it 'returns 0 when no matching items' do
        items = [strawberries]
        price = test_rule.send(:get_item_price, items)
        expect(price).to eq(0)
      end
    end
  end
end
