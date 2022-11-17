class EvmAddressValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /^[a-f0-9]{40}$/
        record.errors.add attribute, (options[:message] || "Not a valid evm address")
      end
    end
end