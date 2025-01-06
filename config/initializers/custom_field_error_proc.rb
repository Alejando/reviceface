# frozen_string_literal: true

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  document = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  element = document.children[0]
  if element.name == 'label'
    p_element = element.at_css('p')
    if p_element
      class_attribute = p_element['class']
      p_element['class'] = class_attribute.to_s + ' text-error'
    end
    document.to_html.html_safe
  elsif ['input', 'textarea', 'select'].include?(element.name)
    class_attribute = element['class']
    element['class'] = class_attribute.to_s + ' border-error'
    document.to_html.html_safe
  else
    html_tag
  end
end

