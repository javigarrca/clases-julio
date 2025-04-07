/*



TABLES
    - ACTORES
    - PELICULAS
    - ESTUDIOS_CINE
    - ACTUACIONES
    
FIELDS:
    -ACTORES
        * ACTOR_ID INT AUTO_INCREMENT(PK)
        * NOMBRE VARCHAR(20)
        * APELLIDO1 VARCHAR(20)
        * APELLIDO2 VARCHAR(20)
        * GENERO VARCHAR(20)
        * F_NACIMIENTO DATE
        
    - ESTUDIOS_CINE
        * ESTUDIO_ID INT AUTO_INCREMENT (PK)
        * NOMBRE VARCHAR(20)
        * PAIS VARCHAR(20)
        
        
    - PELICULAS
        * PELICULA_ID INT AUTO_INCREMENT (PK)
        * TITULO VARCHAR(20)
        * PRESUPUESTO DECIMAL
        * GENERO VARCHAR(20)
        * ESTUDIO_ID INT (FK -> ESTUDIO_ID (REF T_ESTUDIO))
        
    - ACTUACIONES
        * ACTUACION_ID INT AUTO_INCREMENT (PK)
        * SALARIO DECIMAL
        * PROTAGONISTA BOOLEAN
        * PELICULA_ID INT (FK -> PELICULA_ID (REF T_PELICULA) )
        * ACTOR_ID INT (FK -> ACTOR_ID (REF T_ACTOR) )        
*/
CREATE DATABASE DB_JULIO;

USE DB_JULIO;

CREATE TABLE ACTORES (
    ACTOR_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(20),
    APELLIDO1 VARCHAR(20),
    APELLIDO2 VARCHAR(20),
    GENERO VARCHAR(20),
    F_NACIMIENTO DATE
);

CREATE TABLE ESTUDIOS_CINE (
     ESTUDIO_ID INT AUTO_INCREMENT primary key,
     NOMBRE VARCHAR(20),
     PAIS VARCHAR(20)
);


