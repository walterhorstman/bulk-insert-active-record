# This base implementation works for MySQL and SQLServer
module BulkInsertActiveRecord
  module Inserters
    class Base

      def initialize(active_record_class, options = {})
        @connection = active_record_class.connection
        @quoted_table_name = active_record_class.quoted_table_name

        # basic bulk insert statement
        @statement = options[:statement] || 'INSERT INTO %{table_name}(%{columns_clause}) VALUES %{values_clause}'
        # character(s) used to separate columns in the columns_clause of the statement
        @column_separator = options[:column_separator] || ','
        # character(s) used to separate records in the values_clause of the statement
        @record_separator = options[:record_separator] || ','
        # sql fragment for individual records in the values_clause of the statement
        @record_statement = options[:record_statement] || '(%{value_clause})'
        # character(s) used to separate values in the value_clause of the record statement
        @value_separator = options[:value_separator] || ','
      end

      # returns bulk insert statement
      def statement(records, column_names)
        @statement % {
          table_name: @quoted_table_name,
          columns_clause: column_names.map { |column_name| @connection.quote_column_name(column_name) }.join(@column_separator),
          values_clause: records.map do |record|
            @record_statement % {
              value_clause: record.map { |value| @connection.quote(value) }.join(@value_separator)
            }
          end.join(@record_separator)
        }
      end
    end
  end
end
