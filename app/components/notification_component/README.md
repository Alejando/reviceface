# Componente de Notificaciones para ReviceFace

Este componente proporciona un sistema de notificaciones flexible y reutilizable para la aplicación ReviceFace, siguiendo el enfoque de View Components y utilizando Tailwind CSS para los estilos, Hotwire/Stimulus para la interactividad, y Boxicons de la gema rails_icons para los iconos.

## Características

- Múltiples tipos de notificaciones: éxito, advertencia, error, información
- Personalización de títulos, mensajes y estilos
- Auto-cierre configurable
- Animaciones de entrada/salida
- Posicionamiento flexible
- Interacción con el ratón (pausa al hacer hover)
- API JavaScript para uso dinámico

## Uso en controladores

Las notificaciones pueden mostrarse fácilmente desde los controladores utilizando el sistema de flash messages de Rails:

```ruby
def create
  @patient = Patient.new(patient_params)
  
  if @patient.save
    flash[:success] = "Paciente creado correctamente"
    redirect_to patients_path
  else
    flash.now[:error] = "Error al crear el paciente"
    render :new, status: :unprocessable_entity
  end
end
```

El sistema automáticamente mapea los tipos de flash a los tipos de notificación:
- `:notice`, `:info` → `:confirm` (azul)
- `:success` → `:success` (verde)
- `:error` → `:danger` (rojo)
- `:alert` → `:warning` (amarillo)

## Uso directo en vistas

También puedes renderizar el componente directamente en tus vistas:

```erb
<%= render(NotificationComponent.new(
  type: :success,
  message: "Operación completada con éxito",
  dismissible: true,
  timeout: 5000,
  title: "Título personalizado",
  position: "top-right",
  custom_class: "my-custom-class"
)) %>
```

### Parámetros disponibles

| Parámetro | Tipo | Valor por defecto | Descripción |
|-----------|------|-------------------|-------------|
| type | Symbol | - | Tipo de notificación: `:success`, `:warning`, `:danger`, `:confirm` |
| message | String | - | Mensaje a mostrar en la notificación |
| dismissible | Boolean | true | Si la notificación puede ser cerrada por el usuario |
| timeout | Integer | 5000 | Tiempo en milisegundos antes de que la notificación desaparezca automáticamente. 0 para no desaparecer. |
| title | String | nil | Título personalizado para la notificación. Si no se especifica, se usa un título predeterminado según el tipo. |
| position | String | "top-right" | Posición de la notificación: "top-right", "top-left", "bottom-right", "bottom-left", "top-center", "bottom-center" |
| custom_class | String | nil | Clases CSS personalizadas para aplicar al contenedor de la notificación |

## Uso con variables locales

Puedes pasar un array de notificaciones al partial compartido:

```erb
<%= render "shared/notifications", notifications: [
  { type: :success, message: "Primera notificación" },
  { type: :warning, message: "Segunda notificación", dismissible: false },
  { type: :danger, message: "Tercera notificación", timeout: 10000 }
] %>
```

## Uso desde JavaScript

El componente incluye un helper de JavaScript que facilita mostrar notificaciones dinámicamente:

```javascript
// Importar el helper (no es necesario si ya está expuesto globalmente)
import NotificationHelper from "notification_helper";

// Mostrar una notificación de éxito
NotificationHelper.success("Operación completada con éxito", {
  title: "Título personalizado",
  timeout: 5000,
  position: "top-right",
  dismissible: true,
  customClass: "my-custom-class"
});

// Otros tipos de notificaciones
NotificationHelper.warning("Mensaje de advertencia");
NotificationHelper.danger("Mensaje de error");
NotificationHelper.info("Mensaje informativo");

// Método genérico
NotificationHelper.show("success", "Mensaje", options);
```

## Página de ejemplos

Para ver ejemplos de todas las variantes de notificaciones, visita la página de ejemplos en `/examples/notifications`.

## Personalización

El componente está diseñado para ser fácilmente personalizable. Puedes modificar los colores, iconos y estilos en los archivos:

- `app/components/notification_component.rb` - Lógica del componente
- `app/components/notification_component.html.erb` - Plantilla HTML
- `app/javascript/controllers/notification_controller.js` - Controlador Stimulus
