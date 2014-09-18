module ActiveMongoid
  module Associations
    module ActiveRecord
      module Finders
        extend ActiveSupport::Concern

        module ClassMethods

          def find(*args)
            key = args.flatten.first
            if key.is_a?(String) || key.is_a?(BSON::ObjectId)
              where({_id: key})
            else
              super(*args)
            end
          end

          def where(opts = :chain, *rest)
            bson_opts = opts.select{|k,v| v.is_a?(BSON::ObjectId)}
            bson_opts.map{|k,v| bson_opts[k] = v.to_s}
            opts.merge!(bson_opts)
            super(opts, *rest)
          end

        end

      end
    end
  end
end
