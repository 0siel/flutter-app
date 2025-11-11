# Cat App (Flutter)

Esta es una aplicación de ejemplo construida con Flutter que consume [The Cat API](https://thecatapi.com/) para mostrar imágenes de gatos. Los usuarios pueden navegar por las imágenes, agregarlas a una lista de favoritos y ver una página de detalles ficticia para cada gato.

Este proyecto comenzó como el tutorial oficial "Namer App" de Flutter y fue evolucionando para incluir:

- Consumo de APIs (HTTP).
- Gestión de estado con `Provider`.
- Navegación entre pantallas.
- Estructura de archivos escalable.

---

## Ejecutar la Aplicación con VS Code

Para poner en marcha este proyecto en tu máquina local usando Visual Studio Code, sigue estos pasos:

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Visual Studio Code](https://code.visualstudio.com/)
- La extensión de [Flutter para VS Code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

### Pasos de Instalación y Ejecución

1.  **Clona el repositorio** (o simplemente descarga los archivos ZIP y descomprímelos):

    ```sh
    git clone https://github.com/0siel/flutter-app.git
    ```

2.  **Abre el proyecto en VS Code**:

    ```sh
    cd flutter-application_1
    code .
    ```

3.  **Instala las dependencias**:
    Abre la paleta de comandos (`Ctrl+Shift+P` o `Cmd+Shift+P`) y escribe **"Flutter: Get Packages"**.
    _O, alternativamente_, abre un terminal integrado en VS Code (`View` -> `Terminal` o `Ctrl+\` \`) y ejecuta:

    ```sh
    flutter pub get
    ```

4.  **Selecciona un dispositivo**:
    En la barra de estado inferior derecha de VS Code, haz clic donde dice "No Device" (o el nombre de un dispositivo). Se abrirá una lista en la parte superior. Elige un emulador de Android, un simulador de iOS, un dispositivo físico conectado o "Chrome (web)" para ejecutar la app en tu navegador.

5.  **Ejecuta la aplicación**:
    Presiona `F5` en tu teclado o ve al menú "Run" > "Start Debugging". VS Code compilará la aplicación y la lanzará en el dispositivo que seleccionaste.

---

## Decisiones de Desarrollo y Arquitectura

Este proyecto fue diseñado para ser un ejercicio de aprendizaje. Las siguientes son las decisiones clave de arquitectura que se tomaron:

### 1. Gestión de Estado: `Provider`

Se eligió el paquete `provider` (específicamente `ChangeNotifier` y `ChangeNotifierProvider`) para manejar el estado global de la aplicación.

- **Por qué**: Es el enfoque recomendado en los tutoriales oficiales de Flutter, es ligero y fácil de entender. Separa limpiamente la lógica de negocio (`MyAppState`) de la interfaz de usuario (los widgets).
- **Cómo**:
  - `MyAppState` extiende `ChangeNotifier` y contiene la lógica central (lista de imágenes, favoritos, estado de carga).
  - Cuando un dato cambia (ej. `getImages()` o `toggleFavorite()`), se llama a `notifyListeners()`.
  - Los widgets que necesitan estos datos (como `GeneratorPage` y `FavoritesPage`) usan `context.watch<MyAppState>()` para "escuchar" esos cambios y reconstruirse automáticamente.

### 2. Estructura del Proyecto (Separación de Conceptos)

Para evitar tener todo el código en un solo archivo (`main.dart`), el proyecto se organizó en una estructura de carpetas modular:

- `/lib/pages`: Contiene los widgets que representan pantallas completas (ej. `generator_page.dart`, `favorites_page.dart`, `details_page.dart`).
- `/lib/providers`: Almacena las clases `ChangeNotifier` (ej. `my_app_state.dart`).
- `/lib/services`: Contiene la lógica para interactuar con servicios externos, como APIs (ej. `cat_api_service.dart`). Esto aísla la lógica de red del resto de la app.
- `/lib/models`: Define las clases y estructuras de datos (ej. `cat_details.dart`).

### 3. Operaciones Asíncronas (Consumo de API)

La aplicación consume `The Cat API` para obtener imágenes.

- **Por qué**: Es fundamental para cualquier app moderna aprender a manejar operaciones de red que toman tiempo.
- **Cómo**:
  - Se usa el paquete `http` con `async/await` en `cat_api_service.dart` para realizar las llamadas `http.get`.
  - `MyAppState` maneja una variable `isLoading`. Esta se pone en `true` antes de la llamada a la API y en `false` cuando la llamada termina (ya sea con éxito o con error).
  - La UI (como `GeneratorPage`) usa esta variable `isLoading` para mostrar un `CircularProgressIndicator` mientras los datos están en camino.

### 4. Modelo de Datos y "Datos Ficticios"

Para la página de detalles, queríamos mostrar información consistente para cada gato (nombre, dueño, edad) sin que la API nos la proporcionara.

- **Cómo**:
  - Se creó una clase `CatDetails` en `/lib/models` para dar forma a estos datos.
  - En `MyAppState`, se implementó un sistema de "caché" usando un `Map<String, CatDetails>`.
  - La primera vez que un usuario pide los detalles de una `imageUrl`, se generan datos ficticios aleatorios y se guardan en el `Map` usando la URL como llave.
  - Las siguientes veces que se pidan los detalles de esa _misma_ URL, se devolverán los datos ya guardados. Esto asegura que un gato específico siempre tenga el mismo nombre y dueño.

### 5. Navegación

Se utiliza el sistema de navegación imperativa estándar de Flutter.

- **Cómo**: Se usa `Navigator.push()` para mover al usuario a una nueva pantalla.
- **Paso de Datos**: Para abrir la página de detalles, se pasa la `imageUrl` necesaria a través del constructor de la nueva página:
  ```dart
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailsPage(imageUrl: url),
    ),
  );
  ```

### 6. Manejo de Errores en Imágenes

Para mejorar la experiencia del usuario, se agregó un manejo de errores al cargar imágenes.

- **Cómo**: Se utiliza el parámetro `errorBuilder` en el widget `Image.network` para mostrar un ícono de imagen rota si la carga falla.
  ```dart
  errorBuilder: (_, __, ___) => Center(
    child: Icon(Icons.broken_image, size: 50),
  ),
  ```

## Mejoras Futuras

Aunque la aplicación es funcional, hay muchas mejoras que se podrían implementar para hacerla más robusta y completa:

- **Persistencia de Datos**: Actualmente, los favoritos se pierden cada vez que se cierra la app. Se podría usar el paquete `shared_preferences` o una base de datos local como `sqflite` para guardar los favoritos permanentemente.
- **Eliminar Favoritos**: Implementar la funcionalidad para que el usuario pueda eliminar un elemento de la lista de favoritos, ya sea desde la misma lista o desde la página de detalles.
- **Mejor Manejo de Errores**: Mostrar mensajes de error más amigables al usuario (ej. un "Snackbar") cuando la llamada a la API falla, en lugar de solo mostrar un texto o un ícono de imagen rota.
- **Pruebas (Testing)**: Escribir pruebas unitarias (Unit Tests) para la lógica de `MyAppState` y la función `fetchCatImages`, y pruebas de widgets (Widget Tests) para las pantallas principales.

## Conclusión

Este proyecto sirve como una demostración práctica de los conceptos fundamentales de Flutter. Pasando del tutorial básico a una aplicación con estado, navegación y consumo de servicios externos, cubre el ciclo de vida de desarrollo esencial para construir aplicaciones móviles pequeñas y medianas.
