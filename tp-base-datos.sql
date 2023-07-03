Resoluciones:

Trabajo Práctico Final Gestión de Base de Datos
-- 1 - Crear una función llamada "calcular_total_ventas" que tome como parámetro el mes y el año, y devuelva el total de ventas realizadas en ese mes.
DELIMITER //

CREATE FUNCTION calcular_total_ventas(mes INT, anio INT) RETURNS DECIMAL(10, 2)
BEGIN
  DECLARE total DECIMAL(10, 2);
  
  SELECT SUM(monto) INTO total
  FROM ventas
  WHERE MONTH(fecha) = mes AND YEAR(fecha) = anio;
  
  RETURN total;
END //

DELIMITER ;

-- 2 - Crear una función llamada "obtener_nombre_empleado" que tome como parámetro el ID de un empleado y devuelva su nombre completo.
DELIMITER //

CREATE FUNCTION obtener_nombre_empleado(emp_id INT) RETURNS VARCHAR(100)
BEGIN
	DECLARE nombre_completo VARCHAR(100);
    
    SELECT CONCAT(nombre, ' ', apellido)
    INTO nombre_completo	
    FROM empleados
    WHERE id = emp_id;
    
    
    RETURN nombre_completo;
END //

DELIMITER;


-- 3 - Crear un procedimiento almacenado llamado "obtener_promedio" que tome como parámetro de entrada el nombre de un curso y calcule el promedio de las calificaciones de todos los alumnos inscritos en ese curso.
DELIMITER //

CREATE PROCEDURE obtener_promedio(IN nombre_curso VARCHAR(50))
BEGIN
  DECLARE promedio DECIMAL(4, 2);
  
  -- Calcular el promedio de las calificaciones de los alumnos inscritos en el curso
  SELECT AVG(calificacion)
  INTO promedio
  FROM Calificaciones c
  JOIN Cursos co ON c.curso_id = co.id
  WHERE co.nombre = nombre_curso;
  
  -- Mostrar el resultado
  SELECT promedio AS promedio_calificaciones;
  
END //

DELIMITER ;

-- 4 - Actualizar el procedimiento almacenado "actualizar_stock" para que tome como parámetros de entrada el código del producto y la cantidad a 
-- agregar al stock actual. El procedimiento debe actualizar el stock sumando la cantidad especificada al stock actual del producto correspondiente.
DELIMITER //

CREATE PROCEDURE actualizar_stock(IN codigo_producto VARCHAR(50), IN cantidad INT)
BEGIN
  DECLARE stock_actual INT;
  
  -- Obtener el stock actual del producto
  SELECT stock INTO stock_actual
  FROM Productos
  WHERE codigo = codigo_producto;
  
  -- Actualizar el stock sumando la cantidad especificada
  UPDATE Productos
  SET stock = stock_actual + cantidad
  WHERE codigo = codigo_producto;
  
  -- Mostrar mensaje de éxito
  SELECT CONCAT('Stock actualizado. Nuevo stock del producto ', codigo_producto, ': ', stock_actual + cantidad) AS mensaje;
  
END //

DELIMITER ;

-- 5 - A partir de la siguiente especificación un Analista deberá recolectar datos para poder diseñar una Base de Datos.

-- a) Determinar las entidades relevantes al Sistema.
Importador
Factura
Pieza
Operario
Hoja de Confección
Modelo de Televisor
Mapa de Armado
	
-- b) Determinar los atributos de cada entidad.
Importador:
ID (identificador único)
Nombre
Dirección
Teléfono

Pieza:
ID (identificador único)
Nombre
Descripción
Precio

Factura:
Fecha
ImportadorID (calve foránea al importador)
PiezaID (clave foránea a la pieza)

Operario:
ID (identificador único)
Nombre
Especialidad

Hoja de Confección:
ID (identificador único)
Fecha
Cantidad fabricada
Operario (clave foránea al operario)
Pieza (clave foránea a la pieza)

Modelo de Televisor:
ID (identificador único)
Nombre
Descripción

Mapa de Armado:
ID (identificador único)
Modelo de televisor (clave foránea al modelo de televisor)
Pieza (clave foránea a la pieza)
Ubicación
Orden



c) Confeccionar el Diagrama de Entidad Relación (DER), junto al Diccionario de Datos

d) Realizar el Diagrama de Tablas e implementar en código SQL la Base de Datos.
-- Crear la base de datos
CREATE DATABASE armado_televisores;
USE armado_televisores;

-- Crear la tabla Importador
CREATE TABLE Importador (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(50),
  Direccion VARCHAR(100),
  Telefono VARCHAR(15)
);

-- Crear la tabla Factura
CREATE TABLE Factura (
  ImportadorID INT,
  PiezaID INT,
    Fecha DATE,
  FOREIGN KEY (ImportadorID) REFERENCES Importador(ID),
  FOREIGN KEY (PiezaID) REFERENCES Pieza(ID)
);

-- Crear la tabla Pieza
CREATE TABLE Pieza (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(50),
  Descripcion VARCHAR(100),
  Precio DECIMAL(10, 2)
);

-- Crear la tabla Operario
CREATE TABLE Operario (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(50),
  Especialidad VARCHAR(50)
);

-- Crear la tabla HojaDeConfeccion
CREATE TABLE HojaDeConfeccion (
  ID INT PRIMARY KEY,
  Fecha DATE,
  CantidadFabricada INT,
  OperarioID INT,
  PiezaID INT,
  FOREIGN KEY (OperarioID) REFERENCES Operario(ID),
  FOREIGN KEY (PiezaID) REFERENCES Pieza(ID)
);

-- Crear la tabla ModeloDeTelevisor
CREATE TABLE ModeloDeTelevisor (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(50),
  Descripcion VARCHAR(100)
);

-- Crear la tabla MapaDeArmado
CREATE TABLE MapaDeArmado (
  ID INT PRIMARY KEY,
  ModeloDeTelevisorID INT,
  PiezaID INT,
  Ubicacion VARCHAR(50),
  Orden INT,
  FOREIGN KEY (ModeloDeTelevisorID) REFERENCES ModeloDeTelevisor(ID),
  FOREIGN KEY (PiezaID) REFERENCES Pieza(ID)
);


e) Crear al menos 2 consultas relacionadas para poder probar la Base de Datos.


Esta empresa se encuentra ubicada en Tierra del Fuego y se dedica al armado de televisores.

Las componentes de los televisores pueden ser comprados a un importador, en tal caso la compra viene acompañada de la factura, otras piezas son fabricadas en la empresa, para lo cual esas piezas tienen asignado un operario que se dedica exclusivamente a un tipo de pieza, aunque una pieza puede ser fabricada por más de un operario, el operario completa una hoja de confección con las la fecha y la cantidad fabricada.

Los diferentes modelos de televisores están compuestos por 300 o más piezas, aunque una pieza puede estar incorporada en más de un televisor, existe un mapa de armado para cada modelo de televisor donde se indica la ubicación y el orden de las piezas que lo componen.
