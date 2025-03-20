module ApplicationHelper
    def icon(family, name, options = {})
      classes = "#{family} fa-#{name}"
      classes += " #{options[:class]}" if options[:class].present?
      tag.i(nil, class: classes)
    end
  end