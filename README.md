# Sistema de Gestión - Refugio de Animales 🐾
**Proyecto Integrador - Base de Datos III**

Este proyecto consiste en una base de datos relacional diseñada para optimizar la administración de un refugio de animales, permitiendo un seguimiento integral desde el ingreso del animal hasta su adopción.

### 🚀 Características principales:
* **Gestión de Salud:** Seguimiento de vacunas y estado de castración.
* **Control de Adopciones:** Vinculación de adoptantes con animales mediante un proceso automatizado.
* **Sistema de Donaciones:** Registro de ingresos monetarios y de insumos (alimento, medicina).
* **Atención Veterinaria:** Historial detallado de procedimientos y observaciones por animal.

### 🛠️ Objetos de Base de Datos Incluidos:
Para cumplir con los requerimientos de la materia, el script incluye:
* **Vistas:** `Vista_Pendientes_Salud` para identificar rápidamente animales que requieren atención.
* **Procedimientos Almacenados:** `RegistrarAdopcion` que automatiza el cambio de estado del animal al ser adoptado.
* **Consultas Avanzadas:** Reporte de balance mensual de donaciones agrupado por tipo.

### 📁 Instrucciones:
1. Ejecutar el script `Proyecto_Integrador_Refugio.sql` en su gestor de base de datos.
2. El script creará automáticamente la base de datos, las tablas y cargará datos de prueba iniciales.
