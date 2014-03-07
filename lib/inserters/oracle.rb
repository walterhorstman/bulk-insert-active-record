require_relative('sequenced')

module BulkInsertActiveRecord
  module Inserters
    class Oracle < Sequenced

      def initialize(active_record_class, options = {})
        super(active_record_class, {
          statement: 'INSERT INTO %{table_name}(%{columns_clause}) %{values_clause}',
          record_statement: 'SELECT %{value_clause} FROM dual',
          sequence_statement: "#{active_record_class.sequence_name}.NEXTVAL",
          record_separator: ' UNION '
        }.merge(options))
      end
    end
  end
end