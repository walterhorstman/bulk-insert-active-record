module BulkInsertActiveRecord
  module Inserters

    def self.factory(active_record_class, options)
      inserter_class = case active_record_class.connection.adapter_name.downcase
                       when 'mssql', 'mysql', 'sqlserver'
                         require_relative('inserters/base')
                         Base
                       when 'oracle'
                         require_relative('inserters/oracle')
                         Oracle
                       else
                         nil
                       end

      inserter_class.nil? ? nil : inserter_class.new(active_record_class, options)
    end
  end
end