require_relative('base')

module BulkInsertActiveRecord
  module Inserters
    class Sequenced < Base

      def initialize(active_record_class, options = {})
        @primary_key_name = active_record_class.primary_key
        # SQL fragment defining how a sequenced value should be constructed
        @sequence_statement = options[:sequence_statement]
        super(active_record_class, options)
      end

      # returns bulk insert statement
      def statement(records, column_names)
        column_names.map!(&:to_s)
        # if a primary key column wasn't specified, add it manually
        add_primary_key = column_names.exclude?(@primary_key_name)
        column_names << @primary_key_name if add_primary_key
        # save position within each row array of the primary key
        primary_key_index = column_names.index(@primary_key_name)

        @statement % {
          table_name: @quoted_table_name,
          columns_clause: column_names.map { |column_name| @connection.quote_column_name(column_name) }.join(@column_separator),
          values_clause: records.map do |record|
            # if we need to manually added the primary key, add it to the end of the row array
            if add_primary_key
              record << @sequence_statement
            else
              record[primary_key_index] = (record[primary_key_index] == nil) ? @sequence_statement : @connection.quote(record[primary_key_index])
            end

            @record_statement % {
              value_clause: record.map.with_index { |value, index| (index == primary_key_index) ? value : @connection.quote(value) }.join(@value_separator)
            }
          end.join(@record_separator)
        }
      end
    end
  end
end