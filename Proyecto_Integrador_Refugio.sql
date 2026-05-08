-- PROYECTO INTEGRADOR: SISTEMA DE GESTIÓN DE REFUGIO DE ANIMALES
-- Materia: Base de Datos III

-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS RefugioAnimales;
USE RefugioAnimales;

-- 2. CREACIÓN DE TABLAS (DDL)
CREATE TABLE ANIMAL (
    ID_Animal INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    Especie ENUM('Perro', 'Gato', 'Otro') NOT NULL,
    Raza VARCHAR(50) DEFAULT 'Mestizo',
    Edad_estimada INT CHECK (Edad_estimada >= 0),
    Fecha_ingreso DATE NOT NULL,
    Estado ENUM('Disponible', 'Adoptado', 'En tratamiento', 'Reservado') DEFAULT 'Disponible',
    Vacunas BOOLEAN DEFAULT FALSE,
    Castracion BOOLEAN DEFAULT FALSE
);

CREATE TABLE ADOPTANTE (
    ID_Adoptante INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    DNI VARCHAR(15) UNIQUE NOT NULL,
    Direccion VARCHAR(150),
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
);

CREATE TABLE ADOPCION (
    ID_Adopcion INT PRIMARY KEY AUTO_INCREMENT,
    ID_Animal INT NOT NULL,
    ID_Adoptante INT NOT NULL,
    Fecha_adopcion DATE NOT NULL,
    Seguimiento TEXT,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID_Animal),
    FOREIGN KEY (ID_Adoptante) REFERENCES ADOPTANTE(ID_Adoptante)
);

CREATE TABLE DONANTE (
    ID_Donante INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100),
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
);

CREATE TABLE DONACION (
    ID_Donacion INT PRIMARY KEY AUTO_INCREMENT,
    Monto DECIMAL(10,2) NOT NULL CHECK (Monto > 0),
    Fecha DATE NOT NULL,
    Tipo ENUM('Dinero', 'Alimento', 'Insumos Médicos') NOT NULL,
    ID_Donante INT NULL,
    FOREIGN KEY (ID_Donante) REFERENCES DONANTE(ID_Donante)
);

CREATE TABLE VETERINARIO (
    ID_Veterinario INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(50),
    Telefono VARCHAR(20)
);

CREATE TABLE ATENCION (
    ID_Atencion INT PRIMARY KEY AUTO_INCREMENT,
    ID_Animal INT NOT NULL,
    ID_Veterinario INT NOT NULL,
    Fecha DATE NOT NULL,
    Procedimiento VARCHAR(200),
    Observaciones TEXT,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID_Animal),
    FOREIGN KEY (ID_Veterinario) REFERENCES VETERINARIO(ID_Veterinario)
);

-- 3. INSERCIÓN DE DATOS DE EJEMPLO (DML)
INSERT INTO ANIMAL (Nombre, Especie, Raza, Edad_estimada, Fecha_ingreso, Estado, Vacunas, Castracion) VALUES
('Kira', 'Gato', 'Mestizo', 1, '2026-04-10', 'Disponible', TRUE, FALSE),
('Toby', 'Perro', 'Labrador', 3, '2026-01-15', 'Adoptado', TRUE, TRUE),
('Luna', 'Perro', 'Galgo', 5, '2025-11-20', 'En tratamiento', TRUE, TRUE),
('Simba', 'Gato', 'Persa', 2, '2026-03-05', 'Disponible', FALSE, FALSE),
('Rocco', 'Perro', 'Pitbull', 4, '2026-02-14', 'Disponible', TRUE, TRUE);

INSERT INTO ADOPTANTE (Nombre, DNI, Direccion, Telefono, Correo) VALUES
('Juan Perez', '35123456', 'Calle Falsa 123', '351456789', 'juan.perez@email.com'),
('Maria Lopez', '40987654', 'Av. Siempre Viva 742', '354898765', 'maria.l@email.com');

INSERT INTO DONANTE (Nombre, Telefono, Correo) VALUES
('Fundación Mascotas', '0800-123-456', 'contacto@fundacion.org'),
('Anonimo', NULL, NULL);

INSERT INTO DONACION (Monto, Fecha, Tipo, ID_Donante) VALUES
(5000.00, '2026-05-01', 'Dinero', 1),
(1500.50, '2026-05-05', 'Alimento', 2);

INSERT INTO VETERINARIO (Nombre, Especialidad, Telefono) VALUES
('Dr. Garcia', 'Cirugía', '351111222'),
('Dra. Martinez', 'Clínica General', '351333444');

-- 4. VISTAS, PROCEDIMIENTOS Y CONSULTAS (OBJETOS AVANZADOS)

-- Vista de animales que necesitan atención veterinaria prioritaria
CREATE VIEW Vista_Pendientes_Salud AS
SELECT ID_Animal, Nombre, Especie, Vacunas, Castracion
FROM ANIMAL
WHERE (Vacunas = FALSE OR Castracion = FALSE) AND Estado != 'Adoptado';

-- Procedimiento almacenado para registrar adopción de forma segura
DELIMITER //
CREATE PROCEDURE RegistrarAdopcion(
    IN p_animal_id INT,
    IN p_adoptante_id INT,
    IN p_fecha DATE
)
BEGIN
    -- Registrar la adopción en la tabla puente
    INSERT INTO ADOPCION (ID_Animal, ID_Adoptante, Fecha_adopcion) 
    VALUES (p_animal_id, p_adoptante_id, p_fecha);
    
    -- Cambiar el estado del animal automáticamente
    UPDATE ANIMAL SET Estado = 'Adoptado' WHERE ID_Animal = p_animal_id;
END //
DELIMITER ;

-- Consulta compleja: Resumen de donaciones del mes actual
SELECT Tipo, SUM(Monto) as Total_Acumulado, COUNT(*) as Cantidad_Donaciones
FROM DONACION
WHERE MONTH(Fecha) = MONTH(CURRENT_DATE()) AND YEAR(Fecha) = YEAR(CURRENT_DATE())
GROUP BY Tipo;
