module TransactionNormalizer
    DELIMITER_REGEX = /[,|\s|;|:]+/
    
    def self.normalize(transaction)
      # Ensure input is a hash before proceeding
      return transaction unless transaction.is_a?(Hash)
      
      # Duplicate to avoid modifying the original object
      transaction = transaction.dup
      
      # Convert all keys to symbols
      transaction.transform_keys!(&:to_sym)
  
      # Convert buyer_type to symbol
      transaction[:buyer_type] = transaction[:buyer_type].to_s.strip.downcase.to_sym if transaction[:buyer_type]
  
      # Ensure country codes are uppercase
      transaction[:buyer_country] = transaction[:buyer_country].to_s.strip.upcase if transaction[:buyer_country]
      transaction[:service_location] = transaction[:service_location].to_s.strip.upcase if transaction[:service_location]
  
      # Convert transaction_type to set
      if transaction[:transaction_type]
          case transaction[:transaction_type]
          when String
            transaction[:transaction_type] = transaction[:transaction_type].split(DELIMITER_REGEX).to_set
          when Array
            transaction[:transaction_type] = transaction[:transaction_type].to_set
          else
            transaction[:transaction_type] = Set.new([transaction[:transaction_type]])
          end
      end
  
      transaction
    end
  end
  