CREATE TABLE PELICULAS (
    PELICULA_ID INT AUTO_INCREMENT PRIMARY KEY,
    TITULO VARCHAR(20),
    PRESUPUESTO DECIMAL,
    GENERO VARCHAR(20),
    ESTUDIO_ID INT, -- Asegúrate de que esta columna exista y tenga el tipo de dato adecuado
    CONSTRAINT FK_PELICULA_ESTUDIO FOREIGN KEY (ESTUDIO_ID)
    REFERENCES ESTUDIOS_CINE(ESTUDIO_ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE ACTUACIONES (
    ACTUACION_ID INT AUTO_INCREMENT PRIMARY KEY,
    SALARIO DECIMAL,
    PROTAGONISTA BOOLEAN,
    PELICULA_ID INT,
    CONSTRAINT FK_ACTUACION_PELICULA FOREIGN KEY (PELICULA_ID)
    REFERENCES PELICULAS(PELICULA_ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    ACTOR_ID INT,
    CONSTRAINT FK_ACTUACION_ACTOR FOREIGN KEY (ACTOR_ID)
    REFERENCES ACTORES(ACTOR_ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


/*
    FABRICAR LOS INSERT EN LAS TABLAS
*/

INSERT INTO ESTUDIOS_CINE (nombre, pais) VALUES
    ('Warner Bros. Entertainment', 'Estados Unidos'),
    ('Universal Pictures', 'Estados Unidos'),
    ('Paramount Pictures', 'Estados Unidos');


INSERT INTO ACTORES (NOMBRE, APELLIDO1, APELLIDO2, GENERO,  F_NACIMIENTO) VALUES 
    ('Leonardo', 'DiCaprio', NULL, 'masculino', '1974-11-11'),
    ('Scarlett', 'Johansson', NULL, 'femenino', '1984-11-22'),
    ('Tom', 'Hanks', NULL, 'masculino', '1956-07-09'),
    ('Meryl', 'Streep', NULL, 'femenino', '1949-06-22'),
    ('Ken', 'Watanabe', NULL, 'masculino', '1959-10-21');


INSERT INTO PELICULAS (TITULO, PRESUPUESTO, GENERO, ESTUDIO_ID) VALUES
    ('El Origen', 160000000.00, 'thriller', 1),
    ('Lost in Translation', 4000000.00, 'drama', 2),
    ('Forrest Gump', 55000000.00, 'drama', 2),
    ('El viaje de Chihiro', 19000000.00, 'musical', 3),
    ('Pulp Fiction', 8000000.00, 'comedia', 2),
    ('La La Land', 30000000.00, 'musical', 1),
    ('El lobo de Wall Street', 100000000.00, 'comedia', 1),
    ('Her', 23000000.00, 'drama', 1),
    ('El último samurái', 140000000.00, 'drama', 1),
    ('Match Point', 15000000.00, 'thriller', 2);
    

INSERT INTO ACTUACIONES (ACTOR_ID, PELICULA_ID, SALARIO, PROTAGONISTA) VALUES 
        (1, 1, 20000000.00, TRUE),
        (2, 2, 5000000.00, TRUE),
        (3, 3, 15000000.00, TRUE),
        (4, 3, 3000000.00, FALSE),
        (5, 9, 10000000.00, TRUE),
        (1, 7, 25000000.00, TRUE),
        (2, 8, 7000000.00, TRUE),
        (3, 3, 2000000.00, FALSE),
        (4, 2, 1000000.00, FALSE),
        (5, 1, 4000000.00, FALSE),
        (1, 5, 12000000.00, FALSE),
        (2, 10, 6000000.00, TRUE),
        (3, 6, 9000000.00, FALSE),
        (4, 7, 4500000.00, FALSE);
       

/*
   Muestra en un registro los nombres de los actores que participaron en la película con id = 3 (1.5 puntos)

*/

SELECT ACTORES.nombre
    FROM ACTORES
        INNER JOIN actuaciones ON ACTORES.ACTOR_ID = ACTUACIONES.ACTOR_ID
        INNER JOIN peliculas ON actuaciones.PELICULA_ID = PELICULAS.PELICULA_ID
    WHERE
        peliculas.pelicula_id = 3;
 
/*    
    Necesitas conectar la tabla ACTORES con la tabla PELICULAS 
    a través de ACTUACIONES (porque ACTUACIONES es la que nos dice quién actuó en qué).

    El INNER JOIN significa esto: 
    "Muéstrame solo la información de los actores y las películas que tengan una conexión directa en ACTUACIONES". 
    Si un actor no aparece en ACTUACIONES (no ha trabajado en ninguna película registrada) 
    o si una película no tiene ninguna actuación registrada, no los mostrará.
*/

/*
    Muestra la información el actor que haya ganado el mayor salario de todos, no hace falta mostrar el total del salario. (1.5 puntos)
*/

SELECT ACTORES.nombre, ACTUACIONES.SALARIO
    FROM ACTORES
        INNER JOIN ACTUACIONES ON ACTORES.ACTOR_ID = ACTUACIONES.ACTOR_ID
    WHERE ACTUACIONES.SALARIO = (SELECT MAX(SALARIO) FROM ACTUACIONES);
-- FUNCION MAX -> RECOGE EL VALOR MÁXIMO DE UN REGISTRO
      
/*
    Muestra las peliculas que tengan menor presupuesto
*/
  
SELECT TITULO, PRESUPUESTO
    FROM PELICULAS
    WHERE
        PRESUPUESTO = (SELECT MIN(PRESUPUESTO) FROM PELICULAS);
-- FUNCION MIN -> RECOGE EL VALOR MINIMO DE UN REGISTRO        

/* no hacemos esta version:
    SELECT TITULO, MIN(PRESUPUESTO) FROM PELICULAS;
    porque si que escoge el minimo presupuesto, pero el campo del titulo no tiene por qué coincidir con el presupuesto.
    
    la versión "buena", va a buscar el presupuesto de "esa pelicula" en concreto.
*/

/*
    Muestra el presupuesto medio de cada género de películas
*/
SELECT GENERO, AVG(PRESUPUESTO) AS "PRESUPUESTO MEDIO"
    FROM PELICULAS
    GROUP BY GENERO;

-- FUNCION AVG (CALCULAR LA MEDIA ARITMETICA) 

/*
     Muestra la información de los estudios que tengan películas de género musical
*/
SELECT estudios.nombre, estudios.pais
    FROM ESTUDIOS_CINE estudios
        INNER JOIN PELICULAS ON PELICULAS.ESTUDIO_ID = estudios.ESTUDIO_ID
    WHERE
        PELICULAS.GENERO = 'musical';
/* se podria añadir un distinct al principio, ya que si un estudio ha producido múltiples películas 
    musicales, sin DISTINCT su nombre y país aparecerán repetidos en el resultado. 
    
    Esto añade filas innecesarias y dificulta la lectura e interpretación de la información. 
    El objetivo generalmente es obtener una lista única de los estudios que cumplen la condición
*/

/*
    Muestra la información de la película en la que hayan participado más actores
*/


/*películas que tienen datos de actuación*/
SELECT p.titulo, p.presupuesto, p.genero
FROM peliculas p
INNER JOIN actuaciones a ON p.pelicula_id = a.pelicula_id
GROUP BY p.pelicula_id, p.titulo, p.presupuesto, p.genero
HAVING COUNT(a.actor_id) = (
/*obtener el número máximo de actores que han participado en cualquier película*/
    SELECT MAX(num_actores)
    FROM (
        SELECT pelicula_id, COUNT(actor_Id) AS num_actores
        FROM actuaciones
        GROUP BY pelicula_id
    ) AS pelicula_conteo_actores
);

/* Elimina el actor con id 3 */
DELETE FROM ACTUACIONES WHERE ACTOR_ID = 3;
DELETE FROM ACTORES WHERE ACTOR_ID = 3;
ROLLBACK;


/* Actualiza el actor con id 1 poniendo en apellido 2 "Lobo" y haciendo que haya nacido en el 1989 en una consulta */
SELECT * FROM ACTORES WHERE actor_ID = 1;
UPDATE ACTORES SET APELLIDO2 = 'Lobo' where ACTOR_ID = 1 AND F_NACIMIENTO LIKE '1989%';