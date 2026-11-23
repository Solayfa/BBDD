CREATE DATABASE GestionEntradas;

USE  GestionEntradas;

CREATE TABLE Espectaculo(
		codEspectaculo INT NOT NULL,
		nomEspectaculo NVARCHAR(100) NOT NULL,
		tipoEspectaculo NVARCHAR(100) NOT NULL,
		fechainicioEspectaculo DATE NOT NULL,
		fechafinalEspectaculo DATE NOT NULL,
		interpreteEspectaculo NVARCHAR(100),
		codRecinto INT NOT NULL,
		CONSTRAINT pk_espectaculo PRIMARY KEY(codEspectaculo),
		CONSTRAINT fk_espectaculo_recinto FOREIGN KEY(codRecinto) REFERENCES Recinto(codRecinto)


);

CREATE TABLE Precio_representacion(
		codEspectaculo INT NOT NULL,
		codRepresentacion INT NOT NULL,
		pvpEspectaculo MONEY NOT NULL,
		CONSTRAINT pk_precio PRIMARY KEY(codEspectaculo, codRepresentacion),
		CONSTRAINT fk_precio_espectaculo FOREIGN KEY(codEspectaculo) REFERENCES Espectaculo(codEspectaculo)

);

CREATE TABLE Recinto (
		codRecinto INT NOT NULL,
		nomRecinto NVARCHAR(100) NOT NULL,
		dirRecinto NVARCHAR(100) NOT NULL,
		ciuRecinto NVARCHAR(100) NOT NULL,
		telRecinto INT NOT NULL,
		horRecinto NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_recinto PRIMARY KEY(codRecinto),
		CONSTRAINT ch_recinto_horario CHECK (horRecinto IN ( 'HORARIO1', 'HORARIO2'))

);

CREATE TABLE Asiento(
		numAsiento INT NOT NULL,
		filAsiento INT NOT NULL,
		codRecinto INT NOT NULL,
		CONSTRAINT pk_asiento PRIMARY KEY(numAsiento, filAsiento),
		CONSTRAINT fk_asiento_recinto FOREIGN KEY(codRecinto) REFERENCES Recinto(codRecinto)
		
);

CREATE TABLE Representacion(
		codRepresentacion INT NOT NULL,
		codEspectaculo INT NOT NULL,
		fechaRepresentacion DATE NOT NULL,
		horaRepresentacion TIME NOT NULL,
		CONSTRAINT pk_representacion PRIMARY KEY(codRepresentacion),
		CONSTRAINT fk_representacion_espectaculo FOREIGN KEY(codEspectaculo) REFERENCES Espectaculo(codEspectaculo)

);

CREATE TABLE Entrada(
		codEntrada INT NOT NULL,
		codRepresentacion INT NOT NULL,
		codRecinto INT NOT NULL,
		numAsiento INT NOT NULL,
		filAsiento INT NOT NULL,
		dniEspectador NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_entrada PRIMARY KEY(codEntrada),
		CONSTRAINT fk_entrada_representacion FOREIGN KEY(codRepresentacion) REFERENCES Representacion(codRepresentacion),
		CONSTRAINT fk_entrada_recinto FOREIGN KEY(codRecinto) REFERENCES Recinto(codRecinto),
		CONSTRAINT fk_entrada_asiento FOREIGN KEY(numAsiento, filAsiento) REFERENCES Asiento(numAsiento, filAsiento),
		CONSTRAINT fk_entrada_espectador FOREIGN KEY(dniEspectador) REFERENCES Espectador(dniEspectador)
);

CREATE TABLE Espectador(
		dniEspectador NVARCHAR(100) NOT NULL,
		nomEspectador NVARCHAR(100) NOT NULL,
		dirEspectador NVARCHAR(100) NOT NULL,
		telEspectador INT NOT NULL,
		ciuEspectador NVARCHAR(100) NOT NULL,
		numerotarjeta INT NOT NULL,
		CONSTRAINT pk_espectador PRIMARY KEY(dniEspectador)
);

CREATE LOGIN admin_login
WITH PASSWORD = 'HelloKitty04!';

CREATE USER adminEntradas 
FOR LOGIN admin_login;

CREATE USER consultaPublica WITHOUT LOGIN;

GRANT SELECT
ON Recinto
TO consultaPublica;

GRANT SELECT
ON Espectaculo
TO consultaPublica;

GRANT SELECT
ON Representacion
TO consultaPublica;

CREATE LOGIN gestorEs_login
WITH PASSWORD = 'Cinnamoroll1234!';

CREATE USER gestorEspectaculos
FOR LOGIN gestorEs_login;

GRANT SELECT, INSERT, UPDATE
ON Espectaculo
TO gestorEspectaculos;

REVOKE DELETE
ON Espectaculo
TO gestorEspectaculos;

CREATE LOGIN gestorRe_login
WITH PASSWORD = 'Mymelody167!';

CREATE USER gestorRecintos
FOR LOGIN gestorRe_login;

GRANT  INSERT, UPDATE, DELETE
ON Recinto
TO gestorRecintos;

REVOKE SELECT
ON Espectador
TO gestorRecintos;

CREATE LOGIN usuario_login
WITH PASSWORD = 'Guadetama234!';

CREATE USER usuarioEspectador
FOR LOGIN usuario_login;

GRANT SELECT
ON Espectaculo
TO usuarioEspectador;

GRANT SELECT
ON Representacion
TO usuarioEspectador;

GRANT SELECT
ON Precio_representacion
TO usuarioEspectador;

GRANT INSERT, UPDATE, DELETE
ON Entrada
TO adminEntradas
WITH GRANT OPTION;

REVOKE UPDATE
ON Espectaculo
TO gestorEspectaculos;

DENY ALL
ON Espectador
TO consultaPublica;

CREATE LOGIN nuevoLogin_recinto
WITH PASSWORD = 'Mysweetpiano890!';

ALTER USER gestorRecintos WITH LOGIN = nuevoLogin_recinto;
ALTER USER gestorRecintos WITH NAME = coordinadorRecintos;

GRANT ALL
ON Representacion
TO adminEntradas;

DROP USER consultaPublica;