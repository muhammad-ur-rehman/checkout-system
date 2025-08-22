# Supermarket Checkout System

A simple Ruby checkout system for a small supermarket chain that handles product scanning and applies promotional discounts.

## What it does

This system lets you scan products and calculates the total price, applying different promotional rules:

- **Green Tea**: Buy one, get one free (CEO's favorite!)
- **Strawberries**: £4.50 each when you buy 3 or more (instead of £5.00)
- **Coffee**: 1/3 off when you buy 3 or more (CTO loves coffee!)

## Products

| Code | Product | Price |
|------|---------|-------|
| GR1  | Green tea | £3.11 |
| SR1  | Strawberries | £5.00 |
| CF1  | Coffee | £11.23 |

## How to run it

1. Install Ruby (3.3.6 or newer)
2. Install dependencies:
   ```bash
   bundle install
   ```
3. See it in action:
   ```bash
   ruby example.rb
   ```
4. Run the tests:
   ```bash
   bundle exec rspec
   ```

## Example usage

```ruby
require_relative 'lib/checkout'
require_relative 'lib/pricing_rules'

# Set up the promotional rules
pricing_rules = PricingRules.new
pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('GR1'))
pricing_rules.add_rule(PricingRuleTypes::BulkDiscount.new('SR1', 3, 4.50))
pricing_rules.add_rule(PricingRuleTypes::PercentageDiscount.new('CF1', 3, 1.0/3.0))

# Start scanning
checkout = Checkout.new(pricing_rules)
checkout.scan('GR1')  # Green tea
checkout.scan('SR1')  # Strawberries
checkout.scan('GR1')  # Another green tea (free!)

puts "Total: £#{checkout.total}"  # Applies discounts automatically
```

## Test scenarios

The system correctly handles these test cases:

| Items scanned | Expected total | ✅ |
|---------------|----------------|---|
| GR1,SR1,GR1,GR1,CF1 | £22.45 | ✅ |
| GR1,GR1 | £3.11 | ✅ |
| SR1,SR1,GR1,SR1 | £16.61 | ✅ |
| GR1,CF1,SR1,CF1,CF1 | £30.57 | ✅ |

## Project structure

Here's what each file does:

### Main files
- **`example.rb`** - Demonstrates the system with test data
- **`Gemfile`** - Lists the Ruby gems we need

### Code (`lib/` folder)
- **`checkout.rb`** - Main checkout class that scans items and calculates totals
- **`product.rb`** - Simple class that holds product information (code, name, price)
- **`pricing_rules.rb`** - Manages and applies all the promotional rules

### Pricing rules (`lib/pricing_rule_types/` folder)
- **`base.rb`** - Shared functionality for all pricing rules
- **`buy_one_get_one_free.rb`** - Buy one, get one free promotions
- **`bulk_discount.rb`** - Fixed price discounts for bulk purchases
- **`percentage_discount.rb`** - Percentage-based discounts for bulk purchases

### Tests (`spec/` folder)
- **`spec_helper.rb`** - Test configuration
- **`checkout_spec.rb`** - Tests the main checkout functionality
- **`product_spec.rb`** - Tests the product class
- **`pricing_rules_spec.rb`** - Tests the main pricing rules system
- **`pricing_rules/`** - Individual tests for each pricing rule type

## Why this design?

- **Simple to use** - Just scan items and get the total
- **Easy to change** - Want new promotions? Just add a new rule
- **Flexible** - Works with any combination of items in any order
- **Well tested** - 44 tests ensure everything works correctly
- **Clean code** - Each file has one clear responsibility

## Adding new products

Add them to the `PRODUCTS` hash in `checkout.rb`:

```ruby
PRODUCTS = {
  'GR1' => Product.new('GR1', 'Green tea', 3.11),
  'SR1' => Product.new('SR1', 'Strawberries', 5.00),
  'CF1' => Product.new('CF1', 'Coffee', 11.23),
  'BR1' => Product.new('BR1', 'Bread', 2.50)  # New product
}.freeze
```

## Adding new promotional rules

Want to add a new promotion? Create it using the existing rule types:

```ruby
# 20% off when buying 5+ items of any product
pricing_rules.add_rule(PricingRuleTypes::PercentageDiscount.new('BR1', 5, 0.20))

# Buy 2 get 1 free for bread
pricing_rules.add_rule(PricingRuleTypes::BuyOneGetOneFree.new('BR1'))

# Fixed price of £2.00 each when buying 4+ bread
pricing_rules.add_rule(PricingRuleTypes::BulkDiscount.new('BR1', 4, 2.00))
```
