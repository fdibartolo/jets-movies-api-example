class Movie
  include Dynamoid::Document

  field :year, :integer
  range :title, :string
  field :info, :raw
  
  table name: :movies, key: :year
end
