module Bookkeeper
  module AmountsExtension
    # Returns a sum of the referenced Amount objects.
    #
    # Takes a hash specifying :from_date and :to_date for calculating balances during periods.
    # :from_date and :to_date may be strings of the form "yyyy-mm-dd" or Ruby Date objects
    #
    # This runs the summation in the database, so it only works on persisted records.
    #
    # @example
    #   credit_amounts.balance({:from_date => "2000-01-01", :to_date => Date.today})
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    # TODO: Use `ransack`
    def balance(hash = {})
      return sum(:value) unless hash.key?(:from_date) && hash.key?(:to_date)
      from_date = hash[:from_date].is_a?(Date) ? hash[:from_date] : Date.parse(hash[:from_date])
      to_date = hash[:to_date].is_a?(Date) ? hash[:to_date] : Date.parse(hash[:to_date])
      includes(:entry).where('bookkeeper_entries.date' => from_date..to_date).sum(:value)
    end

    # Returns a sum of the referenced Amount objects.
    #
    # Ensure that the debit and credits are canceling out.
    #
    # Since this does not use the database for summation, it may be used on non-persisted records.
    def balance_for_new_record
      balance = BigDecimal.new('0')
      each do |amount|
        next unless amount.value.present? || amount.marked_for_destruction?
        balance += amount.value
      end
      balance
    end
  end
end
