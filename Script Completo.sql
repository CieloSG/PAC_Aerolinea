/************************************

INTEGRANTES:
* Cunyas Melchor, Luis Miguel
* Huaman Fernandez, Alina Margareth
* Sotomayor Gamarra, Cielo Reyna

LINK VIDEO:

*************************************/

USE MASTER
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AEROSKYBD')
BEGIN
	CREATE DATABASE AEROSKYBD
END

GO
----
USE AEROSKYBD

-- ELIMINAR FK -----------------------------------------------------------------------------------------
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = @SQL +
'ALTER TABLE ' +
QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' +
QUOTENAME(OBJECT_NAME(parent_object_id)) +
' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

--PRINT @SQL;
EXEC sp_executesql @SQL;

GO
USE AEROSKYBD
GO
-- INICIO -------------------------------------------------------------------------------------------------------
/*********************************************************************************************
-- Tabla: dbo.Paises
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los países registrados en el sistema AeroSky.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'Paises'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.Paises;
END
GO

CREATE TABLE dbo.Paises (
    PaisID INT IDENTITY(1,1) NOT NULL,
    CodigoPais CHAR(2) NOT NULL,
    NombrePais VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Paises PRIMARY KEY (PaisID),
    CONSTRAINT UQ_Paises_CodigoPais UNIQUE (CodigoPais),
    CONSTRAINT UQ_Paises_NombrePais UNIQUE (NombrePais),

	CONSTRAINT CK_Paises_Codigo
	CHECK (
		LEN(CodigoPais) = 2
		AND CodigoPais NOT LIKE '%[^A-Z]%'
)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los países registrados en el sistema AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Paises';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del país.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Paises',
    @level2type = N'COLUMN', @level2name = 'PaisID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de dos caracteres que identifica al país.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Paises',
    @level2type = N'COLUMN', @level2name = 'CodigoPais';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del país.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Paises',
    @level2type = N'COLUMN', @level2name = 'NombrePais';
GO


/*********************************************************************************************
-- Tabla: dbo.Generos
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los géneros disponibles para el registro de personas.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'Generos'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.Generos;
END
GO

CREATE TABLE dbo.Generos (
    GeneroID INT IDENTITY(1,1) NOT NULL,
    Descripcion VARCHAR(30) NOT NULL,

    CONSTRAINT PK_Generos PRIMARY KEY (GeneroID),
    CONSTRAINT UQ_Generos_Descripcion UNIQUE (Descripcion)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los géneros disponibles para el registro de personas.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Generos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del género.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Generos',
    @level2type = N'COLUMN', @level2name = 'GeneroID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del género.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Generos',
    @level2type = N'COLUMN', @level2name = 'Descripcion';
GO


/*********************************************************************************************
-- Tabla: dbo.TiposDocumento
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los tipos de documento aceptados por AeroSky.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'TiposDocumento'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.TiposDocumento;
END
GO

CREATE TABLE dbo.TiposDocumento (
    TipoDocumentoID INT IDENTITY(1,1) NOT NULL,
    NombreTipo VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TiposDocumento PRIMARY KEY (TipoDocumentoID),
    CONSTRAINT UQ_TiposDocumento_NombreTipo UNIQUE (NombreTipo)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los tipos de documento aceptados por AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposDocumento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de documento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposDocumento',
    @level2type = N'COLUMN', @level2name = 'TipoDocumentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tipo de documento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposDocumento',
    @level2type = N'COLUMN', @level2name = 'NombreTipo';
GO


/*********************************************************************************************
-- Tabla: dbo.EstadosCliente
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los estados posibles de los clientes registrados.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'EstadosCliente'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.EstadosCliente;
END
GO

CREATE TABLE dbo.EstadosCliente (
    EstadoClienteID INT IDENTITY(1,1) NOT NULL,
    Descripcion VARCHAR(30) NOT NULL,

    CONSTRAINT PK_EstadosCliente PRIMARY KEY (EstadoClienteID),
    CONSTRAINT UQ_EstadosCliente_Descripcion UNIQUE (Descripcion)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los estados posibles de los clientes registrados.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosCliente';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del estado del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosCliente',
    @level2type = N'COLUMN', @level2name = 'EstadoClienteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del estado del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosCliente',
    @level2type = N'COLUMN', @level2name = 'Descripcion';
GO


/*********************************************************************************************
-- Tabla: dbo.Cargos
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los cargos laborales disponibles para los empleados.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'Cargos'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.Cargos;
END
GO

CREATE TABLE dbo.Cargos (
    CargoID INT IDENTITY(1,1) NOT NULL,
    NombreCargo VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Cargos PRIMARY KEY (CargoID),
    CONSTRAINT UQ_Cargos_NombreCargo UNIQUE (NombreCargo)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los cargos laborales disponibles para los empleados.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cargos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del cargo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cargos',
    @level2type = N'COLUMN', @level2name = 'CargoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del cargo laboral.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cargos',
    @level2type = N'COLUMN', @level2name = 'NombreCargo';
GO


/*********************************************************************************************
-- Tabla: dbo.MetodosPago
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los métodos de pago aceptados por AeroSky.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'MetodosPago'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.MetodosPago;
END
GO

CREATE TABLE dbo.MetodosPago (
    MetodoPagoID INT IDENTITY(1,1) NOT NULL,
    NombreMetodo VARCHAR(50) NOT NULL,

    CONSTRAINT PK_MetodosPago PRIMARY KEY (MetodoPagoID),
    CONSTRAINT UQ_MetodosPago_NombreMetodo UNIQUE (NombreMetodo)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los métodos de pago aceptados por AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'MetodosPago';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del método de pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'MetodosPago',
    @level2type = N'COLUMN', @level2name = 'MetodoPagoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del método de pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'MetodosPago',
    @level2type = N'COLUMN', @level2name = 'NombreMetodo';
GO


/*********************************************************************************************
-- Tabla: dbo.Monedas
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena las monedas utilizadas para expresar precios y pagos.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'Monedas'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.Monedas;
END
GO

CREATE TABLE dbo.Monedas (
    MonedaID INT IDENTITY(1,1) NOT NULL,
    CodigoMoneda CHAR(3) NOT NULL,
    NombreMoneda VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Monedas PRIMARY KEY (MonedaID),
    CONSTRAINT UQ_Monedas_CodigoMoneda UNIQUE (CodigoMoneda),
    CONSTRAINT UQ_Monedas_NombreMoneda UNIQUE (NombreMoneda),

	CONSTRAINT CK_Monedas_Codigo
	CHECK (
		LEN(CodigoMoneda) = 3
		AND CodigoMoneda NOT LIKE '%[^A-Z]%'
)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena las monedas utilizadas para expresar precios y pagos.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Monedas';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la moneda.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Monedas',
    @level2type = N'COLUMN', @level2name = 'MonedaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código de tres caracteres que identifica la moneda.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Monedas',
    @level2type = N'COLUMN', @level2name = 'CodigoMoneda';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre de la moneda.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Monedas',
    @level2type = N'COLUMN', @level2name = 'NombreMoneda';
GO


/*********************************************************************************************
-- Tabla: dbo.EstadosVuelo
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los estados posibles de los vuelos.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'EstadosVuelo'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.EstadosVuelo;
END
GO

CREATE TABLE dbo.EstadosVuelo (
    EstadoVueloID INT IDENTITY(1,1) NOT NULL,
    Descripcion VARCHAR(30) NOT NULL,

    CONSTRAINT PK_EstadosVuelo PRIMARY KEY (EstadoVueloID),
    CONSTRAINT UQ_EstadosVuelo_Descripcion UNIQUE (Descripcion)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los estados posibles de los vuelos.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosVuelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del estado del vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosVuelo',
    @level2type = N'COLUMN', @level2name = 'EstadoVueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del estado del vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosVuelo',
    @level2type = N'COLUMN', @level2name = 'Descripcion';
GO


/*********************************************************************************************
-- Tabla: dbo.EstadosTiquete
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los estados posibles de los tiquetes.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'EstadosTiquete'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.EstadosTiquete;
END
GO

CREATE TABLE dbo.EstadosTiquete (
    EstadoTiqueteID INT IDENTITY(1,1) NOT NULL,
    Descripcion VARCHAR(30) NOT NULL,

    CONSTRAINT PK_EstadosTiquete PRIMARY KEY (EstadoTiqueteID),
    CONSTRAINT UQ_EstadosTiquete_Descripcion UNIQUE (Descripcion)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los estados posibles de los tiquetes.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosTiquete';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del estado del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosTiquete',
    @level2type = N'COLUMN', @level2name = 'EstadoTiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Descripción del estado del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EstadosTiquete',
    @level2type = N'COLUMN', @level2name = 'Descripcion';
GO


/*********************************************************************************************
-- Tabla: dbo.TiposEquipaje
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los tipos de equipaje que pueden registrarse en un tiquete.
-- Control de Cambios:
*********************************************************************************************/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'TiposEquipaje'
           AND SCHEMA_NAME(schema_id) = 'dbo')
BEGIN
    DROP TABLE dbo.TiposEquipaje;
END
GO

