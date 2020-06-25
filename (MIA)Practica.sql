/*1.Generar el script que crea cada una de las tablas que conforman la base de datos propuesta por el Comité Olímpico. */

CREATE TABLE PROFESION (
	cod_prof SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE PAIS (
	cod_pais SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT uk_pais_nombre UNIQUE (nombre)
	);

CREATE TABLE PUESTO (
	cod_puesto SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT uk_puesto_nombre UNIQUE (nombre)
);

CREATE TABLE DEPARTAMENTO (
	cod_depto SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT uk_departamento_nombre UNIQUE (nombre)
);

CREATE TABLE MIEMBRO (
	cod_miembro SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	edad INTEGER NOT NULL,
	telefono INTEGER NULL,
	residencia VARCHAR(100) NULL,
	PAIS_cod_pais INTEGER REFERENCES PAIS(cod_pais) NOT NULL,
	PROFESION_cod_prof INTEGER REFERENCES PROFESION(cod_prof) NOT NULL
);

CREATE TABLE PUESTO_MIEMBRO(
	MIEMBRO_cod_miembro INTEGER NOT NULL,
	PUESTO_cod_puesto INTEGER NOT NULL,
	DEPARTAMENTO_cod_depto INTEGER NOT NULL,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NULL,
	CONSTRAINT pk_PUESTO_MIEMBRO PRIMARY KEY(MIEMBRO_cod_miembro,PUESTO_cod_puesto,DEPARTAMENTO_cod_depto),
	CONSTRAINT fk_PUESTO_MIEMBRO_miembro FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES MIEMBRO(cod_miembro),
	CONSTRAINT fk_PUESTO_MIEMBRO_puesto FOREIGN KEY (PUESTO_cod_puesto) REFERENCES PUESTO(cod_puesto),
	CONSTRAINT fk_PUESTO_MIEMBRO_departamento FOREIGN KEY (DEPARTAMENTO_cod_depto) REFERENCES DEPARTAMENTO(cod_depto)
);

CREATE TABLE TIPO_MEDALLA(
	cod_tipo INTEGER PRIMARY KEY NOT NULL,
	medalla VARCHAR(20) NOT NULL,
	CONSTRAINT uk_tipo_medalla_medalla UNIQUE (medalla)
);

CREATE TABLE MEDALLERO(
	PAIS_cod_pais INTEGER NOT NULL,
	cantidad_medallas INTEGER NOT NULL,
	TIPO_MEDALLA_cod_tipo INTEGER NOT NULL,
	CONSTRAINT pk_MEDALLERO PRIMARY KEY(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo),
	CONSTRAINT fk_MEDALLERO_pais FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS(cod_pais),
	CONSTRAINT fk_MEDALLERO_tipo_medalla FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE 
);

CREATE TABLE DISCIPLINA(
	cod_disciplina SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(150) NULL
);

CREATE TABLE ATLETA(
	cod_atleta SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	edad INTEGER NOT NULL,
	Participaciones VARCHAR(100),
	DISCIPLINA_cod_disciplina INTEGER NOT NULL,
	PAIS_cod_pais INTEGER REFERENCES PAIS(cod_pais) NOT NULL,
	CONSTRAINT fk_atleta_disciplina FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina)
);

CREATE TABLE CATEGORIA(
	cod_categoria SMALLSERIAL PRIMARY KEY NOT NULL,
	categoria VARCHAR(50) NOT NULL
);

CREATE TABLE TIPO_PARTICIPACION(
	cod_participacion SMALLSERIAL PRIMARY KEY NOT NULL,
	tipo_participacion VARCHAR(100) NOT NULL
);

CREATE TABLE EVENTO(
	cod_evento SMALLSERIAL PRIMARY KEY NOT NULL,
	fecha DATE NOT NULL,
	ubicacion VARCHAR(50) NOT NULL,
	hora timestamp NOT NULL,
	DISCIPLINA_cod_disciplina INTEGER NOT NULL,
	CONSTRAINT fk_EVENTO_discplina FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE,
	TIPO_PARTICIPACION_cod_participacion INTEGER REFERENCES TIPO_PARTICIPACION(cod_participacion) NOT NULL,
	CATEGORIA_cod_categoria INTEGER REFERENCES CATEGORIA(cod_categoria)NOT NULL
);

CREATE TABLE EVENTO_ATLETA(
	ATLETA_cod_atleta INTEGER NOT NULL,
	EVENTO_cod_evento INTEGER NOT NULL,
	CONSTRAINT pk_EVENTO_ATLETA PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
	CONSTRAINT fk_EVENTO_ATLETA_atleta FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta),
	CONSTRAINT fk_EVENTO_ATLETA_evento FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO(cod_evento)
);

CREATE TABLE TELEVISORA(
	cod_televisora SMALLSERIAL PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL
);

