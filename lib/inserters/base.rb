# This base implementation works for MySQL and SQLServer
module BulkInsertActiveRecord
  module Inserters
    class Base

      def initialize(active_record_class)
        @active_record_class = active_record_class
        # classes that inherit from this class might set the following instance variables in their
        # constructor before calling this one
        @base_sql ||= 'INSERT INTO %{table_name}(%{columns_clause}) VALUES %{values_clause}'
        @value_sql ||= '(%{value_clause})'
        @value_separator ||= ', '
      end

      def get_sql(rows, column_names)
        substitutions = {}
        substitutions[:table_name] = @active_record_class.quoted_table_name
        substitutions[:columns_clause] = column_names.map { |column_name| @active_record_class.connection.quote_column_name(column_name) }.join(', ')

        # yield the bulk insert statement for each 1000 rows (TODO: make this configurable?)
        rows.in_groups_of(1000, false) do |grouped_rows|
          substitutions[:values_clause] = grouped_rows.map do |row|
            @value_sql % {
              value_clause: row.map { |column| @active_record_class.quote_value(column) }.join(', ')
            }
          end.join(@value_separator)
          yield(@base_sql % substitutions)
        end
      end
    end
  end
end