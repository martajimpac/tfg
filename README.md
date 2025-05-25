# Aplicación de Inspección de Maquinaria - TFG

## 📌 Descripción del Proyecto
Este Trabajo de Fin de Grado (TFG) consiste en el desarrollo de una aplicación móvil multiplataforma diseñada para facilitar la realización de evaluaciones de maquinaria, optimizando el trabajo de los inspectores que actualmente realizan este proceso de forma manual.

La aplicación ha sido desarrollada para la Delegación de Defensa en la Comunidad de Castilla y León, con el objetivo de digitalizar y agilizar los procesos de inspección de maquinaria utilizados por dicha entidad.

## 🔹 Características principales
- ✅ **Autenticación de usuarios**: Registro e inicio de sesión seguros.  
- ✅ **Gestión de evaluaciones**: Listado de inspecciones previas y creación de nuevas.  
- ✅ **Checklist de inspección**: Formulario estructurado para evaluar el estado de la maquinaria.  
- ✅ **Generación de informes en PDF**: Exportación automática de los resultados de la evaluación.  
- ✅ **Código QR único**: Vinculado a cada evaluación para acceso rápido mediante escaneo.  
- ✅ **Multiplataforma**: Funciona en Android y Windows.

## 🛠️ Tecnologías Utilizadas
- **Framework**: Flutter (Dart)
- **Backend**: Supabase (Base de datos y autenticación)
- **Metodología**: Scrum (Gestión ágil del proyecto)

## 📥 Instalación y Ejecución

### 🔸 Requisitos previos
- **Flutter SDK**: Versión 3.22.0 (Dart 3.3.0) *(recomendada para evitar errores en testing)*
- **Supabase**: Configuración de variables de entorno (`.env`).

### 🔸 Pasos para ejecutar el proyecto

1. **Clonar el repositorio**:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd tfg
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configurar variables de entorno**:
   - Crea un archivo `.env` en la raíz del proyecto con tus claves de Supabase.

4. **Ejecutar la app**:

   #### 📱 Para Android
   ```bash
   flutter build apk --release
   ```
   - **Salida:** `build/app/outputs/flutter-apk/app-release.apk`

   #### 🖥️ Para Windows
   ```bash
   flutter build windows
   ```
   - **Salida:** `build/windows/runner/Release/`


## 📸 Capturas de Pantalla

Ejemplo de Interfaz  
<!-- Aquí iría la imagen, por ejemplo: -->
<!-- ![Ejemplo de Interfaz](url_a_la_imagen.png) -->

## 📜 Licencia

Este proyecto está bajo licencia MIT.

## ✉️ Contacto

- 📧 Correo: tu_email@example.com
- 🔗 LinkedIn: tu_perfil_linkedin

---

🚀 ¡Gracias por tu interés en este proyecto! 🚀
