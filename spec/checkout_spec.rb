require 'spec_helper'

RSpec.describe Checkout do
  let(:pricing_rules) do
    rules = PricingRules.new
    rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))
    rules.add_rule(PricingRuleTypes::BulkDiscount.new('SR1', 3, 4.50))
    rules.add_rule(PricingRuleTypes::PercentageDiscount.new('CF1', 3, 1.0/3.0))  # 1/3 discount = 2/3 price
    rules
  end

  let(:checkout) { Checkout.new(pricing_rules) }

  describe '#scan' do
    it 'adds valid product to the cart' do
      expect { checkout.scan('GR1') }.not_to raise_error
    end

    it 'raises error for unknown product code' do
      expect { checkout.scan('UNKNOWN') }.to raise_error('Unknown product code: UNKNOWN')
    end
  end

  describe '#total' do
    context 'with provided test scenarios' do
      it 'calculates correct total for basket: GR1,SR1,GR1,GR1,CF1' do
        checkout.scan('GR1')
        checkout.scan('SR1')
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('CF1')
        
        expect(checkout.total).to eq(22.45)
      end

      it 'calculates correct total for basket: GR1,GR1' do
        checkout.scan('GR1')
        checkout.scan('GR1')
        
        expect(checkout.total).to eq(3.11)
      end

      it 'calculates correct total for basket: SR1,SR1,GR1,SR1' do
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('GR1')
        checkout.scan('SR1')
        
        expect(checkout.total).to eq(16.61)
      end

      it 'calculates correct total for basket: GR1,CF1,SR1,CF1,CF1' do
        checkout.scan('GR1')
        checkout.scan('CF1')
        checkout.scan('SR1')
        checkout.scan('CF1')
        checkout.scan('CF1')
        
        expect(checkout.total).to eq(30.57)
      end
    end

    context 'with single items' do
      it 'calculates correct total for single green tea' do
        checkout.scan('GR1')
        
        expect(checkout.total).to eq(3.11)
      end

      it 'calculates correct total for single strawberry' do
        checkout.scan('SR1')
        
        expect(checkout.total).to eq(5.00)
      end

      it 'calculates correct total for single coffee' do
        checkout.scan('CF1')
        
        expect(checkout.total).to eq(11.23)
      end
    end

    context 'with mixed scenarios' do
      it 'handles empty cart' do
        expect(checkout.total).to eq(0.0)
      end

      it 'handles multiple scans correctly' do
        checkout.scan('GR1')
        expect(checkout.total).to eq(3.11)
        
        checkout.scan('GR1')
        expect(checkout.total).to eq(3.11)
      end
    end
  end
end
