require_relative 'pricing_rule_types/base'
require_relative 'pricing_rule_types/buy_one_get_one_free'
require_relative 'pricing_rule_types/bulk_discount'
require_relative 'pricing_rule_types/percentage_discount'

class PricingRules
  def initialize
    @rules = []
  end

  def add_rule(rule)
    @rules << rule
  end

  def apply(items)
    total = 0
    items_copy = items.dup

    @rules.each do |rule|
      total += rule.apply(items_copy)
    end

    items_copy.each { |item| total += item.price }

    total.round(2)
  end
end

