module ActiveMongoid
  module Associations
    module RecordRelation
      module Macros
        extend ActiveSupport::Concern

        module ClassMethods

          def belongs_to_record(name, *opt)
            meta = characterize_association(name, Referenced::In, *opt)
            reference_record(meta)
            relate_one_to_one_record(name, meta)
          end

          def has_one_record(name, *opt)
            meta = characterize_association(name, Referenced::One, *opt)
            relate_one_to_one_record(name, meta)
          end

          def has_many_records(name, *opt)
            meta = characterize_association(name, Referenced::Many, *opt)
            relate_record(name, meta)
            # document_ids_setter(name, metadata)
            # document_ids_getter(name, metadata)
          end

          private

          def reference_record(metadata)
            key = metadata.foreign_key
            if metadata.stores_foreign_key? && !fields.include?(key)
              field(
                key,
                type: Integer,
                default: metadata.foreign_key_default
              )
              if metadata.polymorphic?
                self.polymorphic = true
                field(metadata.inverse_type, type: String)
              end
            end
          end

          def relate_one_to_one_record(name, metadata)
            relate_record(name, metadata)
            record_builder(name, metadata)
            record_creator(name, metadata)
          end


          def relate_record(name, metadata)
            self.am_relations = am_relations.merge(name.to_s => metadata)
            record_getter(name, metadata)
            record_setter(name, metadata)
            autosave_records(metadata)
            dependent_records(metadata)
            existence_check(name)
          end

        end
      end

    end
  end
end