CREATE TABLE dbo.TiposEquipaje (
    TipoEquipajeID INT IDENTITY(1,1) NOT NULL,
    NombreTipo VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TiposEquipaje PRIMARY KEY (TipoEquipajeID),
    CONSTRAINT UQ_TiposEquipaje_NombreTipo UNIQUE (NombreTipo)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los tipos de equipaje que pueden registrarse en un tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposEquipaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único del tipo de equipaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposEquipaje',
    @level2type = N'COLUMN', @level2name = 'TipoEquipajeID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del tipo de equipaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiposEquipaje',
	@level2type = N'COLUMN', @level2name = 'NombreTipo';

GO



/*==============================================================
  TABLAS OPERATIVAS DEL SISTEMA AEROSKY
  Fecha de creación: 27/10/2026
  Autor: CIELO SOTOMAYOR
==============================================================*/


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Localizaciones.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los aeropuertos y localizaciones disponibles.
*********************************************************************************************/
IF OBJECT_ID('dbo.Localizaciones', 'U') IS NOT NULL
    DROP TABLE dbo.Localizaciones;
GO

CREATE TABLE dbo.Localizaciones (
    LocalizacionID INT IDENTITY(1,1) NOT NULL,
    PaisID INT NOT NULL,
    CodigoAeropuerto CHAR(3) NOT NULL,
    NombreAeropuerto VARCHAR(150) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Localizaciones PRIMARY KEY (LocalizacionID),
    CONSTRAINT UQ_Localizaciones_Codigo UNIQUE (CodigoAeropuerto),
    CONSTRAINT FK_Localizaciones_Paises FOREIGN KEY (PaisID)
        REFERENCES dbo.Paises(PaisID),
	CONSTRAINT CK_Localizaciones_CodigoAeropuerto
	CHECK (
		LEN(CodigoAeropuerto) = 3
		AND CodigoAeropuerto NOT LIKE '%[^A-Z]%'
)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los aeropuertos y localizaciones disponibles.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Identificador único de la localización.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones',
    @level2type = N'COLUMN', @level2name = 'LocalizacionID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'País al que pertenece el aeropuerto.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones',
    @level2type = N'COLUMN', @level2name = 'PaisID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Código internacional de tres letras del aeropuerto.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones',
    @level2type = N'COLUMN', @level2name = 'CodigoAeropuerto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Nombre del aeropuerto.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones',
    @level2type = N'COLUMN', @level2name = 'NombreAeropuerto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Ciudad donde se encuentra el aeropuerto.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Localizaciones',
    @level2type = N'COLUMN', @level2name = 'Ciudad';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Clientes.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los datos de los pasajeros registrados.
*********************************************************************************************/
IF OBJECT_ID('dbo.Clientes', 'U') IS NOT NULL
    DROP TABLE dbo.Clientes;
GO

CREATE TABLE dbo.Clientes (
    ClienteID INT IDENTITY(1,1) NOT NULL,
    TipoDocumentoID INT NOT NULL,
    EstadoClienteID INT NOT NULL,
    GeneroID INT NULL,
    PaisID INT NOT NULL,
    NumeroDocumento VARCHAR(30) NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NULL,
    Correo VARCHAR(150) NOT NULL,
    Telefono VARCHAR(25) NULL,
    FechaRegistro DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Clientes PRIMARY KEY (ClienteID),
    CONSTRAINT UQ_Clientes_Documento UNIQUE (TipoDocumentoID, NumeroDocumento),
    CONSTRAINT UQ_Clientes_Correo UNIQUE (Correo),
    CONSTRAINT FK_Clientes_TiposDocumento FOREIGN KEY (TipoDocumentoID)
        REFERENCES dbo.TiposDocumento(TipoDocumentoID),
    CONSTRAINT FK_Clientes_EstadosCliente FOREIGN KEY (EstadoClienteID)
        REFERENCES dbo.EstadosCliente(EstadoClienteID),
    CONSTRAINT FK_Clientes_Generos FOREIGN KEY (GeneroID)
        REFERENCES dbo.Generos(GeneroID),
    CONSTRAINT FK_Clientes_Paises FOREIGN KEY (PaisID)
        REFERENCES dbo.Paises(PaisID),


	CONSTRAINT CK_Clientes_Nombres
	CHECK (LEN(LTRIM(RTRIM(Nombres))) >= 2),

	CONSTRAINT CK_Clientes_Apellidos
	CHECK (LEN(LTRIM(RTRIM(Apellidos))) >= 2),

	CONSTRAINT CK_Clientes_Correo
	CHECK (Correo LIKE '%_@_%._%'),

	CONSTRAINT CK_Clientes_FechaNacimiento
	CHECK (FechaNacimiento <= CAST(GETDATE() AS DATE)),

	CONSTRAINT CK_Clientes_Telefono
	CHECK (
		Telefono IS NULL
		OR Telefono NOT LIKE '%[^0-9]%')
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los datos de los pasajeros registrados en AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'ClienteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tipo de documento de identidad del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'TipoDocumentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Estado actual del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'EstadoClienteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Género declarado por el cliente, si corresponde.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'GeneroID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'País asociado al cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'PaisID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Número del documento de identidad.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'NumeroDocumento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Nombres del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'Nombres';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Apellidos del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'Apellidos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha de nacimiento del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'FechaNacimiento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Correo electrónico del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'Correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Teléfono de contacto del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'Telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha y hora de registro del cliente.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Clientes',
    @level2type = N'COLUMN', @level2name = 'FechaRegistro';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Empleados.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena la información del personal de AeroSky.
*********************************************************************************************/
IF OBJECT_ID('dbo.Empleados', 'U') IS NOT NULL
    DROP TABLE dbo.Empleados;
GO

CREATE TABLE dbo.Empleados (
    EmpleadoID INT IDENTITY(1,1) NOT NULL,
    TipoDocumentoID INT NOT NULL,
    CargoID INT NOT NULL,
    PaisID INT NOT NULL,
    NumeroDocumento VARCHAR(30) NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NOT NULL,
    Telefono VARCHAR(25) NULL,
    FechaContratacion DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Empleados PRIMARY KEY (EmpleadoID),
    CONSTRAINT UQ_Empleados_Documento UNIQUE (TipoDocumentoID, NumeroDocumento),
    CONSTRAINT UQ_Empleados_Correo UNIQUE (Correo),
    CONSTRAINT FK_Empleados_TiposDocumento FOREIGN KEY (TipoDocumentoID)
        REFERENCES dbo.TiposDocumento(TipoDocumentoID),
    CONSTRAINT FK_Empleados_Cargos FOREIGN KEY (CargoID)
        REFERENCES dbo.Cargos(CargoID),
    CONSTRAINT FK_Empleados_Paises FOREIGN KEY (PaisID)
        REFERENCES dbo.Paises(PaisID),

	CONSTRAINT CK_Empleados_Correo
	CHECK (Correo LIKE '%_@_%._%'),

	CONSTRAINT CK_Empleados_FechaContratacion
	CHECK (FechaContratacion <= CAST(GETDATE() AS DATE)),

	CONSTRAINT CK_Empleados_Nombres
	CHECK (LEN(LTRIM(RTRIM(Nombres))) >= 2),

	CONSTRAINT CK_Empleados_Apellidos
	CHECK (LEN(LTRIM(RTRIM(Apellidos))) >= 2)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena la información del personal de AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'EmpleadoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tipo de documento del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'TipoDocumentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Cargo que desempeña el empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'CargoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'País asociado al empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'PaisID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Número del documento de identidad.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'NumeroDocumento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Nombres del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'Nombres';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Apellidos del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'Apellidos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Correo electrónico institucional o de contacto.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'Correo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Teléfono de contacto del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'Telefono';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha de contratación del empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'FechaContratacion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Indica si el empleado se encuentra activo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Empleados',
    @level2type = N'COLUMN', @level2name = 'Activo';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Rutas.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Define los trayectos disponibles entre aeropuertos.
*********************************************************************************************/
IF OBJECT_ID('dbo.Rutas', 'U') IS NOT NULL
    DROP TABLE dbo.Rutas;
GO

CREATE TABLE dbo.Rutas (
    RutaID INT IDENTITY(1,1) NOT NULL,
    LocalizacionOrigenID INT NOT NULL,
    LocalizacionDestinoID INT NOT NULL,
    CodigoRuta VARCHAR(20) NOT NULL,
    Activa BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Rutas PRIMARY KEY (RutaID),
    CONSTRAINT UQ_Rutas_Codigo UNIQUE (CodigoRuta),
    CONSTRAINT CK_Rutas_OrigenDestino CHECK
        (LocalizacionOrigenID <> LocalizacionDestinoID),
    CONSTRAINT FK_Rutas_Origen FOREIGN KEY (LocalizacionOrigenID)
        REFERENCES dbo.Localizaciones(LocalizacionID),
    CONSTRAINT FK_Rutas_Destino FOREIGN KEY (LocalizacionDestinoID)
        REFERENCES dbo.Localizaciones(LocalizacionID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Define los trayectos disponibles entre aeropuertos.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único de la ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas',
    @level2type = N'COLUMN', @level2name = 'RutaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Aeropuerto desde el que inicia la ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas',
    @level2type = N'COLUMN', @level2name = 'LocalizacionOrigenID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Aeropuerto al que llega la ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas',
    @level2type = N'COLUMN', @level2name = 'LocalizacionDestinoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Código único de identificación de la ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas',
    @level2type = N'COLUMN', @level2name = 'CodigoRuta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Indica si la ruta está disponible para operar.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Rutas',
    @level2type = N'COLUMN', @level2name = 'Activa';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.HorariosRuta.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los días y horarios planificados para cada ruta.
*********************************************************************************************/
IF OBJECT_ID('dbo.HorariosRuta', 'U') IS NOT NULL
    DROP TABLE dbo.HorariosRuta;
GO

CREATE TABLE dbo.HorariosRuta (
    HorarioRutaID INT IDENTITY(1,1) NOT NULL,
    RutaID INT NOT NULL,
    DiaSemana TINYINT NOT NULL,
    HoraSalida TIME NOT NULL,
    DuracionMinutos INT NOT NULL,
    CONSTRAINT PK_HorariosRuta PRIMARY KEY (HorarioRutaID),
    CONSTRAINT UQ_HorariosRuta UNIQUE (RutaID, DiaSemana, HoraSalida),
    CONSTRAINT CK_HorariosRuta_Dia CHECK (DiaSemana BETWEEN 1 AND 7),
    CONSTRAINT CK_HorariosRuta_Duracion CHECK (DuracionMinutos > 0),
    CONSTRAINT FK_HorariosRuta_Rutas FOREIGN KEY (RutaID)
        REFERENCES dbo.Rutas(RutaID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los días y horarios planificados para cada ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del horario de ruta.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta',
    @level2type = N'COLUMN', @level2name = 'HorarioRutaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Ruta a la que corresponde el horario.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta',
    @level2type = N'COLUMN', @level2name = 'RutaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Día de la semana: 1 a 7.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta',
    @level2type = N'COLUMN', @level2name = 'DiaSemana';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Hora planificada de salida.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta',
    @level2type = N'COLUMN', @level2name = 'HoraSalida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Duración planificada del trayecto en minutos.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'HorariosRuta',
    @level2type = N'COLUMN', @level2name = 'DuracionMinutos';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Aviones.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Almacena los aviones disponibles en la flota.
*********************************************************************************************/
IF OBJECT_ID('dbo.Aviones', 'U') IS NOT NULL
    DROP TABLE dbo.Aviones;
GO

CREATE TABLE dbo.Aviones (
    AvionID INT IDENTITY(1,1) NOT NULL,
    Fabricante VARCHAR(80) NOT NULL,
    Modelo VARCHAR(80) NOT NULL,
    Matricula VARCHAR(20) NOT NULL,
    Capacidad INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Aviones PRIMARY KEY (AvionID),
    CONSTRAINT UQ_Aviones_Matricula UNIQUE (Matricula),
    CONSTRAINT CK_Aviones_Capacidad CHECK (Capacidad > 0)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Almacena los aviones disponibles en la flota de AeroSky.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'AvionID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fabricante del avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'Fabricante';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Modelo del avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'Modelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Matrícula única del avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'Matricula';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Capacidad máxima de pasajeros del avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'Capacidad';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Indica si el avión está disponible para operar.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Aviones',
    @level2type = N'COLUMN', @level2name = 'Activo';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Cabinas.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Define las clases de cabina configuradas en cada avión.
*********************************************************************************************/
IF OBJECT_ID('dbo.Cabinas', 'U') IS NOT NULL
    DROP TABLE dbo.Cabinas;
GO

CREATE TABLE dbo.Cabinas (
    CabinaID INT IDENTITY(1,1) NOT NULL,
    AvionID INT NOT NULL,
    NombreCabina VARCHAR(50) NOT NULL,
    Capacidad INT NOT NULL,
    CONSTRAINT PK_Cabinas PRIMARY KEY (CabinaID),
    CONSTRAINT UQ_Cabinas_AvionNombre UNIQUE (AvionID, NombreCabina),
    CONSTRAINT CK_Cabinas_Capacidad CHECK (Capacidad > 0),
    CONSTRAINT FK_Cabinas_Aviones FOREIGN KEY (AvionID)
        REFERENCES dbo.Aviones(AvionID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Define las clases de cabina configuradas en cada avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cabinas';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único de la cabina.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cabinas',
    @level2type = N'COLUMN', @level2name = 'CabinaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Avión al que pertenece la cabina.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cabinas',
    @level2type = N'COLUMN', @level2name = 'AvionID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Nombre de la clase de cabina.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cabinas',
    @level2type = N'COLUMN', @level2name = 'NombreCabina';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Cantidad de asientos de la cabina.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Cabinas',
    @level2type = N'COLUMN', @level2name = 'Capacidad';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Asientos.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los asientos de cada cabina de avión.
*********************************************************************************************/
IF OBJECT_ID('dbo.Asientos', 'U') IS NOT NULL
    DROP TABLE dbo.Asientos;
GO

CREATE TABLE dbo.Asientos (
    AsientoID INT IDENTITY(1,1) NOT NULL,
    CabinaID INT NOT NULL,
    NumeroAsiento VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Asientos PRIMARY KEY (AsientoID),
    CONSTRAINT UQ_Asientos_CabinaNumero UNIQUE (CabinaID, NumeroAsiento),
    CONSTRAINT FK_Asientos_Cabinas FOREIGN KEY (CabinaID)
        REFERENCES dbo.Cabinas(CabinaID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los asientos de cada cabina de avión.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Asientos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del asiento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Asientos',
    @level2type = N'COLUMN', @level2name = 'AsientoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Cabina a la que pertenece el asiento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Asientos',
    @level2type = N'COLUMN', @level2name = 'CabinaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Código o número del asiento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Asientos',
    @level2type = N'COLUMN', @level2name = 'NumeroAsiento';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Vuelos.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los vuelos programados y su ejecución.
*********************************************************************************************/
IF OBJECT_ID('dbo.Vuelos', 'U') IS NOT NULL
    DROP TABLE dbo.Vuelos;
GO

CREATE TABLE dbo.Vuelos (
    VueloID INT IDENTITY(1,1) NOT NULL,
    RutaID INT NOT NULL,
    AvionID INT NOT NULL,
    EstadoVueloID INT NOT NULL,
    CodigoVuelo VARCHAR(20) NOT NULL,
    FechaHoraSalida DATETIME2 NOT NULL,
    FechaHoraLlegada DATETIME2 NOT NULL,
    CONSTRAINT PK_Vuelos PRIMARY KEY (VueloID),
    CONSTRAINT UQ_Vuelos_CodigoFecha UNIQUE (CodigoVuelo, FechaHoraSalida),
    CONSTRAINT CK_Vuelos_Fechas CHECK (FechaHoraLlegada > FechaHoraSalida),
    CONSTRAINT FK_Vuelos_Rutas FOREIGN KEY (RutaID)
        REFERENCES dbo.Rutas(RutaID),
    CONSTRAINT FK_Vuelos_Aviones FOREIGN KEY (AvionID)
        REFERENCES dbo.Aviones(AvionID),
    CONSTRAINT FK_Vuelos_EstadosVuelo FOREIGN KEY (EstadoVueloID)
        REFERENCES dbo.EstadosVuelo(EstadoVueloID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los vuelos programados y su ejecución.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'VueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Ruta asignada al vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'RutaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Avión asignado al vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'AvionID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Estado actual del vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'EstadoVueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Código comercial del vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'CodigoVuelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha y hora programada de salida.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'FechaHoraSalida';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha y hora programada de llegada.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Vuelos',
    @level2type = N'COLUMN', @level2name = 'FechaHoraLlegada';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.PreciosRutaCabina.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Define precios base por ruta, cabina y moneda.
*********************************************************************************************/
IF OBJECT_ID('dbo.PreciosRutaCabina', 'U') IS NOT NULL
    DROP TABLE dbo.PreciosRutaCabina;
GO

CREATE TABLE dbo.PreciosRutaCabina (
    PrecioRutaCabinaID INT IDENTITY(1,1) NOT NULL,
    RutaID INT NOT NULL,
    CabinaID INT NOT NULL,
    MonedaID INT NOT NULL,
    PrecioBase DECIMAL(12,2) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    CONSTRAINT PK_PreciosRutaCabina PRIMARY KEY (PrecioRutaCabinaID),
    CONSTRAINT CK_PreciosRutaCabina_Precio CHECK (PrecioBase >= 0),
    CONSTRAINT CK_PreciosRutaCabina_Fechas CHECK
        (FechaFin IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT FK_PreciosRutaCabina_Rutas FOREIGN KEY (RutaID)
        REFERENCES dbo.Rutas(RutaID),
    CONSTRAINT FK_PreciosRutaCabina_Cabinas FOREIGN KEY (CabinaID)
        REFERENCES dbo.Cabinas(CabinaID),
    CONSTRAINT FK_PreciosRutaCabina_Monedas FOREIGN KEY (MonedaID)
        REFERENCES dbo.Monedas(MonedaID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Define precios base por ruta, cabina y moneda.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador del precio configurado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'PrecioRutaCabinaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Ruta a la que aplica el precio.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'RutaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Cabina a la que aplica el precio.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'CabinaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Moneda en la que se expresa el precio.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'MonedaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Importe base del pasaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'PrecioBase';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha desde la que se aplica el precio.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'FechaInicio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Última fecha de vigencia del precio, si aplica.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'PreciosRutaCabina',
    @level2type = N'COLUMN', @level2name = 'FechaFin';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Descuentos.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los descuentos promocionales disponibles.
*********************************************************************************************/
IF OBJECT_ID('dbo.Descuentos', 'U') IS NOT NULL
    DROP TABLE dbo.Descuentos;
GO

CREATE TABLE dbo.Descuentos (
    DescuentoID INT IDENTITY(1,1) NOT NULL,
    CodigoDescuento VARCHAR(30) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    Porcentaje DECIMAL(5,2) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Descuentos PRIMARY KEY (DescuentoID),
    CONSTRAINT UQ_Descuentos_Codigo UNIQUE (CodigoDescuento),
    CONSTRAINT CK_Descuentos_Porcentaje CHECK (Porcentaje > 0 AND Porcentaje <= 100),
    CONSTRAINT CK_Descuentos_Fechas CHECK (FechaFin >= FechaInicio)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los descuentos promocionales disponibles.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del descuento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'DescuentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Código promocional del descuento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'CodigoDescuento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Descripción de la promoción.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'Descripcion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Porcentaje de descuento aplicado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'Porcentaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha de inicio de la promoción.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'FechaInicio';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha de finalización de la promoción.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'FechaFin';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Indica si la promoción está activa.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Descuentos',
    @level2type = N'COLUMN', @level2name = 'Activo';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Tiquetes.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los tiquetes emitidos para los pasajeros.
*********************************************************************************************/
IF OBJECT_ID('dbo.Tiquetes', 'U') IS NOT NULL
    DROP TABLE dbo.Tiquetes;
GO

CREATE TABLE dbo.Tiquetes (
    TiqueteID INT IDENTITY(1,1) NOT NULL,
    VueloID INT NOT NULL,
    ClienteID INT NULL,
    AsientoID INT NOT NULL,
    EstadoTiqueteID INT NOT NULL,
    NumeroTiquete VARCHAR(30) NOT NULL,
    NombrePasajero VARCHAR(100) NOT NULL,
    ApellidoPasajero VARCHAR(100) NOT NULL,
    DocumentoPasajero VARCHAR(30) NOT NULL,
    FechaEmision DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    PrecioBase DECIMAL(12,2) NOT NULL,
    MonedaID INT NOT NULL,
    CONSTRAINT PK_Tiquetes PRIMARY KEY (TiqueteID),
    CONSTRAINT UQ_Tiquetes_Numero UNIQUE (NumeroTiquete),
    CONSTRAINT UQ_Tiquetes_VueloAsiento UNIQUE (VueloID, AsientoID),
    CONSTRAINT CK_Tiquetes_Precio CHECK (PrecioBase >= 0),
    CONSTRAINT FK_Tiquetes_Vuelos FOREIGN KEY (VueloID)
        REFERENCES dbo.Vuelos(VueloID),
    CONSTRAINT FK_Tiquetes_Clientes FOREIGN KEY (ClienteID)
        REFERENCES dbo.Clientes(ClienteID),
    CONSTRAINT FK_Tiquetes_Asientos FOREIGN KEY (AsientoID)
        REFERENCES dbo.Asientos(AsientoID),
    CONSTRAINT FK_Tiquetes_EstadosTiquete FOREIGN KEY (EstadoTiqueteID)
        REFERENCES dbo.EstadosTiquete(EstadoTiqueteID),
    CONSTRAINT FK_Tiquetes_Monedas FOREIGN KEY (MonedaID)
        REFERENCES dbo.Monedas(MonedaID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los tiquetes emitidos para los pasajeros.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'TiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Vuelo correspondiente al tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'VueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Cliente registrado que compra el tiquete; puede ser nulo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'ClienteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Asiento asignado al pasajero.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'AsientoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Estado actual del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'EstadoTiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Número único del tiquete emitido.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'NumeroTiquete';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Nombres del pasajero según el tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'NombrePasajero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Apellidos del pasajero según el tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'ApellidoPasajero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Documento de identidad consignado en el tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'DocumentoPasajero';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha y hora de emisión del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'FechaEmision';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Precio base registrado al emitir el tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'PrecioBase';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Moneda en la que se expresa el precio del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Tiquetes',
    @level2type = N'COLUMN', @level2name = 'MonedaID';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.TiqueteDescuento.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Relaciona los tiquetes con los descuentos aplicados.
*********************************************************************************************/
IF OBJECT_ID('dbo.TiqueteDescuento', 'U') IS NOT NULL
    DROP TABLE dbo.TiqueteDescuento;
GO

CREATE TABLE dbo.TiqueteDescuento (
    TiqueteDescuentoID INT IDENTITY(1,1) NOT NULL,
    TiqueteID INT NOT NULL,
    DescuentoID INT NOT NULL,
    PorcentajeAplicado DECIMAL(5,2) NOT NULL,
    MontoDescuento DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_TiqueteDescuento PRIMARY KEY (TiqueteDescuentoID),
    CONSTRAINT UQ_TiqueteDescuento UNIQUE (TiqueteID, DescuentoID),
    CONSTRAINT CK_TiqueteDescuento_Porcentaje
        CHECK (PorcentajeAplicado > 0 AND PorcentajeAplicado <= 100),
    CONSTRAINT CK_TiqueteDescuento_Monto CHECK (MontoDescuento >= 0),
    CONSTRAINT FK_TiqueteDescuento_Tiquetes FOREIGN KEY (TiqueteID)
        REFERENCES dbo.Tiquetes(TiqueteID),
    CONSTRAINT FK_TiqueteDescuento_Descuentos FOREIGN KEY (DescuentoID)
        REFERENCES dbo.Descuentos(DescuentoID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Relaciona los tiquetes con los descuentos aplicados.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador de la relación entre tiquete y descuento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento',
    @level2type = N'COLUMN', @level2name = 'TiqueteDescuentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tiquete al que se aplica el descuento.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento',
    @level2type = N'COLUMN', @level2name = 'TiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Descuento aplicado al tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento',
    @level2type = N'COLUMN', @level2name = 'DescuentoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Porcentaje del descuento aplicado al momento de la compra.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento',
    @level2type = N'COLUMN', @level2name = 'PorcentajeAplicado';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Importe monetario descontado del tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'TiqueteDescuento',
    @level2type = N'COLUMN', @level2name = 'MontoDescuento';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Pagos.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra los pagos realizados por los tiquetes.
*********************************************************************************************/
IF OBJECT_ID('dbo.Pagos', 'U') IS NOT NULL
    DROP TABLE dbo.Pagos;
GO

CREATE TABLE dbo.Pagos (
    PagoID INT IDENTITY(1,1) NOT NULL,
    TiqueteID INT NOT NULL,
    MetodoPagoID INT NOT NULL,
    MonedaID INT NOT NULL,
    FechaPago DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Monto DECIMAL(12,2) NOT NULL,
    ReferenciaTransaccion VARCHAR(100) NULL,
    EstadoPago VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT PK_Pagos PRIMARY KEY (PagoID),
    CONSTRAINT CK_Pagos_Monto CHECK (Monto > 0),
    CONSTRAINT CK_Pagos_Estado CHECK
        (EstadoPago IN ('Pendiente', 'Aprobado', 'Rechazado', 'Reembolsado')),
    CONSTRAINT FK_Pagos_Tiquetes FOREIGN KEY (TiqueteID)
        REFERENCES dbo.Tiquetes(TiqueteID),
    CONSTRAINT FK_Pagos_MetodosPago FOREIGN KEY (MetodoPagoID)
        REFERENCES dbo.MetodosPago(MetodoPagoID),
    CONSTRAINT FK_Pagos_Monedas FOREIGN KEY (MonedaID)
        REFERENCES dbo.Monedas(MonedaID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra los pagos realizados por los tiquetes.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'PagoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tiquete asociado al pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'TiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Método de pago utilizado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'MetodoPagoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Moneda en la que se efectuó el pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'MonedaID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Fecha y hora en que se registró el pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'FechaPago';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Importe del pago registrado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'Monto';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Referencia externa de la transacción, si existe.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'ReferenciaTransaccion';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Estado actual de la transacción de pago.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Pagos',
    @level2type = N'COLUMN', @level2name = 'EstadoPago';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.Equipaje.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Registra el equipaje asociado a cada tiquete.
*********************************************************************************************/
IF OBJECT_ID('dbo.Equipaje', 'U') IS NOT NULL
    DROP TABLE dbo.Equipaje;
GO

CREATE TABLE dbo.Equipaje (
    EquipajeID INT IDENTITY(1,1) NOT NULL,
    TiqueteID INT NOT NULL,
    TipoEquipajeID INT NOT NULL,
    PesoKg DECIMAL(6,2) NOT NULL,
    Costo DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT PK_Equipaje PRIMARY KEY (EquipajeID),
    CONSTRAINT CK_Equipaje_Peso CHECK (PesoKg > 0),
    CONSTRAINT CK_Equipaje_Costo CHECK (Costo >= 0),
    CONSTRAINT FK_Equipaje_Tiquetes FOREIGN KEY (TiqueteID)
        REFERENCES dbo.Tiquetes(TiqueteID),
    CONSTRAINT FK_Equipaje_TiposEquipaje FOREIGN KEY (TipoEquipajeID)
        REFERENCES dbo.TiposEquipaje(TipoEquipajeID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registra el equipaje asociado a cada tiquete.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único del registro de equipaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje',
    @level2type = N'COLUMN', @level2name = 'EquipajeID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tiquete al que pertenece el equipaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje',
    @level2type = N'COLUMN', @level2name = 'TiqueteID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Tipo de equipaje registrado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje',
    @level2type = N'COLUMN', @level2name = 'TipoEquipajeID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Peso del equipaje expresado en kilogramos.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje',
    @level2type = N'COLUMN', @level2name = 'PesoKg';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Costo adicional del equipaje.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'Equipaje',
    @level2type = N'COLUMN', @level2name = 'Costo';
GO


/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.EmpleadoVuelo.
-- Fecha de creación: 27/10/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Asigna empleados a los vuelos en los que prestan servicio.
*********************************************************************************************/
IF OBJECT_ID('dbo.EmpleadoVuelo', 'U') IS NOT NULL
    DROP TABLE dbo.EmpleadoVuelo;
GO

CREATE TABLE dbo.EmpleadoVuelo (
    EmpleadoVueloID INT IDENTITY(1,1) NOT NULL,
    EmpleadoID INT NOT NULL,
    VueloID INT NOT NULL,
    Funcion VARCHAR(80) NOT NULL,
    CONSTRAINT PK_EmpleadoVuelo PRIMARY KEY (EmpleadoVueloID),
    CONSTRAINT UQ_EmpleadoVuelo UNIQUE (EmpleadoID, VueloID),
    CONSTRAINT FK_EmpleadoVuelo_Empleados FOREIGN KEY (EmpleadoID)
        REFERENCES dbo.Empleados(EmpleadoID),
    CONSTRAINT FK_EmpleadoVuelo_Vuelos FOREIGN KEY (VueloID)
        REFERENCES dbo.Vuelos(VueloID)
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Asigna empleados a los vuelos en los que prestan servicio.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EmpleadoVuelo';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Identificador único de la asignación.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EmpleadoVuelo',
    @level2type = N'COLUMN', @level2name = 'EmpleadoVueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Empleado asignado al vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EmpleadoVuelo',
    @level2type = N'COLUMN', @level2name = 'EmpleadoID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Vuelo al que se asigna el empleado.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EmpleadoVuelo',
    @level2type = N'COLUMN', @level2name = 'VueloID';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description', @value = N'Función que cumple el empleado durante el vuelo.',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE', @level1name = 'EmpleadoVuelo',
    @level2type = N'COLUMN', @level2name = 'Funcion';
GO

/*********************************************************************************************
-- Comentario: Creación de la tabla dbo.TipoCambio.
-- Fecha de creación: 11/11/2026
-- Autor: CIELO SOTOMAYOR
-- Descripción: Tipo de Cambio a una fecha.
*********************************************************************************************/
IF OBJECT_ID('dbo.TipoCambio', 'U') IS NOT NULL
    DROP TABLE dbo.TipoCambio;
GO

CREATE TABLE dbo.TipoCambio (
    TipoCambioID INT IDENTITY(1,1) PRIMARY KEY,
    MonedaID INT NOT NULL,
    FechaCambio DATE NOT NULL,
    ValorEnSoles DECIMAL(18,6) NOT NULL,
    Estado CHAR(1) DEFAULT 'A',

    CONSTRAINT FK_TipoCambio_Monedas
        FOREIGN KEY (MonedaID)
        REFERENCES dbo.Monedas(MonedaID)
);
GO

-- LIMPIEZA ------------------------------------------------------------------------------


USE AEROSKYBD
GO
/************************
-- DESHABILITAR CONSTRAINTS
*************************/
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

/************************
-- ELIMINAR DATOS
*************************/
EXEC sp_MSforeachtable 'DELETE FROM ?';
GO

/************************
-- RESETEAR IDENTITY
*************************/
EXEC sp_MSforeachtable '
IF OBJECTPROPERTY(OBJECT_ID(''?''), ''TableHasIdentity'') = 1
    DBCC CHECKIDENT (''?'', RESEED, 0)
';
GO

/************************
-- HABILITAR CONSTRAINTS
*************************/
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO


/*********************************************************************************************
-- Script : Carga de datos de prueba - AEROSKYBD
-- Requiere: haber ejecutado antes Aerolinea.sql (estructura de tablas).
-- Alcance : ~1 anio de operacion: desde HOY-1 anio hasta HOY (vuelos ya realizados) mas
--           30 dias de vuelos programados con ventas parciales.
-- Criterios de consistencia:
--   * Todas las FK se respetan (catalogos -> maestros -> transacciones).
--   * Cada avion opera una sola ruta de ida y vuelta desde BOG (sin traslapes de vuelos).
--   * Capacidad del avion = suma de capacidades de cabinas = cantidad de asientos creados.
--   * Un tiquete usa un asiento de la cabina del avion del vuelo (sin sobreventa).
--   * Precio del tiquete = precio vigente de la ruta/cabina a la fecha del vuelo.
--   * Cliente registrado ANTES de comprar; emision < salida del vuelo y <= ahora.
--   * Estado de vuelo/tiquete/pago coherente con la fecha actual (reembolsos, cancelaciones).
--   * Tripulacion fija por avion con rotacion diaria; empleados contratados antes del vuelo.
-- Volumen : depende de la fecha de ejecucion (aprox. 3,000 vuelos y 200,000 tiquetes/anio).
-- Es re-ejecutable: limpia las tablas y reinicia identidades al comienzo.
*********************************************************************************************/
USE AEROSKYBD;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Ahora    DATETIME2 = SYSDATETIME();
DECLARE @Fin      DATE      = CAST(@Ahora AS DATE);
DECLARE @Inicio   DATE      = DATEADD(YEAR, -1, @Fin);
DECLARE @Horizonte DATE     = DATEADD(DAY, 30, @Fin);
DECLARE @S        DATETIME2 = DATEADD(DAY, -90, CAST(@Inicio AS DATETIME2)); -- inicio de ventas anticipadas
DECLARE @NClientes INT      = 20000;

BEGIN TRAN;

/*==============================================================
  PROYECTO: AEROSKY
==============================================================*/
-- AUXILIARES ----------------------------------------------------------------------------
DROP TABLE IF EXISTS #Nums, #Pares, #RutaAvion, #Nom, #Ape, #C, #CumCli, #E, #Pool, #V0, #VF0, #T0, #T00, #T01, #T1, #TT, #VF, #PG,#Asig
SELECT TOP (60000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
INTO #Nums FROM sys.all_columns a CROSS JOIN sys.all_columns b;


-- CATALOGOS -----------------------------------------------------------------------------
INSERT dbo.Paises (CodigoPais, NombrePais) VALUES
('CO','Colombia'),('US','Estados Unidos'),('PA','Panama'),('PE','Peru'),('MX','Mexico'),
('EC','Ecuador'),('ES','Espana'),('AR','Argentina'),('CL','Chile'),('BR','Brasil'),
('VE','Venezuela'),('FR','Francia'),('CA','Canada'),('DO','Republica Dominicana'),('CR','Costa Rica');

INSERT dbo.Generos (Descripcion) VALUES ('Masculino'),('Femenino'),('No binario'),('Prefiero no decir');
INSERT dbo.TiposDocumento (NombreTipo) VALUES ('Cedula de Ciudadania'),('Pasaporte'),('Cedula de Extranjeria'),('Tarjeta de Identidad');
INSERT dbo.EstadosCliente (Descripcion) VALUES ('Activo'),('Inactivo'),('Suspendido'),('VIP');
INSERT dbo.Cargos (NombreCargo) VALUES
('Piloto'),('Copiloto'),('Auxiliar de Vuelo'),('Agente de Servicio al Cliente'),('Despachador de Vuelo'),
('Tecnico de Mantenimiento'),('Jefe de Operaciones'),('Analista Administrativo');
INSERT dbo.MetodosPago (NombreMetodo) VALUES
('Tarjeta de Credito'),('Tarjeta de Debito'),('PSE'),('Transferencia Bancaria'),('Efectivo'),('PayPal');
INSERT dbo.Monedas (CodigoMoneda, NombreMoneda) VALUES ('COP','Peso colombiano'),('USD','Dolar estadounidense'),('EUR','Euro'),('PEN','Sol');
INSERT dbo.EstadosVuelo (Descripcion) VALUES ('Programado'),('Abordando'),('En Vuelo'),('Aterrizado'),('Retrasado'),('Cancelado');
INSERT dbo.EstadosTiquete (Descripcion) VALUES ('Reservado'),('Emitido'),('Abordado'),('Cancelado'),('No Presentado');
INSERT dbo.TiposEquipaje (NombreTipo) VALUES ('Equipaje de mano'),('Equipaje de bodega'),('Equipo deportivo'),('Mascota'),('Instrumento musical');

INSERT INTO dbo.TipoCambio ( MonedaID, FechaCambio, ValorEnSoles)
VALUES
(0, '2026-11-01', 3.750000), -- Dólar
(1, '2026-11-01', 4.100000), -- Euro
(2, '2026-11-01', 0.004100), -- Peso chileno
(3, '2026-11-01', 1.000000); -- Sol

INSERT dbo.Localizaciones (PaisID, CodigoAeropuerto, NombreAeropuerto, Ciudad)
SELECT p.PaisID, v.cod, v.nom, v.ciu
FROM (VALUES
 ('CO','BOG','Aeropuerto Internacional El Dorado','Bogota'),
 ('CO','MDE','Aeropuerto Internacional Jose Maria Cordova','Rionegro'),
 ('CO','CLO','Aeropuerto Internacional Alfonso Bonilla Aragon','Cali'),
 ('CO','CTG','Aeropuerto Internacional Rafael Nunez','Cartagena'),
 ('CO','BAQ','Aeropuerto Internacional Ernesto Cortissoz','Barranquilla'),
 ('CO','BGA','Aeropuerto Internacional Palonegro','Bucaramanga'),
 ('US','MIA','Aeropuerto Internacional de Miami','Miami'),
 ('PA','PTY','Aeropuerto Internacional de Tocumen','Ciudad de Panama'),
 ('PE','LIM','Aeropuerto Internacional Jorge Chavez','Lima'),
 ('MX','MEX','Aeropuerto Internacional Benito Juarez','Ciudad de Mexico'),
 ('EC','UIO','Aeropuerto Internacional Mariscal Sucre','Quito')
) v(pais,cod,nom,ciu) JOIN dbo.Paises p ON p.CodigoPais = v.pais;

-- FLOTA Y RUTAS: un avion dedicado por par de rutas BOG<->destino -----------------------
SELECT p, Dest, Tipo, Moneda, Precio, Dur, Dias, Fab, Modelo, Matricula, Bus, Eco, NAux
INTO #Pares
FROM (VALUES
 (1,'MDE','D','COP',230000, 55,'1,2,3,4,5','Embraer','E190',    'HK-5001',2,12,2),
 (2,'CLO','D','COP',260000, 65,'1,2,3,4,5','Embraer','E190',    'HK-5002',2,12,2),
 (3,'CTG','D','COP',320000,100,'1,3,5',    'ATR',    'ATR 72-600','HK-5003',1,11,2),
 (4,'BAQ','D','COP',310000,105,'2,4,6',    'ATR',    'ATR 72-600','HK-5004',1,11,2),
 (5,'BGA','D','COP',280000, 60,'3,5,7',    'ATR',    'ATR 72-600','HK-5005',1,11,2),
 (6,'MIA','I','USD',   380,200,'2,5',      'Airbus', 'A320',    'HK-5006',3,21,4),
 (7,'PTY','I','USD',   260,125,'3,6',      'Airbus', 'A319',    'HK-5007',3,17,3),
 (8,'LIM','I','USD',   290,180,'1,4',      'Airbus', 'A319',    'HK-5008',3,17,3),
 (9,'MEX','I','USD',   420,285,'3,7',      'Airbus', 'A320',    'HK-5009',3,21,4),
 (10,'UIO','I','USD',  240, 80,'2,6',      'Airbus', 'A319',    'HK-5010',3,17,3)
) v(p,Dest,Tipo,Moneda,Precio,Dur,Dias,Fab,Modelo,Matricula,Bus,Eco,NAux);

INSERT dbo.Aviones (Fabricante, Modelo, Matricula, Capacidad, Activo)
SELECT Fab, Modelo, Matricula, 6*(Bus+Eco), 1 FROM #Pares ORDER BY p;

INSERT dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT a.AvionID, c.nom, c.cap
FROM #Pares p JOIN dbo.Aviones a ON a.Matricula = p.Matricula
CROSS APPLY (VALUES ('Ejecutiva', 6*p.Bus), ('Economica', 6*p.Eco)) c(nom, cap)
ORDER BY a.AvionID, c.cap;

INSERT dbo.Asientos (CabinaID, NumeroAsiento)
SELECT c.CabinaID, CAST(r.n AS VARCHAR(10)) + l.letra
FROM #Pares p
JOIN dbo.Aviones a ON a.Matricula = p.Matricula
JOIN dbo.Cabinas c ON c.AvionID = a.AvionID
JOIN #Nums r ON (c.NombreCabina = 'Ejecutiva' AND r.n BETWEEN 1 AND p.Bus)
             OR (c.NombreCabina = 'Economica' AND r.n BETWEEN p.Bus + 1 AND p.Bus + p.Eco)
CROSS JOIN (VALUES ('A'),('B'),('C'),('D'),('E'),('F')) l(letra)
ORDER BY c.CabinaID, r.n, l.letra;

-- Rutas ida (BOG->X) y regreso (X->BOG)
INSERT dbo.Rutas (LocalizacionOrigenID, LocalizacionDestinoID, CodigoRuta, Activa)
SELECT o.LocalizacionID, d.LocalizacionID, 'BOG-' + p.Dest, 1
FROM #Pares p JOIN dbo.Localizaciones o ON o.CodigoAeropuerto = 'BOG'
JOIN dbo.Localizaciones d ON d.CodigoAeropuerto = p.Dest ORDER BY p.p;
INSERT dbo.Rutas (LocalizacionOrigenID, LocalizacionDestinoID, CodigoRuta, Activa)
SELECT d.LocalizacionID, o.LocalizacionID, p.Dest + '-BOG', 1
FROM #Pares p JOIN dbo.Localizaciones o ON o.CodigoAeropuerto = 'BOG'
JOIN dbo.Localizaciones d ON d.CodigoAeropuerto = p.Dest ORDER BY p.p;

SELECT r.RutaID, a.AvionID, p.p, p.Tipo, p.Moneda, p.Precio, p.Dur, p.NAux, p.Dias,
       CASE WHEN r.CodigoRuta LIKE 'BOG-%' THEN 1 ELSE 0 END AS EsIda
INTO #RutaAvion
FROM #Pares p
JOIN dbo.Aviones a ON a.Matricula = p.Matricula
JOIN dbo.Rutas r ON r.CodigoRuta IN ('BOG-' + p.Dest, p.Dest + '-BOG');

-- Horarios semanales (1=lunes ... 7=domingo). Ida 06:00; regreso 09:30 (nacional) / 12:30 (internacional)
INSERT dbo.HorariosRuta (RutaID, DiaSemana, HoraSalida, DuracionMinutos)
SELECT ra.RutaID, CAST(LTRIM(RTRIM(s.value)) AS TINYINT),
       CASE WHEN ra.EsIda = 1 THEN CAST('06:00' AS TIME)
            WHEN ra.Tipo = 'D' THEN CAST('09:30' AS TIME) ELSE CAST('12:30' AS TIME) END,
       ra.Dur
FROM #RutaAvion ra CROSS APPLY STRING_SPLIT(ra.Dias, ',') s
ORDER BY ra.RutaID, 2;

-- Precios: dos vigencias (incremento 8% desde el semestre actual)
INSERT dbo.PreciosRutaCabina (RutaID, CabinaID, MonedaID, PrecioBase, FechaInicio, FechaFin)
SELECT ra.RutaID, c.CabinaID, m.MonedaID,
       CASE WHEN ra.Tipo = 'D'
            THEN ROUND(ra.Precio * f.fc * f.fp / 1000.0, 0) * 1000
            ELSE ROUND(ra.Precio * f.fc * f.fp, 0) END,
       f.ini, f.fin
FROM #RutaAvion ra
JOIN dbo.Cabinas c ON c.AvionID = ra.AvionID
JOIN dbo.Monedas m ON m.CodigoMoneda = ra.Moneda
CROSS APPLY (VALUES
   (1.00, DATEADD(YEAR,-1,@Inicio), DATEADD(DAY,-1,DATEADD(MONTH,6,@Inicio))),
   (1.08, DATEADD(MONTH,6,@Inicio), CAST(NULL AS DATE))) per(fp, ini, fin)
CROSS APPLY (SELECT CASE WHEN c.NombreCabina = 'Ejecutiva' THEN 2.6 ELSE 1.0 END AS fc,
                    per.fp AS fp, per.ini AS ini, per.fin AS fin) f
ORDER BY ra.RutaID, c.CabinaID, f.ini;

-- DESCUENTOS ----------------------------------------------------------------------------
INSERT dbo.Descuentos (CodigoDescuento, Descripcion, Porcentaje, FechaInicio, FechaFin, Activo)
SELECT 'TEMP-' + v.cod + '-' + CAST(y.Y AS VARCHAR(4)), v.dsc + ' ' + CAST(y.Y AS VARCHAR(4)), v.pct,
       DATEFROMPARTS(y.Y, v.m1, v.d1), DATEFROMPARTS(y.Y, v.m2, v.d2),
       CASE WHEN DATEFROMPARTS(y.Y, v.m2, v.d2) < @Fin THEN 0 ELSE 1 END
FROM (SELECT YEAR(@S) + n - 1 AS Y FROM #Nums WHERE n <= DATEDIFF(YEAR, @S, @Fin) + 1) y
CROSS JOIN (VALUES
  ('VERANO',     'Promocion de verano',            12.00, 1,  5, 1, 31),
  ('SEMSANTA',   'Promocion Semana Santa',         10.00, 3,  1, 4, 10),
  ('MITADANIO',  'Promocion mitad de anio',        15.00, 6, 10, 7,  5),
  ('BLACKFRIDAY','Black Friday',                   20.00, 11,25, 11,30),
  ('NAVIDAD',    'Promocion de Navidad',           10.00, 12, 1, 12,24)
) v(cod, dsc, pct, m1, d1, m2, d2);

INSERT dbo.Descuentos (CodigoDescuento, Descripcion, Porcentaje, FechaInicio, FechaFin, Activo)
SELECT v.cod, v.dsc, v.pct, DATEFROMPARTS(YEAR(@S) - 1, 1, 1), DATEFROMPARTS(YEAR(@Fin) + 1, 12, 31), 1
FROM (VALUES
  ('ESTUDIANTE', 'Descuento estudiantes (hasta 28 anios)',      10.00),
  ('ADULTOMAYOR','Descuento adulto mayor (60 anios o mas)',     15.00),
  ('FIDELIDAD',  'Descuento programa de fidelizacion',           5.00),
  ('EARLYBIRD',  'Compra anticipada (45 dias o mas)',           12.00)) v(cod, dsc, pct);

-- NOMBRES AUXILIARES -----------------------------------------------------------------------
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, nombre, gen
INTO #Nom FROM (VALUES
 ('Juan','M'),('Carlos','M'),('Andres','M'),('Luis','M'),('Jorge','M'),('Miguel','M'),('David','M'),('Camilo','M'),('Felipe','M'),('Sebastian','M'),
 ('Santiago','M'),('Daniel','M'),('Jose','M'),('Mateo','M'),('Nicolas','M'),('Alejandro','M'),('Diego','M'),('Ricardo','M'),('Fernando','M'),('Oscar','M'),
 ('Maria','F'),('Ana','F'),('Laura','F'),('Paula','F'),('Carolina','F'),('Natalia','F'),('Camila','F'),('Valentina','F'),('Sofia','F'),('Daniela','F'),
 ('Andrea','F'),('Juliana','F'),('Luisa','F'),('Diana','F'),('Claudia','F'),('Mariana','F'),('Isabella','F'),('Sara','F'),('Catalina','F'),('Veronica','F')) v(nombre, gen);

SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, apellido
INTO #Ape FROM (VALUES
 ('Garcia'),('Rodriguez'),('Martinez'),('Lopez'),('Gonzalez'),('Hernandez'),('Perez'),('Sanchez'),('Ramirez'),('Torres'),
 ('Flores'),('Rivera'),('Gomez'),('Diaz'),('Reyes'),('Morales'),('Jimenez'),('Ruiz'),('Alvarez'),('Mendoza'),
 ('Castillo'),('Vargas'),('Ortiz'),('Castro'),('Romero'),('Suarez'),('Rojas'),('Moreno'),('Cardenas'),('Herrera'),
 ('Medina'),('Aguilar'),('Silva'),('Guerrero'),('Pardo'),('Salazar'),('Cortes'),('Mejia'),('Cruz'),('Ospina')) v(apellido);

-- CLIENTES: crecimiento uniforme. Los primeros 4,000 ya existian antes de iniciar las ventas ------
SELECT n,
       ABS(CHECKSUM(NEWID())) AS r1, ABS(CHECKSUM(NEWID())) AS r2, ABS(CHECKSUM(NEWID())) AS r3,
       ABS(CHECKSUM(NEWID())) AS r4, ABS(CHECKSUM(NEWID())) AS r5, ABS(CHECKSUM(NEWID())) AS r6
INTO #C FROM #Nums WHERE n <= @NClientes;

INSERT dbo.Clientes (TipoDocumentoID, EstadoClienteID, GeneroID, PaisID, NumeroDocumento, Nombres, Apellidos,
                     FechaNacimiento, Correo, Telefono, FechaRegistro)
SELECT td.TipoDocumentoID, ec.EstadoClienteID, g.GeneroID, pa.PaisID,
       CASE WHEN td.NombreTipo = 'Pasaporte' THEN 'P' + RIGHT('00000000' + CAST(c.n AS VARCHAR(8)), 8)
            ELSE CAST(10000000 + c.n * 997 AS VARCHAR(30)) END,
       nm.nombre, ap.apellido,
       DATEADD(DAY, -(18 * 365 + c.r3 % (62 * 365)), @Fin),
       LOWER(nm.nombre) + '.' + LOWER(ap.apellido) + CAST(c.n AS VARCHAR(8)) + '@' +
           CHOOSE(1 + c.r4 % 5, 'gmail.com', 'hotmail.com', 'outlook.com', 'yahoo.com', 'correo.com'),
       CASE WHEN c.r5 % 100 < 5 THEN NULL
            ELSE '3' + RIGHT('000000000' + CAST(c.r5 % 1000000000 AS VARCHAR(10)), 9) END,
       CASE WHEN c.n <= 4000
            THEN DATEADD(SECOND, CAST(c.n - 4000 AS BIGINT) * (400 * 86400 / 4000), @S)
            ELSE DATEADD(SECOND, CAST(c.n - 4000 AS BIGINT) * (DATEDIFF(SECOND, @S, @Ahora) / (@NClientes - 4000)) - 3600, @S) END
FROM #C c
JOIN #Nom nm ON nm.id = 1 + c.r1 % 40
JOIN #Ape ap ON ap.id = 1 + c.r2 % 40
JOIN dbo.Paises pa ON pa.CodigoPais = CASE WHEN c.r6 % 100 < 70 THEN 'CO'
                                           ELSE CHOOSE(1 + c.r6 % 14, 'US','PA','PE','MX','EC','ES','AR','CL','BR','VE','FR','CA','DO','CR') END
JOIN dbo.TiposDocumento td ON td.NombreTipo =
       CASE WHEN pa.CodigoPais = 'CO' THEN CASE WHEN c.r4 % 100 < 80 THEN 'Cedula de Ciudadania' ELSE 'Pasaporte' END
            ELSE CASE WHEN c.r4 % 100 < 70 THEN 'Pasaporte' ELSE 'Cedula de Extranjeria' END END
JOIN dbo.EstadosCliente ec ON ec.Descripcion =
       CASE WHEN c.r6 % 100 < 4 THEN 'VIP' WHEN c.r6 % 100 < 8 THEN 'Inactivo'
            WHEN c.r6 % 100 < 10 THEN 'Suspendido' ELSE 'Activo' END
LEFT JOIN dbo.Generos g ON g.Descripcion =
       CASE WHEN c.r5 % 100 < 2 THEN 'No binario' WHEN c.r5 % 100 < 4 THEN 'Prefiero no decir'
            WHEN nm.gen = 'M' THEN 'Masculino' ELSE 'Femenino' END
ORDER BY c.n;

-- Clientes registrados antes de cada fecha (para que nadie compre antes de registrarse)
SELECT d.Fecha, (SELECT COUNT(*) FROM dbo.Clientes cl WHERE cl.FechaRegistro < CAST(d.Fecha AS DATETIME2)) AS Cnt
INTO #CumCli
FROM (SELECT DATEADD(DAY, n - 1, CAST(@S AS DATE)) AS Fecha FROM #Nums
      WHERE n <= DATEDIFF(DAY, CAST(@S AS DATE), @Fin) + 1) d;

-- EMPLEADOS --------------------------------------------------------------------------------
-- Pilotos 30, Copilotos 30, Auxiliares 60 (3/3/6 por avion), personal de tierra 55
SELECT n, ABS(CHECKSUM(NEWID())) AS r1, ABS(CHECKSUM(NEWID())) AS r2, ABS(CHECKSUM(NEWID())) AS r3, ABS(CHECKSUM(NEWID())) AS r4,
       CASE WHEN n <= 30 THEN 'Piloto' WHEN n <= 60 THEN 'Copiloto' WHEN n <= 120 THEN 'Auxiliar de Vuelo'
            WHEN n <= 140 THEN 'Agente de Servicio al Cliente' WHEN n <= 146 THEN 'Despachador de Vuelo'
            WHEN n <= 166 THEN 'Tecnico de Mantenimiento' WHEN n <= 169 THEN 'Jefe de Operaciones'
            ELSE 'Analista Administrativo' END AS cargo
INTO #E FROM #Nums WHERE n <= 175;

INSERT dbo.Empleados (TipoDocumentoID, CargoID, PaisID, NumeroDocumento, Nombres, Apellidos, Correo, Telefono, FechaContratacion, Activo)
SELECT td.TipoDocumentoID, cg.CargoID, pa.PaisID,
       CAST(80000000 + e.n * 1013 AS VARCHAR(30)), nm.nombre, ap.apellido,
       LOWER(nm.nombre) + '.' + LOWER(ap.apellido) + CAST(e.n AS VARCHAR(5)) + '@aerosky.com',
       '3' + RIGHT('000000000' + CAST(e.r4 % 1000000000 AS VARCHAR(10)), 9),
       CASE WHEN e.n <= 120 THEN DATEADD(DAY, -(60 + e.r3 % 2000), @Inicio)
            ELSE DATEADD(DAY, -(e.r3 % 2300), @Fin) END,
       CASE WHEN e.n IN (131, 132, 160) THEN 0 ELSE 1 END
FROM #E e
JOIN #Nom nm ON nm.id = 1 + e.r1 % 40
JOIN #Ape ap ON ap.id = 1 + e.r2 % 40
JOIN dbo.Cargos cg ON cg.NombreCargo = e.cargo
JOIN dbo.TiposDocumento td ON td.NombreTipo = 'Cedula de Ciudadania'
JOIN dbo.Paises pa ON pa.CodigoPais = CASE WHEN e.r4 % 100 < 92 THEN 'CO' ELSE 'EC' END
ORDER BY e.n;

-- Pool de tripulacion por avion: (par, cargo, slot) -> EmpleadoID

SELECT q.p, x.Cargo, q.slot, x.EmpleadoID
INTO #Pool
FROM (
   SELECT e.EmpleadoID, c.NombreCargo AS Cargo,
          ROW_NUMBER() OVER (PARTITION BY c.NombreCargo ORDER BY e.EmpleadoID) - 1 AS k
   FROM dbo.Empleados e JOIN dbo.Cargos c ON c.CargoID = e.CargoID
   WHERE c.NombreCargo IN ('Piloto','Copiloto','Auxiliar de Vuelo')
) x
CROSS APPLY (SELECT CASE WHEN x.Cargo = 'Auxiliar de Vuelo' THEN x.k / 6 + 1 ELSE x.k / 3 + 1 END AS p,
                    CASE WHEN x.Cargo = 'Auxiliar de Vuelo' THEN x.k % 6 ELSE x.k % 3 END AS slot) q;

-- VUELOS -----------------------------------------------------------------------------------
SELECT ra.RutaID, ra.AvionID, ra.p,
       DATEADD(MINUTE, DATEDIFF(MINUTE, CAST('00:00' AS TIME), h.HoraSalida), CAST(c.Fecha AS DATETIME2)) AS Salida,
       ra.Dur,
       ABS(CHECKSUM(NEWID())) % 1000 AS r
INTO #V0
FROM (SELECT DATEADD(DAY, n - 1, @Inicio) AS Fecha,
             (DATEDIFF(DAY, '19000101', DATEADD(DAY, n - 1, @Inicio)) % 7) + 1 AS Dia
      FROM #Nums WHERE n <= DATEDIFF(DAY, @Inicio, @Horizonte) + 1) c
JOIN dbo.HorariosRuta h ON h.DiaSemana = c.Dia
JOIN #RutaAvion ra ON ra.RutaID = h.RutaID;

INSERT dbo.Vuelos (RutaID, AvionID, EstadoVueloID, CodigoVuelo, FechaHoraSalida, FechaHoraLlegada)
SELECT v.RutaID, v.AvionID, ev.EstadoVueloID, 'AS' + CAST(100 + v.RutaID AS VARCHAR(10)), v.Salida,
       DATEADD(MINUTE, v.Dur, v.Salida)
FROM #V0 v
JOIN dbo.EstadosVuelo ev ON ev.Descripcion =
     CASE WHEN v.r < 25 THEN 'Cancelado'
          WHEN DATEADD(MINUTE, v.Dur, v.Salida) <= @Ahora THEN 'Aterrizado'
          WHEN v.Salida <= @Ahora THEN 'En Vuelo'
          WHEN v.Salida <= DATEADD(HOUR, 1, @Ahora) THEN 'Abordando'
          WHEN v.Salida <= DATEADD(DAY, 7, @Ahora) AND v.r < 65 THEN 'Retrasado'
          ELSE 'Programado' END
ORDER BY v.Salida, v.RutaID;

-- Ficha de cada vuelo con ocupacion objetivo
SELECT f.VueloID, f.RutaID, f.AvionID, f.FechaHoraSalida AS Salida, f.FechaHoraLlegada AS Llegada,
       ev.Descripcion AS EstadoVuelo, ra.p, ra.NAux, av.Capacidad,
       DATEDIFF(DAY, '19000101', CAST(f.FechaHoraSalida AS DATE)) AS DiaIdx,
       DATEDIFF(DAY, @Fin, CAST(f.FechaHoraSalida AS DATE)) AS DiasAdelante,
       ABS(CHECKSUM(NEWID())) % 1000 / 1000.0 AS rr
INTO #VF0
FROM dbo.Vuelos f
JOIN dbo.EstadosVuelo ev ON ev.EstadoVueloID = f.EstadoVueloID
JOIN #RutaAvion ra ON ra.RutaID = f.RutaID
JOIN dbo.Aviones av ON av.AvionID = f.AvionID;

SELECT v.*,
       CASE WHEN x.nv < 1 THEN 1 WHEN x.nv > v.Capacidad THEN v.Capacidad ELSE x.nv END AS NVend
INTO #VF
FROM #VF0 v
CROSS APPLY (SELECT CAST(ROUND(v.Capacidad *
        CASE WHEN lf.v > 0.97 THEN 0.97 ELSE lf.v END *
        CASE WHEN v.DiasAdelante > 0 THEN 1 - 0.75 * v.DiasAdelante / 31.0 ELSE 1 END *
        CASE WHEN v.EstadoVuelo = 'Cancelado' THEN 0.5 ELSE 1 END, 0) AS INT) AS nv
     FROM (SELECT 0.60 + 0.30 * v.rr
                 + CASE WHEN MONTH(v.Salida) IN (12, 1, 6, 7) THEN 0.08 ELSE 0 END
                 + CASE WHEN (v.DiaIdx % 7) + 1 IN (5, 7) THEN 0.04 ELSE 0 END AS v) lf) x;

-- TRIPULACION ------------------------------------------------------------------------------
INSERT dbo.EmpleadoVuelo (EmpleadoID, VueloID, Funcion)
SELECT pl.EmpleadoID, f.VueloID, 'Piloto al mando'
FROM #VF f JOIN #Pool pl ON pl.p = f.p AND pl.Cargo = 'Piloto' AND pl.slot = f.DiaIdx % 3
UNION ALL
SELECT pl.EmpleadoID, f.VueloID, 'Copiloto'
FROM #VF f JOIN #Pool pl ON pl.p = f.p AND pl.Cargo = 'Copiloto' AND pl.slot = (f.DiaIdx + 1) % 3
UNION ALL
SELECT pl.EmpleadoID, f.VueloID, CASE WHEN j.j = 0 THEN 'Jefe de cabina' ELSE 'Auxiliar de vuelo' END
FROM #VF f
JOIN #Nums j0 ON j0.n <= f.NAux
CROSS APPLY (SELECT j0.n - 1 AS j) j
JOIN #Pool pl ON pl.p = f.p AND pl.Cargo = 'Auxiliar de Vuelo' AND pl.slot = (f.DiaIdx * 2 + j.j) % 6;

-- TIQUETES ---------------------------------------------------------------------------------
-- Etapa 1: asientos vendidos por vuelo (sin sobreventa) y precio vigente
SELECT x.VueloID, x.AsientoID, x.CabinaID
INTO #Asig
FROM (SELECT f.VueloID, f.NVend, s.AsientoID, s.CabinaID,
             ROW_NUMBER() OVER (PARTITION BY f.VueloID ORDER BY NEWID()) AS rn
      FROM #VF f
      JOIN dbo.Cabinas c ON c.AvionID = f.AvionID
      JOIN dbo.Asientos s ON s.CabinaID = c.CabinaID) x
WHERE x.rn <= x.NVend;

SELECT a.VueloID, a.AsientoID, f.RutaID, f.Salida, f.Llegada, f.EstadoVuelo,
       pr.PrecioBase, pr.MonedaID,
       ABS(CHECKSUM(NEWID())) AS r1, ABS(CHECKSUM(NEWID())) AS r2, ABS(CHECKSUM(NEWID())) AS r3,
       ABS(CHECKSUM(NEWID())) AS r4, ABS(CHECKSUM(NEWID())) AS r5, ABS(CHECKSUM(NEWID())) AS r6,
       ABS(CHECKSUM(NEWID())) AS r7, ABS(CHECKSUM(NEWID())) AS r8, ABS(CHECKSUM(NEWID())) AS r9,
       ABS(CHECKSUM(NEWID())) AS r10, ABS(CHECKSUM(NEWID())) AS r11
INTO #T00
FROM #Asig a
JOIN #VF f ON f.VueloID = a.VueloID
JOIN dbo.PreciosRutaCabina pr ON pr.RutaID = f.RutaID AND pr.CabinaID = a.CabinaID
     AND CAST(f.Salida AS DATE) >= pr.FechaInicio
     AND (pr.FechaFin IS NULL OR CAST(f.Salida AS DATE) <= pr.FechaFin);

-- Etapa 2: fecha de emision y cliente comprador
SELECT t.*, e.Emision
INTO #T01
FROM #T00 t
CROSS APPLY (SELECT DATEADD(MINUTE, -(CAST(POWER(t.r1 % 1000 / 1000.0, 1.6) * 90 AS INT) * 1440 + 90 + t.r2 % 1200), t.Salida) AS e0) p
CROSS APPLY (SELECT CASE WHEN p.e0 < @S THEN DATEADD(MINUTE, t.r3 % 100000, @S)
                         WHEN p.e0 > DATEADD(DAY, -1, @Ahora) THEN DATEADD(MINUTE, -(1440 + t.r3 % (7 * 1440)), @Ahora)
                         ELSE p.e0 END AS Emision) e;

SELECT t.*,
       CASE WHEN t.r5 % 100 < 3 THEN NULL ELSE 1 + t.r6 % cc.Cnt END AS ClienteID
INTO #T0
FROM #T01 t JOIN #CumCli cc ON cc.Fecha = CAST(t.Emision AS DATE);

-- Etapa 3: pasajero, descuento, estado, metodo de pago y numero de tiquete
DECLARE @idEarly INT = (SELECT DescuentoID FROM dbo.Descuentos WHERE CodigoDescuento = 'EARLYBIRD');
DECLARE @idEstu  INT = (SELECT DescuentoID FROM dbo.Descuentos WHERE CodigoDescuento = 'ESTUDIANTE');
DECLARE @idMayor INT = (SELECT DescuentoID FROM dbo.Descuentos WHERE CodigoDescuento = 'ADULTOMAYOR');
DECLARE @idFidel INT = (SELECT DescuentoID FROM dbo.Descuentos WHERE CodigoDescuento = 'FIDELIDAD');

SELECT ROW_NUMBER() OVER (ORDER BY t.Emision, t.VueloID, t.AsientoID) AS Seq,
       t.*,
       '045' + RIGHT('0000000000' + CAST(ROW_NUMBER() OVER (ORDER BY t.Emision, t.VueloID, t.AsientoID) AS VARCHAR(10)), 10) AS NumeroTiquete,
       CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85 THEN c.Nombres   ELSE pn.nombre   END AS PasNombre,
       CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85 THEN c.Apellidos ELSE pa.apellido END AS PasApellido,
       CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85 THEN c.NumeroDocumento
            ELSE CAST(900000000 + t.r9 % 99999999 AS VARCHAR(30)) END AS PasDoc,
       CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85 THEN 1 ELSE 0 END AS EsCliente,
       CASE WHEN t.EstadoVuelo = 'Cancelado' THEN 'Cancelado'
            WHEN t.Salida <= @Ahora THEN CASE WHEN t.r4 % 100 < 4 THEN 'No Presentado'
                                              WHEN t.r4 % 100 < 7 THEN 'Cancelado' ELSE 'Abordado' END
            ELSE CASE WHEN t.r4 % 100 < 3 THEN 'Cancelado'
                      WHEN t.r4 % 100 < 8 AND t.Salida > DATEADD(DAY, 3, @Ahora) THEN 'Reservado'
                      ELSE 'Emitido' END END AS EstadoTiq,
       CASE WHEN m.CodigoMoneda = 'COP'
            THEN CASE WHEN t.r10 % 100 < 40 THEN 'Tarjeta de Credito' WHEN t.r10 % 100 < 60 THEN 'Tarjeta de Debito'
                      WHEN t.r10 % 100 < 85 THEN 'PSE' WHEN t.r10 % 100 < 95 THEN 'Transferencia Bancaria' ELSE 'Efectivo' END
            ELSE CASE WHEN t.r10 % 100 < 60 THEN 'Tarjeta de Credito' WHEN t.r10 % 100 < 85 THEN 'Tarjeta de Debito'
                      WHEN t.r10 % 100 < 97 THEN 'PayPal' ELSE 'Transferencia Bancaria' END END AS MetodoNom,
       m.CodigoMoneda,
       COALESCE(
         CASE WHEN t.r11 % 100 < 55 THEN s.DescuentoID END,
         CASE WHEN t.r11 % 100 < 80 THEN
              CASE t.r7 % 4
                WHEN 0 THEN CASE WHEN DATEDIFF(DAY, t.Emision, t.Salida) >= 45 THEN @idEarly END
                WHEN 1 THEN CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85
                                  AND DATEDIFF(YEAR, c.FechaNacimiento, CAST(t.Salida AS DATE)) <= 28 THEN @idEstu END
                WHEN 2 THEN CASE WHEN c.ClienteID IS NOT NULL AND t.r8 % 100 < 85
                                  AND DATEDIFF(YEAR, c.FechaNacimiento, CAST(t.Salida AS DATE)) >= 60 THEN @idMayor END
                ELSE CASE WHEN c.ClienteID IS NOT NULL THEN @idFidel END END
         END) AS DescuentoID
INTO #T1
FROM #T0 t
LEFT JOIN dbo.Clientes c ON c.ClienteID = t.ClienteID
JOIN #Nom pn ON pn.id = 1 + t.r7 % 40
JOIN #Ape pa ON pa.id = 1 + t.r9 % 40
JOIN dbo.Monedas m ON m.MonedaID = t.MonedaID
OUTER APPLY (SELECT TOP 1 d.DescuentoID FROM dbo.Descuentos d
             WHERE d.CodigoDescuento LIKE 'TEMP-%'
               AND CAST(t.Emision AS DATE) BETWEEN d.FechaInicio AND d.FechaFin) s;

INSERT dbo.Tiquetes (VueloID, ClienteID, AsientoID, EstadoTiqueteID, NumeroTiquete, NombrePasajero, ApellidoPasajero,
                     DocumentoPasajero, FechaEmision, PrecioBase, MonedaID)
SELECT t.VueloID, t.ClienteID, t.AsientoID, et.EstadoTiqueteID, t.NumeroTiquete, t.PasNombre, t.PasApellido,
       t.PasDoc, t.Emision, t.PrecioBase, t.MonedaID
FROM #T1 t JOIN dbo.EstadosTiquete et ON et.Descripcion = t.EstadoTiq
ORDER BY t.Seq;

SELECT tq.TiqueteID, t.*
INTO #TT
FROM #T1 t JOIN dbo.Tiquetes tq ON tq.NumeroTiquete = t.NumeroTiquete;

-- DESCUENTOS APLICADOS ---------------------------------------------------------------------
INSERT dbo.TiqueteDescuento (TiqueteID, DescuentoID, PorcentajeAplicado, MontoDescuento)
SELECT t.TiqueteID, d.DescuentoID, d.Porcentaje, ROUND(t.PrecioBase * d.Porcentaje / 100.0, 2)
FROM #TT t JOIN dbo.Descuentos d ON d.DescuentoID = t.DescuentoID
ORDER BY t.TiqueteID;

-- PAGOS ------------------------------------------------------------------------------------
-- Monto neto = precio base - descuento. Un pago por tiquete (Pendiente si esta Reservado),
-- reembolso para cancelados y ~2% con un intento previo rechazado.
SELECT t.TiqueteID, t.Emision, t.Salida, t.EstadoTiq, t.MonedaID, mp.MetodoPagoID, t.r1, t.r5, t.r6,
       ROUND(t.PrecioBase - ISNULL(td.MontoDescuento, 0), 2) AS Neto,
       DATEADD(SECOND, 180 + t.r2 % 600, t.Emision) AS FechaPago
INTO #PG
FROM #TT t
JOIN dbo.MetodosPago mp ON mp.NombreMetodo = t.MetodoNom
LEFT JOIN dbo.TiqueteDescuento td ON td.TiqueteID = t.TiqueteID;

INSERT dbo.Pagos (TiqueteID, MetodoPagoID, MonedaID, FechaPago, Monto, ReferenciaTransaccion, EstadoPago)
SELECT TiqueteID, MetodoPagoID, MonedaID, FechaPago, Monto, Ref, Estado
FROM (
   SELECT g.TiqueteID, g.MetodoPagoID, g.MonedaID, g.FechaPago, g.Neto AS Monto,
          CASE WHEN g.EstadoTiq = 'Reservado' THEN NULL
               ELSE 'TRX' + RIGHT(REPLACE(CAST(NEWID() AS CHAR(36)), '-', ''), 14) END AS Ref,
          CASE WHEN g.EstadoTiq = 'Reservado' THEN 'Pendiente' ELSE 'Aprobado' END AS Estado
   FROM #PG g
   UNION ALL
   SELECT g.TiqueteID, g.MetodoPagoID, g.MonedaID,
          CASE WHEN dr.f > @Ahora THEN @Ahora WHEN dr.f < g.FechaPago THEN g.FechaPago ELSE dr.f END,
          g.Neto, 'RFN' + RIGHT(REPLACE(CAST(NEWID() AS CHAR(36)), '-', ''), 14), 'Reembolsado'
   FROM #PG g
   CROSS APPLY (SELECT DATEADD(MINUTE, 30 + g.r5 % (DATEDIFF(MINUTE, g.Emision, g.Salida) / 2 + 1), g.FechaPago) AS f) dr
   WHERE g.EstadoTiq = 'Cancelado'
   UNION ALL
   SELECT g.TiqueteID, (SELECT MetodoPagoID FROM dbo.MetodosPago WHERE NombreMetodo = 'Tarjeta de Credito'),
          g.MonedaID, DATEADD(SECOND, -(60 + g.r6 % 60), g.FechaPago), g.Neto,
          'TRX' + RIGHT(REPLACE(CAST(NEWID() AS CHAR(36)), '-', ''), 14), 'Rechazado'
   FROM #PG g WHERE g.EstadoTiq <> 'Reservado' AND g.r1 % 100 < 2
) p
ORDER BY FechaPago, TiqueteID;

-- EQUIPAJE ---------------------------------------------------------------------------------
-- Solo tiquetes Abordados o Emitidos (vuelos futuros con equipaje prepagado)
INSERT dbo.Equipaje (TiqueteID, TipoEquipajeID, PesoKg, Costo)
SELECT q.TiqueteID, te.TipoEquipajeID, q.Peso, q.Costo
FROM (
   -- equipaje de mano (75%)
   SELECT t.TiqueteID, 'Equipaje de mano' AS Tipo, CAST(4 + (t.r1 % 70) / 10.0 AS DECIMAL(6,2)) AS Peso, CAST(0 AS DECIMAL(12,2)) AS Costo
   FROM #TT t WHERE t.EstadoTiq IN ('Abordado','Emitido') AND t.r1 % 100 < 75
   UNION ALL
   -- equipaje de bodega (40%)
   SELECT t.TiqueteID, 'Equipaje de bodega', CAST(10 + (t.r2 % 2200) / 100.0 AS DECIMAL(6,2)),
          CASE WHEN t.CodigoMoneda = 'COP' THEN 65000 ELSE 35 END
   FROM #TT t WHERE t.EstadoTiq IN ('Abordado','Emitido') AND t.r2 % 100 < 40
   UNION ALL
   -- segunda maleta de bodega (8%)
   SELECT t.TiqueteID, 'Equipaje de bodega', CAST(10 + (t.r3 % 2200) / 100.0 AS DECIMAL(6,2)),
          CASE WHEN t.CodigoMoneda = 'COP' THEN 65000 ELSE 35 END
   FROM #TT t WHERE t.EstadoTiq IN ('Abordado','Emitido') AND t.r2 % 100 < 40 AND t.r3 % 100 < 20
   UNION ALL
   -- equipaje especial (6.5%)
   SELECT t.TiqueteID,
          CHOOSE(1 + t.r4 % 3, 'Equipo deportivo', 'Mascota', 'Instrumento musical'),
          CAST(3 + (t.r5 % 2500) / 100.0 AS DECIMAL(6,2)),
          CASE t.r4 % 3 WHEN 0 THEN CASE WHEN t.CodigoMoneda = 'COP' THEN 90000 ELSE 60 END
                        WHEN 1 THEN CASE WHEN t.CodigoMoneda = 'COP' THEN 120000 ELSE 100 END
                        ELSE CASE WHEN t.CodigoMoneda = 'COP' THEN 80000 ELSE 50 END END
   FROM #TT t WHERE t.EstadoTiq IN ('Abordado','Emitido') AND t.r6 % 1000 < 65
) q
JOIN dbo.TiposEquipaje te ON te.NombreTipo = q.Tipo
ORDER BY q.TiqueteID;

COMMIT TRAN;

-- RESUMEN Y VERIFICACION ---------------------------------------------------------------------
SELECT 'Paises' AS Tabla, COUNT(*) AS Registros FROM dbo.Paises UNION ALL
SELECT 'Localizaciones', COUNT(*) FROM dbo.Localizaciones UNION ALL
SELECT 'Clientes', COUNT(*) FROM dbo.Clientes UNION ALL
SELECT 'Empleados', COUNT(*) FROM dbo.Empleados UNION ALL
SELECT 'Rutas', COUNT(*) FROM dbo.Rutas UNION ALL
SELECT 'HorariosRuta', COUNT(*) FROM dbo.HorariosRuta UNION ALL
SELECT 'Aviones', COUNT(*) FROM dbo.Aviones UNION ALL
SELECT 'Cabinas', COUNT(*) FROM dbo.Cabinas UNION ALL
SELECT 'Asientos', COUNT(*) FROM dbo.Asientos UNION ALL
SELECT 'Vuelos', COUNT(*) FROM dbo.Vuelos UNION ALL
SELECT 'PreciosRutaCabina', COUNT(*) FROM dbo.PreciosRutaCabina UNION ALL
SELECT 'Descuentos', COUNT(*) FROM dbo.Descuentos UNION ALL
SELECT 'Tiquetes', COUNT(*) FROM dbo.Tiquetes UNION ALL
SELECT 'TiqueteDescuento', COUNT(*) FROM dbo.TiqueteDescuento UNION ALL
SELECT 'Pagos', COUNT(*) FROM dbo.Pagos UNION ALL
SELECT 'Equipaje', COUNT(*) FROM dbo.Equipaje UNION ALL
SELECT 'EmpleadoVuelo', COUNT(*) FROM dbo.EmpleadoVuelo;

SELECT 'Tiquete antes del registro del cliente' AS Control, COUNT(*) AS Incidencias
FROM dbo.Tiquetes t JOIN dbo.Clientes c ON c.ClienteID = t.ClienteID WHERE t.FechaEmision < c.FechaRegistro
UNION ALL SELECT 'Emision >= salida del vuelo', COUNT(*)
FROM dbo.Tiquetes t JOIN dbo.Vuelos v ON v.VueloID = t.VueloID WHERE t.FechaEmision >= v.FechaHoraSalida
UNION ALL SELECT 'Asiento de otro avion', COUNT(*)
FROM dbo.Tiquetes t JOIN dbo.Vuelos v ON v.VueloID = t.VueloID
JOIN dbo.Asientos s ON s.AsientoID = t.AsientoID JOIN dbo.Cabinas c ON c.CabinaID = s.CabinaID WHERE c.AvionID <> v.AvionID
UNION ALL SELECT 'Capacidad avion <> suma cabinas', COUNT(*)
FROM dbo.Aviones a WHERE a.Capacidad <> (SELECT SUM(Capacidad) FROM dbo.Cabinas WHERE AvionID = a.AvionID)
UNION ALL SELECT 'Capacidad cabina <> asientos', COUNT(*)
FROM dbo.Cabinas c WHERE c.Capacidad <> (SELECT COUNT(*) FROM dbo.Asientos WHERE CabinaID = c.CabinaID)
UNION ALL SELECT 'Vuelos de un avion traslapados', COUNT(*)
FROM dbo.Vuelos a JOIN dbo.Vuelos b ON a.AvionID = b.AvionID AND a.VueloID < b.VueloID
 AND a.FechaHoraSalida < b.FechaHoraLlegada AND b.FechaHoraSalida < a.FechaHoraLlegada
 AND CAST(a.FechaHoraSalida AS DATE) = CAST(b.FechaHoraSalida AS DATE)
UNION ALL SELECT 'Pago aprobado <> precio neto', COUNT(*)
FROM dbo.Pagos p JOIN dbo.Tiquetes t ON t.TiqueteID = p.TiqueteID
LEFT JOIN dbo.TiqueteDescuento d ON d.TiqueteID = t.TiqueteID
WHERE p.EstadoPago = 'Aprobado' AND p.Monto <> t.PrecioBase - ISNULL(d.MontoDescuento, 0)
UNION ALL SELECT 'Pagos con fecha futura', COUNT(*) FROM dbo.Pagos WHERE FechaPago > SYSDATETIME();


-----------
/**************************
	Stored Procedures
****************************/

USE AEROSKYBD
GO

IF OBJECT_ID('dbo.usp_ConsultarIngresosRuta', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarIngresosRuta;
GO
/*

Objetivo:		Lista las Rutas más rentables.
Sintaxis de Ejemplo:

	EXEC dbo.usp_ConsultarIngresosRuta;

*/
CREATE PROCEDURE dbo.usp_ConsultarIngresosRuta
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        R.CodigoRuta,
        LO.Ciudad AS CiudadOrigen,
        LD.Ciudad AS CiudadDestino,
        COUNT(P.PagoID) AS CantidadPagos,
		CONVERT(DECIMAL(18,2), SUM(P.Monto * TC.ValorEnSoles)) AS IngresosTotalesSoles
    FROM dbo.Pagos P
        INNER JOIN dbo.Tiquetes T
            ON P.TiqueteID = T.TiqueteID
        INNER JOIN dbo.Vuelos V
            ON T.VueloID = V.VueloID
        INNER JOIN dbo.Rutas R
            ON V.RutaID = R.RutaID
        INNER JOIN dbo.Localizaciones LO
            ON R.LocalizacionOrigenID = LO.LocalizacionID
        INNER JOIN dbo.Localizaciones LD
            ON R.LocalizacionDestinoID = LD.LocalizacionID
        INNER JOIN dbo.TipoCambio TC
            ON P.MonedaID = TC.MonedaID
    WHERE P.EstadoPago = 'Aprobado'
    GROUP BY R.CodigoRuta, LO.Ciudad, LD.Ciudad
    ORDER BY IngresosTotalesSoles DESC;
END
GO

IF OBJECT_ID('dbo.usp_RutasMasPopulares', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_RutasMasPopulares;
GO
/*

Objetivo:		Lista las rutas con mayor número de pasajeros.
Sintaxis de Ejemplo:

	EXEC dbo.usp_RutasMasPopulares;

*/
CREATE PROCEDURE dbo.usp_RutasMasPopulares
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.CodigoRuta,
        LO.Ciudad AS Origen,
        LD.Ciudad AS Destino,
        COUNT(T.TiqueteID) AS CantidadPasajeros
    FROM dbo.Tiquetes T
        INNER JOIN dbo.Vuelos V
            ON T.VueloID = V.VueloID
        INNER JOIN dbo.Rutas R
            ON V.RutaID = R.RutaID
        INNER JOIN dbo.Localizaciones LO
            ON R.LocalizacionOrigenID = LO.LocalizacionID
        INNER JOIN dbo.Localizaciones LD
            ON R.LocalizacionDestinoID = LD.LocalizacionID
    WHERE T.EstadoTiqueteID <>
        (SELECT EstadoTiqueteID
         FROM EstadosTiquete
         WHERE Descripcion='Cancelado')
    GROUP BY
        R.CodigoRuta,
        LO.Ciudad,
        LD.Ciudad
    ORDER BY CantidadPasajeros DESC;
END
GO

IF OBJECT_ID('dbo.usp_RutasMenosPopulares', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_RutasMenosPopulares;
GO
/*

Objetivo:		Lista las rutas con menor número de pasajeros.
Sintaxis de Ejemplo:

	EXEC dbo.usp_RutasMenosPopulares;

*/
CREATE PROCEDURE dbo.usp_RutasMenosPopulares
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.CodigoRuta,
        LO.Ciudad AS Origen,
        LD.Ciudad AS Destino,
        COUNT(T.TiqueteID) AS CantidadPasajeros
    FROM dbo.Tiquetes T
        INNER JOIN dbo.Vuelos V ON T.VueloID = V.VueloID
        INNER JOIN dbo.Rutas R ON V.RutaID = R.RutaID
        INNER JOIN dbo.Localizaciones LO
            ON R.LocalizacionOrigenID = LO.LocalizacionID
        INNER JOIN dbo.Localizaciones LD
            ON R.LocalizacionDestinoID = LD.LocalizacionID
    GROUP BY
        R.CodigoRuta,
        LO.Ciudad,
        LD.Ciudad
    ORDER BY CantidadPasajeros ASC;
END
GO


IF OBJECT_ID('dbo.usp_VuelosMasVendidos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_VuelosMasVendidos;
GO
/*

Objetivo:		Lista los vuelos más vendidos incluyendo la fecha.
Sintaxis de Ejemplo:

	EXEC dbo.usp_VuelosMasVendidos;

*/
CREATE PROCEDURE dbo.usp_VuelosMasVendidos
AS
BEGIN
    SELECT
        V.CodigoVuelo,
        V.FechaHoraSalida,
        COUNT(T.TiqueteID) AS BoletosVendidos
    FROM dbo.Vuelos V
        INNER JOIN dbo.Tiquetes T
            ON V.VueloID = T.VueloID
    GROUP BY
        V.CodigoVuelo,
        V.FechaHoraSalida
    ORDER BY BoletosVendidos DESC,FechaHoraSalida DESC;
END
GO


IF OBJECT_ID('dbo.usp_FacturacionMensual', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_FacturacionMensual;
GO
/*

Objetivo:		Meses con mayor facturación.
Sintaxis de Ejemplo:

	EXEC dbo.usp_FacturacionMensual;

*/
CREATE PROCEDURE dbo.usp_FacturacionMensual
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(P.FechaPago) AS Anio,
        MONTH(P.FechaPago) AS Mes,
        DATENAME(MONTH, P.FechaPago) AS NombreMes,

        COUNT(P.PagoID) AS CantidadPagos,

        CONVERT(
            DECIMAL(18,2),
            SUM(P.Monto * TC.ValorEnSoles)
        ) AS FacturacionSoles

    FROM dbo.Pagos P
        INNER JOIN dbo.TipoCambio TC
            ON P.MonedaID = TC.MonedaID

    WHERE P.EstadoPago = 'Aprobado'

    GROUP BY
        YEAR(P.FechaPago),
        MONTH(P.FechaPago),
        DATENAME(MONTH,P.FechaPago)

    ORDER BY 1, FacturacionSoles DESC;
END
GO

IF OBJECT_ID('dbo.usp_TipoAnticipacionCompra', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_TipoAnticipacionCompra;
GO
/*

Objetivo:		Clasificacion de anticipacion de compra de los clientes.
Sintaxis de Ejemplo:

	EXEC dbo.usp_TipoAnticipacionCompra;

*/
CREATE PROCEDURE dbo.usp_TipoAnticipacionCompra
AS
BEGIN
    SELECT
        CASE
            WHEN DATEDIFF(DAY,T.FechaEmision,V.FechaHoraSalida) <= 7
                THEN 'Ultima Semana'
            WHEN DATEDIFF(DAY,T.FechaEmision,V.FechaHoraSalida) <= 30
                THEN '1 Mes'
            ELSE 'Mas de 30 Dias'
        END Categoria,
        COUNT(*) Cantidad
    FROM dbo.Tiquetes T
        INNER JOIN dbo.Vuelos V
            ON T.VueloID = V.VueloID
    GROUP BY
        CASE
            WHEN DATEDIFF(DAY,T.FechaEmision,V.FechaHoraSalida) <= 7
                THEN 'Ultima Semana'
            WHEN DATEDIFF(DAY,T.FechaEmision,V.FechaHoraSalida) <= 30
                THEN '1 Mes'
            ELSE 'Mas de 30 Dias'
        END;
END
GO

IF OBJECT_ID('dbo.usp_VuelosCanceladosHorario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_VuelosCanceladosHorario;
GO
/*

Objetivo:		Cantidad de vuelos cancelados segun horario de salida.
Sintaxis de Ejemplo:

	EXEC dbo.usp_VuelosCanceladosHorario;

*/
CREATE PROCEDURE dbo.usp_VuelosCanceladosHorario
AS
BEGIN
    SELECT
        CASE
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 0 AND 5
                THEN 'Madrugada'
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 6 AND 11
                THEN 'Mañana'
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 12 AND 17
                THEN 'Tarde'
            ELSE 'Noche'
        END Horario,
        COUNT(*) Cancelados
    FROM dbo.Vuelos V
        INNER JOIN dbo.EstadosVuelo EV
            ON V.EstadoVueloID = EV.EstadoVueloID
    WHERE EV.Descripcion='Cancelado'
    GROUP BY
        CASE
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 0 AND 5
                THEN 'Madrugada'
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 6 AND 11
                THEN 'Mañana'
            WHEN DATEPART(HOUR,FechaHoraSalida) BETWEEN 12 AND 17
                THEN 'Tarde'
            ELSE 'Noche'
        END;
END
GO

IF OBJECT_ID('dbo.usp_OcupacionAviones', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_OcupacionAviones;
GO
/*

Objetivo:		Boletos vendidos por tipo de avión y porcentaje de ocupación
Sintaxis de Ejemplo:

	EXEC dbo.usp_OcupacionAviones;

*/
CREATE PROCEDURE dbo.usp_OcupacionAviones
AS
BEGIN
    SELECT
        A.Modelo,
        A.Capacidad,
        COUNT(T.TiqueteID) AS BoletosVendidos,
        CAST(
            COUNT(T.TiqueteID) * 100.0 /
            NULLIF(A.Capacidad,0)
            AS DECIMAL(18,2)
        ) AS PorcentajeOcupacion
    FROM dbo.Aviones A
        INNER JOIN dbo.Vuelos V
            ON A.AvionID = V.AvionID
        INNER JOIN dbo.Tiquetes T
            ON V.VueloID = T.VueloID
    GROUP BY
        A.Modelo,
        A.Capacidad
    ORDER BY PorcentajeOcupacion DESC;
END
GO
IF OBJECT_ID('dbo.usp_MetodoPagoMasUsado', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_MetodoPagoMasUsado;
GO
/*

Objetivo:		Método de pago más utilizado.
Sintaxis de Ejemplo:

	EXEC dbo.usp_MetodoPagoMasUsado;

*/
CREATE OR ALTER PROCEDURE dbo.usp_MetodoPagoMasUsado
AS
BEGIN
    SELECT
        MP.NombreMetodo,
        COUNT(*) CantidadUsos
    FROM dbo.Pagos P
        INNER JOIN dbo.MetodosPago MP
            ON P.MetodoPagoID = MP.MetodoPagoID
    GROUP BY MP.NombreMetodo
    ORDER BY CantidadUsos DESC;
END
GO

IF OBJECT_ID('dbo.usp_PasajerosFrecuentes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PasajerosFrecuentes;
GO
/*

Objetivo:		Lista los pasajeros más frecuentes.
Sintaxis de Ejemplo:

	EXEC dbo.usp_PasajerosFrecuentes;

*/

CREATE PROCEDURE dbo.usp_PasajerosFrecuentes
AS
BEGIN
    SELECT TOP 20
        C.ClienteID,
        C.Nombres,
        C.Apellidos,
        COUNT(T.TiqueteID) AS TotalViajes
    FROM dbo.Clientes C
        INNER JOIN dbo.Tiquetes T
            ON C.ClienteID = T.ClienteID
    GROUP BY
        C.ClienteID,
        C.Nombres,
        C.Apellidos
    ORDER BY TotalViajes DESC;
END
GO