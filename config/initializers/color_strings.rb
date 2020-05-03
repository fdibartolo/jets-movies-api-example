# Extend String class to use .red, .bold, etc on stdio
class String
  include Term::ANSIColor
end
