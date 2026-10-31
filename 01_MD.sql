
USE AEROSKYBD;
GO

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
