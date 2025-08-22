require_relative 'lib/checkout'
require_relative 'lib/pricing_rules'

# Set up pricing rules as specified in the requirements
pricing_rules = PricingRules.new

# CEO's favorite: Buy-one-get-one-free for Green tea
pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))

# COO's preference: Bulk discount for Strawberries (3+ items at £4.50 each)
pricing_rules.add_rule(PricingRuleTypes::BulkDiscount.new('SR1', 3, 4.50))

# CTO's coffee addiction: 3+ coffees at 2/3 original price (1/3 discount)
pricing_rules.add_rule(PricingRuleTypes::PercentageDiscount.new('CF1', 3, 1.0/3.0))


puts "Testing checkout system with provided test data:\n\n"

# Test scenario 1: GR1,SR1,GR1,GR1,CF1 -> £22.45
puts "Test 1: GR1,SR1,GR1,GR1,CF1"
co = Checkout.new(pricing_rules)
co.scan('GR1')
co.scan('SR1')
co.scan('GR1')
co.scan('GR1')
co.scan('CF1')
puts "Expected: £22.45, Actual: £#{co.total}"
puts

# Test scenario 2: GR1,GR1 -> £3.11
puts "Test 2: GR1,GR1"
co = Checkout.new(pricing_rules)
co.scan('GR1')
co.scan('GR1')
puts "Expected: £3.11, Actual: £#{co.total}"
puts

# Test scenario 3: SR1,SR1,GR1,SR1 -> £16.61
puts "Test 3: SR1,SR1,GR1,SR1"
co = Checkout.new(pricing_rules)
co.scan('SR1')
co.scan('SR1')
co.scan('GR1')
co.scan('SR1')
puts "Expected: £16.61, Actual: £#{co.total}"
puts

# Test scenario 4: GR1,CF1,SR1,CF1,CF1 -> £30.57
puts "Test 4: GR1,CF1,SR1,CF1,CF1"
co = Checkout.new(pricing_rules)
co.scan('GR1')
co.scan('CF1')
co.scan('SR1')
co.scan('CF1')
co.scan('CF1')
puts "Expected: £30.57, Actual: £#{co.total}"
