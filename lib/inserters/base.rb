module BulkInsertActiveRecord
  module Inserters
    # This base implementation works for MySQL and SQLServer
    class Base
      def initialize(active_record_class)
        @connection = active_record_class.connection
        @quoted_table_name = active_record_class.quoted_table_name
      end

      def execute(records, column_names)
        statement = 'INSERT INTO %{table_name}(%{columns_clause}) VALUES(%{values_clause})'
        @connection.insert(format(statement, table_name: @quoted_table_name,
                                             columns_clause: column_names.map do |column_name|
                                               @connection.quote_column_name(column_name)
                                             end.join(','),
                                             values_clause: records.map do |record|
                                               value_clause = record.map { |value| @connection.quote(value) }.join(',')
                                               "(#{value_clause})"
                                             end.join(',')))
      end
    end
  end
end
