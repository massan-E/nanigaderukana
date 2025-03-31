module AutoCompleteHelper
  def display_value(object)
    object.is_a?(Letter) ? object.radio_name : object.title
  end
end
