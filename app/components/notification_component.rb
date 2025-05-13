class NotificationComponent < ViewComponent::Base
  attr_reader :type, :message, :dismissible, :timeout, :title_text, :position, :custom_class

  def initialize(type:, message:, dismissible: true, timeout: 5000, title: nil, position: "top-right", custom_class: nil)
    @type = type
    @message = message
    @dismissible = dismissible
    @timeout = timeout
    @title_text = title
    @position = position
    @custom_class = custom_class
  end

  def icon_class
    case @type
    when :success
      "check-circle"
    when :warning
      "error-circle"
    when :danger
      "x-circle"
    when :confirm
      "info-circle"
    else
      "info-circle"
    end
  end

  def icon_color_class
    case @type
    when :success
      "text-green-600"
    when :warning
      "text-yellow-600"
    when :danger
      "text-red-600"
    when :confirm
      "text-blue-600"
    else
      "text-gray-600"
    end
  end
  
  def container_class
    base_class = "p-4 rounded-md border-l-4 shadow-sm w-full"
    
    type_class = case @type
    when :success
      "bg-green-50 border-green-500 text-green-700"
    when :warning
      "bg-yellow-50 border-yellow-500 text-yellow-700"
    when :danger
      "bg-red-50 border-red-500 text-red-700"
    when :confirm
      "bg-blue-50 border-blue-500 text-blue-700"
    else
      "bg-gray-50 border-gray-500 text-gray-700"
    end
    
    [base_class, type_class, @custom_class].compact.join(" ")
  end

  def title
    return @title_text if @title_text.present?
    
    case @type
    when :success
      "Éxito"
    when :warning
      "Advertencia"
    when :danger
      "Error"
    when :confirm
      "Información"
    else
      "Notificación"
    end
  end
  
  def stimulus_values
    {
      "notification-timeout-value": @timeout,
      "notification-position-value": @position
    }
  end
  
  def stimulus_attributes
    stimulus_values.map { |key, value| "data-#{key}=\"#{value}\"" }.join(" ")
  end
end
