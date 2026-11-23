USE Pubs;

CREATE TABLE Pub(
		codigoNombre NVARCHAR(100) NOT NULL,
		licenciaFiscal NVARCHAR(100) NOT NULL,
		docimicilio NVARCHAR(100),
		fecha_apertura DATE NOT NULL,
		horario NVARCHAR(100) NOT NULL,
		codigoLocalidad INT NOT NULL,
		CONSTRAINT pk_pub_nombre PRIMARY KEY(codigoNombre),
		CONSTRAINT ch_pub_horario CHECK (horario IN( 'HORARIO1', 'HORARIO2', 'HORARIO3')),

);

CREATE TABLE Titular (
		DNI_titular NVARCHAR(100) NOT NULL,
		nombre NVARCHAR(100) NOT NULL,
		domcilio_titular NVARCHAR(100),
		codigoPub NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_titular_DNI PRIMARY KEY(DNI_titular),
		CONSTRAINT fk_titular_pub FOREIGN KEY (codigoPub) REFERENCES Pub(codigoNombre),


);

CREATE TABLE Empleado(
		DNI_empleado NVARCHAR(100) NOT NULL,
		nombre_empleado NVARCHAR(100) NOT NULL,
		domicilio_empleado NVARCHAR(100),
		CONSTRAINT pk_empleado_DNI PRIMARY KEY(DNI_empleado)

);

CREATE TABLE Articulo (
		codigo_articulo NVARCHAR(100) NOT NULL,
		nombre_articulo NVARCHAR(100) NOT NULL,
		cantidad INT NOT NULL,
		precio DECIMAL(5,2) NOT NULL,
		codigoPub NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_articulo_codigo PRIMARY KEY(codigo_articulo),
		CONSTRAINT fk_articulo_pub FOREIGN KEY(codigoPub) REFERENCES Pub(codigoNombre),
		CONSTRAINT ch_articulo_precio CHECK(precio>0)


);

CREATE TABLE Localidad (
		codigo_localidad INT NOT NULL,
		nombre_localidad NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_localidad_codigo PRIMARY KEY(codigo_localidad)
	
);

CREATE TABLE Pub_empleado (
		codigo_Pub NVARCHAR(100) NOT NULL,
		DNI_empleado NVARCHAR(100) NOT NULL,
		funcion NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_pubEm_codigo PRIMARY KEY (codigo_Pub, DNI_empleado, funcion),
		CONSTRAINT fk_pubEm_pub FOREIGN KEY(codigo_Pub) REFERENCES Pub(codigoNombre),
		CONSTRAINT fk_pubEm_empleado FOREIGN KEY(DNI_empleado) REFERENCES Empleado(DNI_empleado),
		CONSTRAINT ch_pubEm_funcion CHECK (funcion IN('CAMARERO', 'SEGURIDAD', 'LIMPIEZA'))

);

ALTER TABLE Pub
ADD CONSTRAINT fk_pub_localidad 
FOREIGN KEY (codigoLocalidad) 
REFERENCES Localidad (codigo_localidad);

CREATE LOGIN administrador_login
WITH PASSWORD = 'Miaumiau123!';
CREATE USER  administradorPubs
FOR LOGIN administrador_login;

CREATE USER  lectorDatos WITHOUT LOGIN;

GRANT SELECT
ON Localidad, Articulo, Pub
TO lectorDatos;

GRANT SELECT
ON Localidad
TO lectorDatos;

GRANT SELECT
ON Articulo
TO lectorDatos;

GRANT SELECT
ON Pub
TO lectorDatos;

CREATE LOGIN gestor_login
WITH PASSWORD = 'Miaumiau321!';

CREATE USER gestorArticulos
FOR LOGIN gestor_login;

GRANT SELECT, INSERT, UPDATE
ON Articulo
TO gestorArticulos;

CREATE LOGIN empleados_login
WITH PASSWORD = 'Nyanya456!';

CREATE USER gestorEmpleados
FOR LOGIN empleados_login;

GRANT INSERT, UPDATE, DELETE
ON Empleado
TO gestorEmpleados

GRANT INSERT, UPDATE, DELETE
ON Pub_empleado
TO gestorEmpleados

DENY SELECT
ON Articulo
TO gestorEmpleados

GRANT INSERT, UPDATE, DELETE
ON Pub
TO administradorPubs
WITH GRANT OPTION;

REVOKE UPDATE
ON Articulo
TO gestorArticulos;

DENY ALL
ON Titular
TO lectorDatos;

CREATE LOGIN nuevo_login
WITH PASSWORD = 'Gatitomiau123!';

ALTER USER gestorEmpleados WITH LOGIN = nuevo_login;
ALTER USER gestorEmpleados WITH NAME = encargadoPersonal;

GRANT ALL
ON Titular
TO administradorPubs;

DROP USER lectorDatos;