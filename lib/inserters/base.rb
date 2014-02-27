# This base implementation works for MySQL and SQLServer
module BulkInsertActiveRecord
  module Inserters
    class Base

      def initialize(active_record_class, options = {})
        @active_record_class = active_record_class
        @columns = options[:columns] || @active_record_class.column_names
        @separator = options[:separator] || ', '
        @sql = options[:sql] || 'INSERT INTO %{table_name}(%{columns_clause}) VALUES %{values_clause}'
      end

      def process(rows)
        @sql % {
          table_name: @active_record_class.quoted_table_name,
          columns_clause: @columns.map { |column| @active_record_class.connection.quote_column_name(column) }.join(', '),
          values_clause: rows.map { |row| value_clause(row) }.join(@separator)
        }
      end

      private

      def value_clause(row)
        ['(', row.map { |column| @active_record_class.quote_value(column) }.join(', '), ')'].join
      end
    end
  end
end