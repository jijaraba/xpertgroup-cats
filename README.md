# XpertGroup Cat App

Una aplicación Flutter que permite explorar razas de gatos usando la API pública de TheCatAPI. La aplicación incluye un splash screen con animación Lottie, navegación entre pantallas y funcionalidades de votación.

## Características

### 🎬 Splash Screen
- Animación Lottie con un gato trabajando azul
- Transición automática a la pantalla principal después de 3 segundos

### 🐱 Pantalla de Razas
- Lista desplegable con todas las razas de gatos disponibles
- Carrusel automático con fotos de la raza seleccionada
- Información detallada: nombre, origen, expectativa de vida, inteligencia
- Descripción completa de la raza
- Botón para abrir Wikipedia en WebView interno

### 🗳️ Pantalla de Votación
- Carrusel de razas para votación
- Botones de "Me gusta" y "No me gusta"
- Navegación solo hacia la izquierda (deslizar o botones)
- Animaciones suaves entre transiciones
- Feedback visual de las votaciones

### 🧭 Navegación
- Menú tipo footer con dos pestañas
- Navegación fluida entre pantallas
- Indicador visual de pantalla activa

## Arquitectura

El proyecto sigue los principios de **Clean Architecture** y utiliza **Riverpod** para el manejo de estado:

```
lib/
├── core/
│   ├── constants/          # Constantes de la API
│   └── router/            # Configuración de navegación
├── data/
│   ├── datasources/       # Fuentes de datos remotos
│   ├── models/           # Modelos con serialización JSON
│   └── repositories/     # Implementación de repositorios
├── domain/
│   ├── entities/         # Entidades de negocio
│   ├── repositories/     # Contratos de repositorios
│   └── usecases/        # Casos de uso
└── presentation/
    ├── pages/           # Pantallas de la aplicación
    ├── providers/       # Providers de Riverpod
    └── widgets/         # Widgets reutilizables
```

## Dependencias Principales

- **flutter_riverpod**: Manejo de estado
- **lottie**: Animaciones
- **http**: Peticiones HTTP
- **go_router**: Navegación
- **webview_flutter**: WebView para Wikipedia
- **carousel_slider**: Carruseles de imágenes
- **cached_network_image**: Caché de imágenes
- **json_annotation** & **json_serializable**: Serialización JSON

## API

La aplicación utiliza [TheCatAPI](https://thecatapi.com/) con los siguientes endpoints:

- `GET /breeds` - Obtener lista de razas
- `GET /images/search` - Obtener imágenes por raza
- `POST /votes` - Votar por una imagen

**API Key**: ``

## Instalación y Ejecución

1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   flutter pub get
   ```
3. Generar archivos de serialización:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## Funcionalidades Implementadas

✅ **Splash Screen con Lottie**
- Animación del gato trabajando azul
- Transición automática

✅ **Navegación con Footer**
- Dos pantallas principales
- Navegación tipo bottom navigation bar

✅ **Pantalla de Razas**
- Dropdown con razas de gatos
- Carrusel automático de imágenes
- Información detallada (nombre, origen, vida, inteligencia)
- Descripción completa
- WebView para Wikipedia

✅ **Pantalla de Votación**
- Carrusel tipo Tinder
- Botones de like/dislike
- Solo navegación hacia la izquierda
- Animaciones fluidas

✅ **Clean Architecture**
- Separación en capas
- Inversión de dependencias
- Casos de uso bien definidos

✅ **Riverpod State Management**
- Providers reactivos
- Manejo de estado inmutable
- Separación de lógica y UI

## Créditos

Desarrollado para XpertGroup como prueba técnica.
Iconos de votación inspirados en Material Design.
Animación del gato de Lottie Files.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
