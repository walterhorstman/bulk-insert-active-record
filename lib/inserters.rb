Dir[File.expand_path('../inserters/*.rb', __FILE__)].each { |file_name| require(file_name) }

module BulkInsertActiveRecord
  # Inserters module
  module Inserters
    def self.factory(active_record_class)
      inserter_class = case active_record_class.connection.adapter_name.downcase
                       when 'mssql', 'mysql', 'mysql2', 'sqlserver' then Base
                       when 'oracle' then Oracle
                       end

      inserter_class.nil? ? nil : inserter_class.new(active_record_class)
    end
  end
end
