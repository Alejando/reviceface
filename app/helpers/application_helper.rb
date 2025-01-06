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
end
