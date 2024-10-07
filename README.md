# Exosky! Team Tango
a starry night from an exoplanet of their choice, learn about the planet and create unique constellations.

Its importance relies on the complexity of most databases that makes the information inaccessible for most people. The Sky Cluster simplifies NASA's open-coded databases and transforms them into a friendly interface useful for students or persons with a passion for astronomy. In addition, the possibility of drawing new constellations incites imagination and creativity.

![Tango-logo](https://github.com/user-attachments/assets/ba1766cf-3744-4568-8962-6b80696aa3d0)


## Overview
https://theskycluster.my.canva.site/demo ,
https://theskycluster.my.canva.site/detail

## Demo
https://youtu.be/-sfjt4HzBP8

## Project structure

### Main components

#### Models/
- ** Exoplanet.dart **: Model to represent an exoplanet.
- ** Star.dart **: Model to represent a star.
- ** Constellation.dart **: Model to represent a user-created constellation.

#### Services/
- ** Data_service.dart **: Service to load and handle exoplanets and stars data.
- ** Image_generation_service.dart **: Service to generate high-quality images of the sky.

#### Screens/
- ** Home_Screen.Dart **: Main screen of the application.
- ** Exoplanet_selection_screen.dart **: Screen to select an exoplanet.
-*Sky_View_screen.dart **: Screen to see the sky from the selected exoplanet.
- ** Constellation_CREATION_SCREEN.Dart **: screen to create and name constellations.

#### Widgets/
- ** Star_chart.dart **: Widget to show a static stellar map.
- ** Interactive_sky.dart **: Widget for interactive visualization of the night sky.
- ** Constellation_drawer.dart **: Widget to draw constellations.

#### Use/
- ** Constants.Dart **: constants used throughout the application.
- ** Helpers.dart **: Utility functions.

## Application flow

1. The user starts the application on the home screen with a view of the night sky, and can select planets to view its details.
2. The user selects an exoplanet.
3. The application loads the necessary data and performs the calculations.
4. The user sees the sky from the selected exoplanet.
5. The user can interact with the view, create constellations, etc.
6. Optionally, the user can generate a high quality image to print or see virtual.

## Instructions

1. Be sure to have Flutter installed in your system. If you don't have it, follow the instructions in [flutter.dev] (https://flutter.dev/docs/get-started/install).

2. Clona this repository:
`git clone [https: // github.com/free4fun/nasa2024tango.git`](https://github.com/free4fun/NASA2024Tango/)

3. Navigate to the project directory:
`CD NASA2024TANGO/EXOSKY_TANGO`

4. Get the project units:
`Flutter Pub Get`

5. [Optional]Connect a device / run an emulator on Android Studio for Mobile view

6. Execute the application:
`Flutter Run` (if no device is connected it can still run on Chrome by selecting 2 on the command line


## Use

1. When you open the application, you will be received by the home screen.

2. Select "Explore exoplanets" to see the list of exoplanets available.

3. Choose an exoplanet from the list to visualize your night sky.

4. On the sky visualization screen:
- Use "pinch" gestures to zoom.
- Slide to move through the sky.
- Touch a star to see your information.

5. To create a constellation:
- Select "Create constellation" in the menu.
- Unite the stars with your finger to draw the constellation.
- Give your constellation a name and guide it.

6. To generate a high quality image:
- Select "generate image" on the menu.
- Choose quality and format options.
- Keep the image on your device or share it.

- https://youtu.be/OmRkvPIDrF4
- 
https://youtu.be/AmVXjQzOBVw
## License

This project is licensed under the GNU General Public License V3.0 (GPL-3.0). This means that you can copy, distribute and modify the software, provided that the changes/dates in the source files. Any modification or software that includes GPL-3.0 code must also be available under GPL-3.0 together with compilation and installation instructions.

For more details, consult the [License] (License) file in this repository or visit [https://www.gnu.org/licenses/gpl-3.0.en.html Licenses/GPL-3.0.en.html).
