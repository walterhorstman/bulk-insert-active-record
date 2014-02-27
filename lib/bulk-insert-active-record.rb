require_relative('inserters')

module BulkInsertActiveRecord

  def self.included(base)
    base.class_eval do

      def self.bulk_insert(rows, column_names = self.column_names)
        fail('No connection with the database') unless self.connection.active?

        inserter = Inserters::factory(self)
        self.transaction do
          if inserter.nil?
            self.insert_one_by_one(rows, column_names)
          else
            inserter.get_sql(rows, column_names) do |sql|
              puts(sql)
              # TODO: execute sql
            end
          end
        end
      end

      private

      def self.insert_one_by_one(rows, column_names)
        self.transaction do
          rows.each do |row|
            if row.is_a?(self)
              row.save
            else
              record = self.new
              column_names.each_with_index do |column_name, index|
                record[column_name] = row[index]
              end
              record.save
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