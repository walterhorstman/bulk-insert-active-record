require_relative('base')

module BulkInsertActiveRecord
  module Inserters
    class Oracle < Base

      def initialize(active_record_class)
        @base_sql ||= 'INSERT INTO %{table_name}(%{columns_clause}) %{values_clause}'
        @value_fragment_sql ||= 'SELECT %{value_clause} FROM dual'
        @value_separator ||= ' UNION '
        super(active_record_class)
      end
   end
  end
end