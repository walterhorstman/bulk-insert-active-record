Dir[File.expand_path('../inserters/*.rb', __FILE__)].each { |file_name| require(file_name) }

module BulkInsertActiveRecord
  module Inserters

    def self.factory(active_record_class, options = {})
      inserter_class = case active_record_class.connection.adapter_name.downcase
                       when 'mssql', 'mysql', 'sqlserver' then Base
                       # FIXME: as soon as we know which SQL statement to use, enable the next line
                       # when 'oracle' then Oracle
                       else nil
                       end

      inserter_class.nil? ? nil : inserter_class.new(active_record_class, options)
    end
  end
end
