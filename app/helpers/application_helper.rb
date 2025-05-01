module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    case level.to_sym
    when :notice then "bg-info text-white"
    when :success then "bg-success text-white"
    when :error then "bg-error text-white"
    when :alert then "bg-warning text-white"
    else "bg-gray-500 text-white"
    end
  end

  def boolean_to_human(value)
    value ? t("values.boolean.true") : t("values.boolean.false")
  end

  def date_to_human(value)
    return '' unless value
    I18n.l(value.to_date, format: :short)
  end

  def enum_to_human(record, enum_attr)
    return '' unless record && enum_attr && record.send(enum_attr)

    model_name = record.class.name.underscore
    enum_value = record.send(enum_attr)

    I18n.t("activerecord.attributes.#{model_name}.#{enum_attr.to_s.pluralize}.#{enum_value}",
           default: [
             :"enums.#{model_name}.#{enum_attr.to_s.pluralize}.#{enum_value}",
             :"enums.#{enum_attr.to_s.pluralize}.#{enum_value}",
             enum_value.to_s.humanize
           ])
  end
end
