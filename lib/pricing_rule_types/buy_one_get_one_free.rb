require_relative 'base'

module PricingRuleTypes
  class BuyOneGetOneFree < Base
    def apply(items)
      matching_items = find_matching_items(items)
      return 0 if matching_items.empty?

      pairs = matching_items.size / 2
      
      remove_matching_items(items, pairs * 2)
      
      pairs * get_item_price(matching_items)
    end
  end
end
