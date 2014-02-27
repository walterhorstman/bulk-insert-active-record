require_relative('inserters')

module BulkInsertActiveRecord

  def self.included(base)
    base.class_eval do

      def self.bulk_insert(rows, columns = nil)
        fail('No connection with the database') unless self.connection.active?

        inserter = Inserters::factory(self, columns: columns)
        self.transaction do
          if inserter.nil?
            self.insert_one_by_one(column_names, rows)
          else
            # only insert 1000 rows at once (TODO: make this configurable?)
            rows.in_groups_of(1000, false) do |grouped_rows|
              sql = inserter.process(rows)
              puts(sql)
            end
          end
        end
      end

      private

      def self.insert_one_by_one(column_names, rows)
        self.transaction do
          rows.each do |column|
            record = self.new
            column_names.each_with_index do |column_name, index|
              record[column_name] = column[index]
            end
            record.save
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include(BulkInsertActiveRecord)
end