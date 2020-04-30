class Movie
  include Dynamoid::Document

  field :year, :integer
  range :title, :string
  field :info, :raw
end
