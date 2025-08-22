require_relative 'base'

module PricingRuleTypes
  class PercentageDiscount < Base
    attr_reader :minimum_quantity, :discount_percentage

    def initialize(product_code, minimum_quantity, discount_percentage)
      super(product_code)
      @minimum_quantity = minimum_quantity
      @discount_percentage = discount_percentage # e.g 0.33 for 33% discount
    end

    def apply(items)
      matching_items = find_matching_items(items)
      
      return 0 unless minimum_quantity_met?(items, minimum_quantity)
      
      remove_all_matching_items(items)
      
      original_price = get_item_price(matching_items)
      discounted_price = original_price * (1 - discount_percentage)
      
      (matching_items.size * discounted_price).round(2)
    end
  end
end
