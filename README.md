# Exosky! Team Tango
Este proyecto es una aplicación Flutter que permite visualizar el cielo nocturno desde exoplanetas.

## Estructura del Proyecto

### Componentes Principales

#### models/
- **exoplanet.dart**: Modelo para representar un exoplaneta.
- **star.dart**: Modelo para representar una estrella.
- **constellation.dart**: Modelo para representar una constelación creada por el usuario.

#### services/
- **data_service.dart**: Servicio para cargar y manejar los datos de exoplanetas y estrellas.
- **star_calculation_service.dart**: Servicio para realizar cálculos de posición y brillo de las estrellas.
- **image_generation_service.dart**: Servicio para generar imágenes de alta calidad del cielo.

#### screens/
- **home_screen.dart**: Pantalla principal de la aplicación.
- **exoplanet_selection_screen.dart**: Pantalla para seleccionar un exoplaneta.
- **sky_view_screen.dart**: Pantalla para ver el cielo desde el exoplaneta seleccionado.
- **constellation_creation_screen.dart**: Pantalla para crear y nombrar constelaciones.

#### widgets/
- **star_chart.dart**: Widget para mostrar un mapa estelar estático.
- **interactive_sky.dart**: Widget para una visualización interactiva del cielo.
- **constellation_drawer.dart**: Widget para dibujar constelaciones.

#### utils/
- **constants.dart**: Constantes utilizadas en toda la aplicación.
- **helpers.dart**: Funciones de utilidad.

## Flujo de la Aplicación

1. El usuario inicia la aplicación en la pantalla de inicio.
2. El usuario selecciona un exoplaneta.
3. La aplicación carga los datos necesarios y realiza los cálculos.
4. El usuario ve el cielo desde el exoplaneta seleccionado.
5. El usuario puede interactuar con la vista, crear constelaciones, etc.
6. Opcionalmente, el usuario puede generar una imagen de alta calidad para imprimir o ver en realidad virtual.

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema. Si no lo tienes, sigue las instrucciones en [flutter.dev](https://flutter.dev/docs/get-started/install).

2. Clona este repositorio:
`git clone https://github.com/free4fun/NASA2024Tango.git`

3. Navega al directorio del proyecto:
`cd NASA2024Tango/exosky_tango`

4. Obtén las dependencias del proyecto:
`flutter pub get`

5. Conecta un dispositivo o inicia un emulador.
FIXME

6. Ejecuta la aplicación:
`flutter run`


## Uso

1. Al abrir la aplicación, serás recibido por la pantalla de inicio.

2. Selecciona "Explorar Exoplanetas" para ver la lista de exoplanetas disponibles.

3. Elige un exoplaneta de la lista para visualizar su cielo nocturno.

4. En la pantalla de visualización del cielo:
- Usa gestos de "pellizco" para hacer zoom.
- Desliza para moverte por el cielo.
- Toca una estrella para ver su información.

5. Para crear una constelación:
- Selecciona "Crear Constelación" en el menú.
- Une las estrellas con tu dedo para dibujar la constelación.
- Dale un nombre a tu constelación y guárdala.

6. Para generar una imagen de alta calidad:
- Selecciona "Generar Imagen" en el menú.
- Elige las opciones de calidad y formato.
- Guarda la imagen en tu dispositivo o compártela.

## Licencia

Este proyecto está licenciado bajo la GNU General Public License v3.0 (GPL-3.0). Esto significa que puedes copiar, distribuir y modificar el software, siempre que rastrees los cambios/fechas en los archivos fuente. Cualquier modificación o software que incluya código bajo GPL-3.0 debe también estar disponible bajo la GPL-3.0 junto con instrucciones de compilación e instalación.

Para más detalles, consulta el archivo [LICENSE](LICENSE) en este repositorio o visita [https://www.gnu.org/licenses/gpl-3.0.en.html](https://www.gnu.org/licenses/gpl-3.0.en.html).
