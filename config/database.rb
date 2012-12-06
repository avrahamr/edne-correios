# encoding: utf-8

require "data_mapper"
require "dm-migrations/migration_runner"

DataMapper.setup(:default,  "sqlite3:db/database.sqlite3")
DataMapper::Logger.new STDOUT, :debug
DataMapper::Model.raise_on_save_failure = true
DataMapper::Property::String.length(255)

MODELS = [Bairro, GrandeUsuario, Localidade, Logradouro, UnidadeOperacional]

MODELS.each_with_index do |model, index|
  table_name = DataMapper::NamingConventions::Resource::UnderscoredAndPluralized.call model

  migration index + 1, "create_#{table_name}_table" do
    up do
      create_table table_name do
        column :id, Integer , serial: true
        model::COLUMN_NAMES.each{|column_name| column(column_name, String, length: 255)}
      end
    end

    down do
      drop_table table_name
    end
  end
end
