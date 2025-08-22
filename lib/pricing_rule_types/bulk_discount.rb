require_relative 'base'

module PricingRuleTypes
  class BulkDiscount < Base
    attr_reader :minimum_quantity, :discounted_price

    def initialize(product_code, minimum_quantity, discounted_price)
      super(product_code)
      @minimum_quantity = minimum_quantity
      @discounted_price = discounted_price
    end

    def apply(items)
      matching_items = find_matching_items(items)
      
      return 0 unless minimum_quantity_met?(items, minimum_quantity)
      
      remove_all_matching_items(items)
      
      matching_items.size * discounted_price
    end
  end
end
