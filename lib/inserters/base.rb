# This base implementation works for MySQL and SQLServer
module BulkInsertActiveRecord
  module Inserters
    class Base

      def initialize(active_record_class, options = {})
        @active_record_class = active_record_class
        # maximum number of records per generated sql statement
        @bulk_size = options[:bulk_size] || 1000

        # basic bulk insert statement
        @statement = options[:statement] || 'INSERT INTO %{table_name}(%{columns_clause}) VALUES %{values_clause}'
        # character(s) used to separate columns in the columns_clause of the statement
        @column_separator = options[:column_separator] || ', '
        # character(s) used to separate records in the values_clause of the statement
        @record_separator = options[:record_separator] || ', '
        # sql fragment for individual records in the values_clause of the statement
        @record_statement = options[:record_statement] || '(%{value_clause})'
        # character(s) used to separate values in the value_clause of the record statement
        @value_separator = options[:value_separator] || ', '
      end

      # generates bulk insert sql statements, one for each X number of re
      def statements(records, column_names)
        substitutions = {}
        substitutions[:table_name] = @active_record_class.quoted_table_name
        substitutions[:columns_clause] = column_names.map { |column_name| @active_record_class.connection.quote_column_name(column_name) }.join(@column_separator)

        # split the records in groups and yield back the generated sql
        records.in_groups_of(@bulk_size, false) do |grouped_records|
          substitutions[:values_clause] = grouped_records.map do |record|
            @record_statement % {
              value_clause: record.map { |column| @active_record_class.quote_value(column) }.join(@value_separator)
            }
          end.join(@record_separator)
          yield(@statement % substitutions)
        end
      end
    end
  end
end