CREATE TABLE COSTO_EVENTO(
	EVENTO_cod_evento INTEGER NOT NULL,
	TELEVISORA_cod_televisora INTEGER NOT NULL,
	tarifa INTEGER NOT NULL,
	CONSTRAINT pk_COSTO_EVENTO PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
	CONSTRAINT fk_COSTO_EVENTO_evento FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO(cod_evento),
	CONSTRAINT fk_COSTO_EVENTO_televisora FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES TELEVISORA(cod_televisora)
);


/*2.----------------------*/
/* PROCEDEREMOS A ALTERAR LA TABLA, ELIMINANDO LAS COLUMNAS FECHA Y HORA*/
ALTER TABLE EVENTO DROP fecha;
ALTER TABLE EVENTO DROP hora;

/*CREAREMOS LA COLUMNA "fecha_hora" con el tipo de dato timestamp */ 
ALTER TABLE EVENTO ADD fecha_hora TIMESTAMP NOT NULL;

/*3.----------------------*/
/*Alteraremos la tabla evento otra vez, pero esta vez agregaremos el constraint CHECK el cual se asegura que todos los valores en la columna satisfagan las condiciones. */

ALTER TABLE EVENTO ADD CONSTRAINT ck_fecha_hora CHECK(fecha_hora BETWEEN '2020-07-24 09:00:00'::timestamp AND '2020-08-09 20:00:00'::timestamp);

/*4.-----------------------*/
/* Creamos la tabla SEDE, con sus respectivos atributos */

CREATE TABLE SEDE(
	codigo INTEGER PRIMARY KEY NOT NULL,
	sede VARCHAR(50) NOT NULL
);

ALTER TABLE EVENTO
	ALTER COLUMN ubicacion TYPE INTEGER USING ubicacion::INTEGER,
	ALTER COLUMN ubicacion SET not null;
ALTER TABLE EVENTO
	ADD CONSTRAINT fk_EVENTO_SEDE FOREIGN KEY (ubicacion) REFERENCES SEDE(codigo);

/*5.------------------------*/
/* alterar tabla MIEMBRO, y poner por DEFAULT el valor 0, al momento de ingresar a la base de datos */
ALTER TABLE MIEMBRO
	ALTER COLUMN telefono TYPE NUMERIC,
	ALTER COLUMN telefono SET DEFAULT 0;
/*6.----------------------*/
/* PROCEDEREMOS A INSERTAR LOS DATOS A LAS TABLAS REQUERIDAS SEGUN INFORMACIÒN PROPORCIONADA*/
/*Se utilizo el autoincrementable de postgres */

INSERT INTO PAIS(nombre) VALUES ('Guatemala');
INSERT INTO PAIS(nombre) VALUES ('Francia');
INSERT INTO PAIS(nombre) VALUES ('Argentina');
INSERT INTO PAIS(nombre) VALUES ('Alemania');
INSERT INTO PAIS(nombre) VALUES ('Italia');
INSERT INTO PAIS(nombre) VALUES ('Brasil');
INSERT INTO PAIS(nombre) VALUES ('Estados Unidos');

INSERT INTO PROFESION(nombre) VALUES ('Médico');
INSERT INTO PROFESION(nombre) VALUES ('Arquitecto');
INSERT INTO PROFESION(nombre) VALUES ('Ingeniero');
INSERT INTO PROFESION(nombre) VALUES ('Secretaria');
INSERT INTO PROFESION(nombre) VALUES ('Auditor');

