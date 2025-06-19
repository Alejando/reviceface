# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  renders_one :title
  renders_one :footer

  attr_reader :id, :title_text, :custom_classes

  # Parameters:
  # id: (String, required) The unique ID for the modal element.
  # title_text: (String, optional) A simple string for the modal title if not using the :title slot.
  # open: (Boolean, optional, default: false) Whether the modal should be open initially.
  # restore_scroll: (Boolean, optional, default: true) Whether to restore body scroll on close.
  # custom_classes: (String, optional) Additional CSS classes for the main modal container.
  def initialize(id:, title_text: nil, open: false, restore_scroll: true, custom_classes: "")
    @id = id
    @title_text = title_text
    @open = open
    @restore_scroll = restore_scroll
    @custom_classes = custom_classes
  end

  def open_value
    @open.to_s # Stimulus values are parsed from strings
  end

  def restore_scroll_value
    @restore_scroll.to_s
  end

  def title_content
    title.presence || title_text
  end
end
