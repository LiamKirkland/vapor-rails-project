class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def strip_downcase(str)
    str.strip.downcase
  end
end
