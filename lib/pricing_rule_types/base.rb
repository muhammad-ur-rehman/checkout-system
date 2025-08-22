# Base class for all pricing rules with shared functionality
module PricingRuleTypes
  class Base
    attr_reader :product_code

    def initialize(product_code)
      @product_code = product_code
    end

    def apply(items)
      raise NotImplementedError, "Subclasses must implement #apply method"
    end

    protected

    def find_matching_items(items)
      items.select { |item| item.code == product_code }
    end

    def remove_all_matching_items(items)
      items.reject! { |item| item.code == product_code }
    end

    def remove_matching_items(items, count)
      removed = 0
      while removed < count && (index = items.find_index { |item| item.code == product_code })
        items.delete_at(index)
        removed += 1
      end
      removed
    end

    def minimum_quantity_met?(items, minimum)
      find_matching_items(items).size >= minimum
    end

    def get_item_price(items)
      matching_item = find_matching_items(items).first
      matching_item&.price || 0
    end
  end
end
