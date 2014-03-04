require_relative('inserters')

module BulkInsertActiveRecord

  def self.included(base)
    base.class_eval do

      def self.bulk_insert(records, column_names = self.column_names)
        fail('No connection with the database') unless self.connection.active?

        inserter = Inserters::factory(self)
        self.transaction do
          if inserter.nil?
            self.insert_one_by_one(records, column_names)
          else
            sql = inserter.statement(records, column_names)
            self.connection.insert(sql)
          end
        end
      end

      private

      def self.insert_one_by_one(records, column_names)
        self.transaction do
          records.each do |record|
            if record.is_a?(self)
              record.save
            else
              item = self.new
              column_names.each_with_index do |column_name, index|
                item[column_name] = record[index]
              end
              item.save
            end
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include(BulkInsertActiveRecord)
end