INSERT INTO MIEMBRO(nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Scott','Mitchell',32,'1092 Highland Drive Manitowoc, WI 54220',7,3);
INSERT INTO MIEMBRO(nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
INSERT INTO MIEMBRO(nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Laura','Cunha Silva',55,'Rua Onze, 86 Uberaba-MG',6,5);
INSERT INTO MIEMBRO(nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2);
INSERT INTO MIEMBRO(nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
INSERT INTO MIEMBRO(nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof)
VALUES ('Jeuel','Villalpando',31,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);

INSERT INTO DISCIPLINA(nombre,descripcion) VALUES ('Atletismo','Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco');

INSERT INTO DISCIPLINA(nombre) VALUES ('Bádminton');
INSERT INTO DISCIPLINA(nombre) VALUES ('Ciclismo');
INSERT INTO DISCIPLINA(nombre,descripcion)
VALUES ('Judo','Es un arte marcial que se originó en Japón alrededor de 1880');
INSERT INTO DISCIPLINA(nombre) VALUES ('Lucha');
INSERT INTO DISCIPLINA(nombre) VALUES ('Tenis de Mesa');
INSERT INTO DISCIPLINA(nombre) VALUES ('Boxeo');
INSERT INTO DISCIPLINA(nombre,descripcion)
VALUES ('Natación','Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
INSERT INTO DISCIPLINA(nombre) VALUES ('Esgrima');
INSERT INTO DISCIPLINA(nombre) VALUES ('Vela');

INSERT INTO TIPO_MEDALLA(cod_tipo,medalla) VALUES (1,'Oro');
INSERT INTO TIPO_MEDALLA(cod_tipo,medalla) VALUES (2,'Plata');
INSERT INTO TIPO_MEDALLA(cod_tipo,medalla) VALUES (3,'Bronce');
INSERT INTO TIPO_MEDALLA(cod_tipo,medalla) VALUES (4,'Platino');

INSERT INTO CATEGORIA(categoria) VALUES ('Clasificatorio');
INSERT INTO CATEGORIA(categoria) VALUES ('Eliminatorio');
INSERT INTO CATEGORIA(categoria) VALUES ('Final');

INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Individual');
INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Parejas');
INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Equipos');


INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (5,1,3);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (2,1,5);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (6,3,4);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (4,4,3);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (7,3,10);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (3,2,8);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (1,1,2);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (1,4,5);
INSERT INTO MEDALLERO(PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES (5,2,7);

INSERT INTO SEDE(codigo,sede) VALUES (1,'Gimnasio Metropolitano de Tokio');
INSERT INTO SEDE(codigo,sede) VALUES (2,'Jardín del Palacio Imperial de Tokio');
INSERT INTO SEDE(codigo,sede) VALUES (3,'Gimnasio Nacional Yoyogi');
INSERT INTO SEDE(codigo,sede) VALUES (4,'Nippon Budokan');
INSERT INTO SEDE(codigo,sede) VALUES (5,'Estadio Olímpico');


INSERT INTO EVENTO(fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES ('2020-07-24 11:00:00', 3, 2, 2, 1);
INSERT INTO EVENTO(fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES ('2020-07-26 10:30:00', 1, 6, 1, 3);
INSERT INTO EVENTO(fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES ('2020-07-30 18:45:00', 5, 7, 1, 2);
INSERT INTO EVENTO(fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES ('2020-08-01 12:15:00', 2, 1, 1, 1);
INSERT INTO EVENTO(fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES ('2020-08-08 19:35:00', 4, 10, 3, 1);




/*7.----------------------*/
/* PROCEDEREMOS A EL ELIMINAR EL CONSTRAINT UNIQUE DE LAS TABLAS PAIS, TIPO_MEDALLA Y DEPARTAMENTO*/

ALTER TABLE PAIS DROP CONSTRAINT uk_pais_nombre;
ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT uk_tipo_medalla_medalla;
ALTER TABLE DEPARTAMENTO DROP CONSTRAINT uk_departamento_nombre;

/*8.----------------------*/
/* */
ALTER TABLE ATLETA DROP CONSTRAINT fk_atleta_disciplina;
ALTER TABLE ATLETA DROP COLUMN DISCIPLINA_cod_disciplina;
CREATE TABLE DISCIPLINA_ATLETA(
	cod_atleta INTEGER not null,
	cod_disciplina INTEGER not null,
	CONSTRAINT pk_disciplina_atleta PRIMARY KEY (cod_atleta, cod_disciplina),
	CONSTRAINT fk_disciplina_atleta_atleta FOREIGN KEY (cod_atleta) REFERENCES ATLETA(cod_atleta),
	CONSTRAINT fk_disciplina_atleta_disciplina FOREIGN KEY (cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina)
);

/*9.----------------------*/
/* */
ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa TYPE numeric(20, 2);

/*10.----------------------*/
/*ELIMINAR EL TIPO MEDALLA CON EL CODIGO 4*/
DELETE FROM TIPO_MEDALLA WHERE cod_tipo = 4;

/*11.----------------------*/
/*ELIMINAR LAS TABLAS TELEVISORA Y COSTO EVENTO */
DROP TABLE COSTO_EVENTO;
DROP TABLE TELEVISORA;

/*12.----------------------*/
/*ELIMINAR REGISTROS EN LA TABLA DISCIPLINA*/
DELETE FROM DISCIPLINA;

/*13.----------------------*/
/*ACTUALIZAR TELEFONOS DE MIEMBROS */
UPDATE MIEMBRO SET telefono = 55464601 WHERE nombre = 'Laura' AND apellido = 'Cunha Silva';
UPDATE MIEMBRO SET telefono = 91514243 WHERE nombre = 'Jeuel' AND apellido = 'Villalpando';
UPDATE MIEMBRO SET telefono = 920686670 WHERE nombre = 'Scott' AND apellido = 'Mitchell';

/*14.----------------------*/
/*AGREGAREMOS EL ATRIBUTO FOTOGRAFIA, UTILIZANDO EL TIPO DE DATO BYTEA, EL CUAL PERMITE ALMACENAR CADENAS BINARIAS*/
ALTER TABLE ATLETA ADD fotografia bytea null;

/*15.----------------------*/
ALTER TABLE ATLETA ADD CONSTRAINT ck_atleta_edad_maxima CHECK (edad < 25);



