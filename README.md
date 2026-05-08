# Proyecto Integrador: Gestión de Refugio de Animales 🐾
## Materia: Base de Datos III

Este repositorio contiene la entrega final del Proyecto Integrador. El objetivo es gestionar de manera eficiente la información de un refugio de animales, incluyendo voluntarios, historias clínicas y turnos veterinarios.

## 📄 Contenido del Proyecto
El proyecto se compone de los siguientes archivos principales:

1.  **Proyecto_Integrador_Refugio.sql**: Script completo que incluye:
    *   **DDL**: Creación de tablas (`voluntarios`, `animales`, `historias_clinicas`, `turnos_veterinarios`).
    *   **Carga Masiva**: Generación automática de miles de registros para pruebas de rendimiento usando `generate_series`.
    *   **Optimización**: Implementación de índices (`HASH` y `B-TREE`) para acelerar las consultas.
    *   **Estructuras Avanzadas**: Uso de tipos de datos `JSONB` para flexibilidad en datos médicos y `TSRANGE` para periodos de atención.

2.  **informe_bd3_Pablo--.final.pdf**: Documento con las capturas de pantalla que demuestran la ejecución exitosa del script y los resultados de las consultas solicitadas.

## 🚀 Tecnologías Utilizadas
*   **Motor de Base de Datos**: PostgreSQL.
*   **Herramientas**: Git / GitHub para control de versiones.

## 🛠️ Instrucciones de Ejecución
1. Clonar el repositorio.
2. Ejecutar el script `.sql` en un entorno de PostgreSQL.
3. Verificar la integridad de los datos y los índices creados.
