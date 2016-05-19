module BulkInsertActiveRecord
  module Inserters
    # Implementation specific for Oracle
    class Oracle < Base
      def execute(records, column_names) # override
        statement = 'BEGIN INSERT INTO %{table_name}(%{columns_clause}) VALUES(%{values_clause}); END;'
        @connection.execute(format(statement, table_name: @quoted_table_name,
                                              columns_clause: column_names.map do |column_name|
                                                @connection.quote_column_name(column_name)
                                              end.join(','),
                                              values_clause: records.map do |record|
                                                value_clause = record.map { |value| @connection.quote(value) }.join(',')
                                                "SELECT #{value_clause} FROM dual"
                                              end.join(' UNION ')))
      end
    end
  end
end
