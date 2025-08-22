require_relative 'product'
require_relative 'pricing_rules'

class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items = []
  end

  def scan(item_code)
    product = PRODUCTS[item_code]
    raise "Unknown product code: #{item_code}" unless product
    
    @items << product
  end

  def total
    @pricing_rules.apply(@items.dup).round(2)
  end

  private

  PRODUCTS = {
    'GR1' => Product.new('GR1', 'Green tea', 3.11),
    'SR1' => Product.new('SR1', 'Strawberries', 5.00),
    'CF1' => Product.new('CF1', 'Coffee', 11.23)
  }.freeze
end
