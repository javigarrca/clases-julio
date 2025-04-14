/* CREAR TABLAS EN FORMATO SQL */
CREATE TABLE nombreTabla (
    nombreCampo1 INT PRIMARY KEY AUTO_INCREMENT,
    nombreCampo2 VARCHAR(50)
);
/*
    TIPOS DE DATOS:
        - INT: Numeros enteros
        - VARCHAR: Cadenas de texto. Entre paréntesis, ponemos la longitud que queremos que tenga nuestra cadena
        - DOUBLE: Números decimales (almacena números decimales más grandes)
        - DECIMAL: Números decimales (numero decimal más exacto)

    A la hora de crear una tabla, siempre debemos tener una clave que identifique la columna de forma unica.
    Normalmente utilizaremos un "Id" que sera un entero auto incremental. Es decir, cada vez que insertemos
    un registro en nuestra tabla, este número, irá incrementando. Lo podemos poner nosotros a la hora de hacer
    el insert, o podemos no ponerlo y se autorellenará
*/

-- CREEMOS UNA BD
CREATE DATABASE TEST1;
USE TEST1;

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    apellido1 VARCHAR(120) NOT NULL,
    apellido2 VARCHAR(120),
    ciudad VARCHAR(50),
    edad INT NOT NULL
);

-- INSERTAMOS DATOS EN LA TABLA CLIENTES
INSERT INTO Clientes (nombre, apellido1, ciudad, edad) VALUES 
                        ('Juan', 'Perez', 'Madrid', 15),
                        ('Pepe', 'Fdez', 'Barcelona', 25),
                        ('María', 'Hernandez', 'Valencia', 28),
                        ('Pedro', 'Muñoz', 'Bilbao', 27),
                        ('Luis', 'Martinez', 'Sevilla', 18);

-- CREAMOS TABLA PEDIDOS
CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) -- REFERENCIA al campo id_cliente de la TABLA CLIENTES
    ON DELETE CASCADE -- AL BORRAR UN REGISTRO DE CLIENTE, LO BORRA EN CASCADA DE LA TABLA PEDIDOS
    ON UPDATE CASCADE -- AL ACTUALIZAR UN REGISTRO DE CLIENTE, LO ACTUALIZA EN CASCADA DE LA TABLA PEDIDOS
);
-- INSERTAMOS DATOS EN PEDIDOS
INSERT INTO Pedidos (id_cliente, fecha_pedido, total) VALUES 
(1, '2023-01-15', 150.00),
(2, '2023-02-20', 200.50),
(3, '2023-03-10', 300.75),
(4, '2023-04-05', 120.00),
(5, '2023-05-12', 250.25);

/* 
    CONSULTAS SQL
    ORDER BY: Se utiliza para ordenar los resultados de una consulta, dependiendo de las columnas que deseemos.
*/

-- EJ. Ordenar clientes por edad de forma ascendente
SELECT nombre, edad 
    FROM Clientes 
ORDER BY edad ASC;

-- También se pueden ordenar por más campos. ej. Ordenar clientes por nombre Ascendente y apellido1 descendente
SELECT * 
    FROM Clientes 
ORDER BY nombre ASC, apellido1 DESC;

/*
    GROUP BY: Se utiliza para agrupar filas que tienen valores "iguales" en columnas especificas.
    Casi siempre se utiliza con funciones de agregación. COUNT, SUM, AVG, MAX, MIN, etc...
*/

-- EJ.- Contar el número de clientes por ciudad.
SELECT ciudad, COUNT(*) AS 'Clientes_Ciudad' 
    FROM Clientes
GROUP BY ciudad;

-- Ej2. Calcular edad promedio de clientes por ciudad
SELECT ciudad, AVG(edad)
    FROM Clientes
GROUP BY ciudad;

-- EJ2. Edad máxima de un cliente
SELECT MAX(Edad), nombre, apellido1
    FROM Clientes
GROUP BY nombre, apellido1;

/*
    FUNCIONES DE AGRUPADO:
        COUNT() - cuenta el numero de filas que cumplen una condición
        SUM()   - suma los valores de una columna NUMERICA
        MAX()/MIN()  - Devuelve el valor máximo/mínimo de una columna
        AVG()   - calcula el valor promedio de una columna NUMERICA
*/

/*
    LIKE: Patrones de búsqueda.
    Se utiliza con la cláusula WHERE para buscar filas que coincidan con un patrón específico.
    Se usa el símbolo del porcentaje.
*/

-- EJ. Busca lientes cuyo nombre contenga la letra "A"
SELECT nombre, apellido1
    FROM Clientes
WHERE 
    nombre LIKE '%A%';

-- Ej2.- Clientes cuyo apellido empiece por la letra "M"
SELECT nombre, apellido1
    FROM Clientes
WHERE
    apellido1 LIKE 'M%';

/*
    DISCTINCT: Extrae valores únicos
    -> Se utiliza para eliminar valores duplicados de los resultados de una consulta
*/    
-- EJ1. Obtener clientes unicos por ciudad
SELECT DISTINCT ciudad FROM Clientes;


/*
    UNIONES ENTRE TABLAS
    INNER JOIN: 
        > Se utiliza para combinar filas de dos o más tablas, basándose en una relación entre ellas.
        > Devuelve solo las filas que tienen coincidencias entre ambas tablas.
*/

-- EJ1.- Obtener el nmbre completo del cliente y la fecha del pedido para todos los pedidos realizados en abril.
SELECT c.nombre, c.apellido1, p.fecha_pedido 
    FROM Clientes c
INNER JOIN Pedidos p ON c.id_pedido = p.id_cliente
WHERE
    p.fecha_pedido BETWEEN '2023-04-01' AND '2023-04-30';
-- Añadimos la función between, que sirve para comparar dos fechas.
-- La sintáxis es sencilla. Utilizamos un "alias" para la tabla Clientes (lo llamamos c) y otro para la tabla Pedidos (lo llamamos p)
-- Ponemos la palabra inner join y comparamos el campo que relaciona ambas tablas. En este caso, el campo que relaciona la tabla clientes con pedidos, es el id_cliente

-- Ej2.- Obtener el numero total de pedidos y el total gastado por cada cliente
SELECT c.nombre, c.apellido1, count(p.id_pedido) AS "total_pedidos", sum(p.total) as "totalGastado" 
    FROM Clientes c
INNER JOIN Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido1
ORDER BY totalGastado DESC;
-- En este caso, buscamos total de pedidos (usamos la función count() y ponemos el id pedido para contar el total de pedidos
-- Para sacar el total, hacemos un SUM() del total del pedido (p.total) ya que está en la tabla pedidos

-- EJ3.- Obtener las ciudades que tienen más de un pedido registrado
SELECT ciudad, count(p.id_pedido) AS "total_Pedidos"
    FROM Clientes c
INNER JOIN Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.ciudad
HAVING COUNT(p.id_pedido) > 1
ORDER BY total_Pedidos DESC;

-- INTRODUCIMOS LA FUNCION HAVING, QUE SIRVE PARA FILTRAR LOS RESULTADOS QUE SEAN EN ESTE CASO MAYORES A 1



