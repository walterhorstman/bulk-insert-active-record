require_relative('base')

module BulkInsertActiveRecord
  module Inserters
    class Oracle < Base

      def initialize(active_record_class, options = {})
        super(active_record_class, {
          separator: ' UNION ',
          sql: 'INSERT INTO %{table_name}(%{columns_clause}) %{values_clause}'
        }.merge(options))
      end

      private

      def value_clause(row)
        ['SELECT ', row.map { |column| @active_record_class.quote_value(column) }.join(', '), ' FROM dual'].join
      end
    end
  end
end