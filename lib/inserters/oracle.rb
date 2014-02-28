require_relative('base')

module BulkInsertActiveRecord
  module Inserters
    class Oracle < Base

      def initialize(active_record_class, options = {})
        super(active_record_class, {
          statement: 'INSERT INTO %{table_name}(%{columns_clause}) %{values_clause}',
          record_statement: 'SELECT %{value_clause} FROM dual',
          record_separator: ' UNION '
        }.merge(options))
      end
    end
  end
end