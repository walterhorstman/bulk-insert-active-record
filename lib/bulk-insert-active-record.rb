# rubocop:disable Style/FileName
require_relative('inserters')

# Extends the given base class (a subclass of ActiveRecord::Base) with a bulk_insert() class method.
module BulkInsertActiveRecord
  # rubocop:disable Metrics/MethodLength
  def self.included(base)
    base.class_eval do
      def self.bulk_insert(records, columns = column_names)
        raise('No connection with the database') unless connection.active?

        inserter = Inserters.factory(self)
        transaction do
          if inserter.nil?
            insert_one_by_one(records, columns)
          else
            inserter.execute(records, columns)
          end
        end
      end

      def self.insert_one_by_one(records, column_names)
        records.each do |record|
          if record.is_a?(self)
            record.save
          else
            item = new
            column_names.each_with_index do |column_name, index|
              item[column_name] = record[index]
            end
            item.save
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end

ActiveSupport.on_load(:active_record) do
  include(BulkInsertActiveRecord)
end
