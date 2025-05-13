// Notification Helper for ReviceFace
// This module provides functions to easily create and display notifications

const NotificationHelper = {
  /**
   * Show a notification
   * @param {string} type - Type of notification: 'success', 'warning', 'danger', 'confirm'
   * @param {string} message - Message to display
   * @param {Object} options - Additional options
   * @param {string} options.title - Custom title (optional)
   * @param {boolean} options.dismissible - Whether the notification can be dismissed (default: true)
   * @param {number} options.timeout - Time in ms before auto-dismiss (default: 5000, 0 for no auto-dismiss)
   * @param {string} options.position - Position of the notification (default: 'top-right')
   * @param {string} options.customClass - Additional CSS classes for the notification
   */
  show(type, message, options = {}) {
    const notificationsContainer = document.getElementById('notifications');
    if (!notificationsContainer) {
      console.error('Notifications container not found. Make sure you have a div with id="notifications" in your layout.');
      return;
    }
    
    // Determine styles based on notification type
    let typeClass = '';
    let iconClass = '';
    let iconColor = '';
    let title = '';
    
    switch(type) {
      case 'success':
        typeClass = 'bg-green-50 border-green-500 text-green-700';
        iconClass = 'check-circle';
        iconColor = 'text-green-600';
        title = options.title || 'Éxito';
        break;
      case 'warning':
        typeClass = 'bg-yellow-50 border-yellow-500 text-yellow-700';
        iconClass = 'error-circle';
        iconColor = 'text-yellow-600';
        title = options.title || 'Advertencia';
        break;
      case 'danger':
        typeClass = 'bg-red-50 border-red-500 text-red-700';
        iconClass = 'x-circle';
        iconColor = 'text-red-600';
        title = options.title || 'Error';
        break;
      case 'confirm':
        typeClass = 'bg-blue-50 border-blue-500 text-blue-700';
        iconClass = 'info-circle';
        iconColor = 'text-blue-600';
        title = options.title || 'Información';
        break;
      default:
        typeClass = 'bg-gray-50 border-gray-500 text-gray-700';
        iconClass = 'info-circle';
        iconColor = 'text-gray-600';
        title = options.title || 'Notificación';
    }
    
    // Create notification element
    const notificationWrapper = document.createElement('div');
    
    // Build notification HTML
    notificationWrapper.innerHTML = `
      <div class="p-4 rounded-md border-l-4 shadow-sm w-full ${typeClass} ${options.customClass || ''}"
           data-controller="notification"
           data-notification-timeout-value="${options.timeout !== undefined ? options.timeout : 5000}"
           data-notification-position-value="${options.position || 'top-right'}"
           role="alert">
        <div class="flex items-start justify-between">
          <div class="flex">
            <div class="flex-shrink-0 mr-3">
              <span class="icon ${iconClass} w-5 h-5 ${iconColor}"></span>
            </div>
            <div>
              <p class="font-bold">${title}</p>
              <p class="text-sm">${message}</p>
            </div>
          </div>
          ${options.dismissible !== false ? `
            <button type="button"
                    class="-mx-1.5 -my-1.5 ml-auto flex items-center justify-center p-1.5 rounded-lg hover:bg-gray-100 focus:ring-2 focus:ring-gray-300"
                    data-action="notification#dismiss"
                    aria-label="Close">
              <span class="icon x w-4 h-4"></span>
            </button>
          ` : ''}
        </div>
      </div>
    `;
    
    // Add notification to container
    const notificationElement = notificationWrapper.firstElementChild;
    notificationsContainer.appendChild(notificationElement);
    
    return notificationElement;
  },
  
  /**
   * Show a success notification
   * @param {string} message - Message to display
   * @param {Object} options - Additional options
   */
  success(message, options = {}) {
    return this.show('success', message, options);
  },
  
  /**
   * Show a warning notification
   * @param {string} message - Message to display
   * @param {Object} options - Additional options
   */
  warning(message, options = {}) {
    return this.show('warning', message, options);
  },
  
  /**
   * Show a danger/error notification
   * @param {string} message - Message to display
   * @param {Object} options - Additional options
   */
  danger(message, options = {}) {
    return this.show('danger', message, options);
  },
  
  /**
   * Show an info/confirm notification
   * @param {string} message - Message to display
   * @param {Object} options - Additional options
   */
  info(message, options = {}) {
    return this.show('confirm', message, options);
  }
};

export default NotificationHelper;
