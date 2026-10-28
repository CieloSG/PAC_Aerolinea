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

/*==============================================================
  PROYECTO: AEROSKY
  OBJETIVO: Insertar datos iniciales en tablas maestras
==============================================================*/

-- 1. Países
INSERT INTO dbo.Paises
    (CodigoPais, NombrePais)
VALUES
    ('US', 'Estados Unidos'),
    ('PE', 'Peru'),
    ('CA', 'Canada');

-- 2. Géneros
INSERT INTO dbo.Generos
    (Descripcion)
VALUES
    ('Masculino'),
    ('Femenino'),
    ('No especificado');

-- 3. Tipos de documento
INSERT INTO dbo.TiposDocumento
    (NombreTipo)
VALUES
    ('Pasaporte'),
    ('Documento nacional de identidad'),
    ('Licencia de conducir');

-- 4. Estados de clientes
INSERT INTO dbo.EstadosCliente
    (Descripcion)
VALUES
    ('Activo'),
    ('Inactivo'),
    ('Suspendido');

-- 5. Cargos
INSERT INTO dbo.Cargos
    (NombreCargo)
VALUES
    ('Piloto'),
    ('Copiloto'),
    ('Tripulante de cabina'),
    ('Personal de tierra'),
    ('Supervisor');

-- 6. Métodos de pago
INSERT INTO dbo.MetodosPago
    (NombreMetodo)
VALUES
    ('Tarjeta de crédito'),
    ('Tarjeta de débito'),
    ('Transferencia bancaria');

-- 7. Monedas
INSERT INTO dbo.Monedas
    (CodigoMoneda, NombreMoneda)
VALUES
    ('USD', 'Dolar estadounidense'),
    ('PEN', 'Sol peruano'),
    ('CAD', 'Dolar canadiense');

-- 8. Estados de vuelo
INSERT INTO dbo.EstadosVuelo
    (Descripcion)
VALUES
    ('Programado'),
    ('En curso'),
    ('Finalizado'),
    ('Cancelado'),
    ('Retrasado');

-- 9. Estados de tiquete
INSERT INTO dbo.EstadosTiquete
    (Descripcion)
VALUES
    ('Reservado'),
    ('Pagado'),
    ('Cancelado'),
    ('Utilizado');

-- 10. Tipos de equipaje
INSERT INTO dbo.TiposEquipaje
    (NombreTipo)
VALUES
    ('Equipaje de mano'),
    ('Equipaje facturado'),
    ('Equipaje especial');

GO

/*==============================================================
  PROYECTO: AEROSKY
  OBJETIVO: Insertar datos GENERALES
 ==============================================================*/

-- 1. Aeropuertos y localizaciones
INSERT INTO dbo.Localizaciones
    (PaisID, CodigoAeropuerto, NombreAeropuerto, Ciudad)
VALUES
    ((SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
     'JFK', 'John F. Kennedy International Airport', 'New York'),

    ((SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
     'LAX', 'Los Angeles International Airport', 'Los Angeles'),

    ((SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
     'MIA', 'Miami International Airport', 'Miami'),

    ((SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'PE'),
     'LIM', 'Aeropuerto Internacional Jorge Chavez', 'Lima'),

    ((SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'CA'),
     'YYZ', 'Toronto Pearson International Airport', 'Toronto');
GO
-- 2. Clientes de ejemplo
INSERT INTO dbo.Clientes
    (TipoDocumentoID, EstadoClienteID, GeneroID, PaisID,
     NumeroDocumento, Nombres, Apellidos, FechaNacimiento,
     Correo, Telefono)
VALUES
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT EstadoClienteID FROM dbo.EstadosCliente
     WHERE Descripcion = 'Activo'),
    (SELECT GeneroID FROM dbo.Generos
     WHERE Descripcion = 'Masculino'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
    'AS100001', 'James', 'Miller', '1995-04-12',
    'james.miller@example.com', '5551001001'
),
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT EstadoClienteID FROM dbo.EstadosCliente
     WHERE Descripcion = 'Activo'),
    (SELECT GeneroID FROM dbo.Generos
     WHERE Descripcion = 'Femenino'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'PE'),
    'AS100002', 'Lucia', 'Torres', '1998-09-20',
    'lucia.torres@example.com', '5551001002'
),
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT EstadoClienteID FROM dbo.EstadosCliente
     WHERE Descripcion = 'Activo'),
    (SELECT GeneroID FROM dbo.Generos
     WHERE Descripcion = 'Femenino'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'CA'),
    'AS100003', 'Emma', 'Wilson', '1992-01-15',
    'emma.wilson@example.com', '5551001003'
);
GO
-- 3. Empleados de AeroSky
INSERT INTO dbo.Empleados
    (TipoDocumentoID, CargoID, PaisID, NumeroDocumento,
     Nombres, Apellidos, Correo, Telefono, FechaContratacion, Activo)
VALUES
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT CargoID FROM dbo.Cargos WHERE NombreCargo = 'Piloto'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
    'EMP1001', 'Michael', 'Johnson',
    'michael.johnson@example.com', '5552001001',
    '2024-01-15', 1
),
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT CargoID FROM dbo.Cargos
     WHERE NombreCargo = 'Copiloto'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'US'),
    'EMP1002', 'Daniel', 'Smith',
    'daniel.smith@example.com', '5552001002',
    '2024-03-10', 1
),
(
    (SELECT TipoDocumentoID FROM dbo.TiposDocumento
     WHERE NombreTipo = 'Pasaporte'),
    (SELECT CargoID FROM dbo.Cargos
     WHERE NombreCargo = 'Tripulante de cabina'),
    (SELECT PaisID FROM dbo.Paises WHERE CodigoPais = 'CA'),
    'EMP1003', 'Sofia', 'Brown',
    'sofia.brown@example.com', '5552001003',
    '2025-02-01', 1
);
GO
-- 4. Flota de AeroSky
INSERT INTO dbo.Aviones
    (Fabricante, Modelo, Matricula, Capacidad, Activo)
VALUES
    ('Boeing', '737-800', 'N701AS', 180, 1),
    ('Airbus', 'A320neo', 'N702AS', 186, 1),
    ('Boeing', '787-9', 'N703AS', 290, 1);
GO

-- 5. Rutas de AeroSky
INSERT INTO dbo.Rutas
    (LocalizacionOrigenID, LocalizacionDestinoID, CodigoRuta, Activa)
VALUES
(
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'JFK'),
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'LAX'),
    'AS001', 1
),
(
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'JFK'),
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'MIA'),
    'AS002', 1
),
(
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'LIM'),
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'JFK'),
    'AS003', 1
),
(
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'LAX'),
    (SELECT LocalizacionID FROM dbo.Localizaciones
     WHERE CodigoAeropuerto = 'YYZ'),
    'AS004', 1
);
GO
-- 6. Horarios de rutas
INSERT INTO dbo.HorariosRuta
    (RutaID, DiaSemana, HoraSalida, DuracionMinutos)
VALUES
    ((SELECT RutaID FROM dbo.Rutas WHERE CodigoRuta = 'AS001'),
     1, '08:00', 360),

    ((SELECT RutaID FROM dbo.Rutas WHERE CodigoRuta = 'AS001'),
     4, '08:00', 360),

    ((SELECT RutaID FROM dbo.Rutas WHERE CodigoRuta = 'AS002'),
     2, '10:30', 180),

    ((SELECT RutaID FROM dbo.Rutas WHERE CodigoRuta = 'AS003'),
     5, '22:00', 480),

    ((SELECT RutaID FROM dbo.Rutas WHERE CodigoRuta = 'AS004'),
     7, '14:00', 300);
GO
-- VALIDACION
SELECT
    R.CodigoRuta,
    O.CodigoAeropuerto AS AeropuertoOrigen,
    O.Ciudad AS CiudadOrigen,
    D.CodigoAeropuerto AS AeropuertoDestino,
    D.Ciudad AS CiudadDestino,
    R.Activa
FROM dbo.Rutas R
INNER JOIN dbo.Localizaciones O
    ON R.LocalizacionOrigenID = O.LocalizacionID
INNER JOIN dbo.Localizaciones D
    ON R.LocalizacionDestinoID = D.LocalizacionID
ORDER BY R.CodigoRuta;
GO

-- Registrar cabinas de los aviones

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Economica', 150
FROM dbo.Aviones
WHERE Matricula = 'N701AS';

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Ejecutiva', 30
FROM dbo.Aviones
WHERE Matricula = 'N701AS';

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Economica', 156
FROM dbo.Aviones
WHERE Matricula = 'N702AS';

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Ejecutiva', 30
FROM dbo.Aviones
WHERE Matricula = 'N702AS';

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Economica', 250
FROM dbo.Aviones
WHERE Matricula = 'N703AS';

INSERT INTO dbo.Cabinas (AvionID, NombreCabina, Capacidad)
SELECT AvionID, 'Ejecutiva', 40
FROM dbo.Aviones
WHERE Matricula = 'N703AS';
GO

-- VALIDACION
SELECT
    A.Matricula,
    A.Modelo,
    C.CabinaID,
    C.NombreCabina,
    C.Capacidad
FROM dbo.Cabinas C
INNER JOIN dbo.Aviones A
    ON C.AvionID = A.AvionID
ORDER BY A.Matricula, C.NombreCabina;
GO

--Asientos
;WITH Numeros AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects A
    CROSS JOIN sys.all_objects B
),
AsientosGenerados AS (
    SELECT
        C.CabinaID,
        CASE
            WHEN C.NombreCabina = 'Economica' THEN 'E'
            WHEN C.NombreCabina = 'Ejecutiva' THEN 'J'
            ELSE 'A'
        END + RIGHT('000' + CAST(N.N AS VARCHAR(3)), 3) AS NumeroAsiento
    FROM dbo.Cabinas C
    INNER JOIN Numeros N
        ON N.N <= C.Capacidad
)
INSERT INTO dbo.Asientos (CabinaID, NumeroAsiento)
SELECT AG.CabinaID, AG.NumeroAsiento
FROM AsientosGenerados AG
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Asientos A
    WHERE A.CabinaID = AG.CabinaID
      AND A.NumeroAsiento = AG.NumeroAsiento
);
GO
--VALIDACION
SELECT
    AV.Matricula,
    AV.Modelo,
    C.NombreCabina,
    COUNT(A.AsientoID) AS TotalAsientos
FROM dbo.Aviones AV
INNER JOIN dbo.Cabinas C
    ON AV.AvionID = C.AvionID
LEFT JOIN dbo.Asientos A
    ON C.CabinaID = A.CabinaID
GROUP BY AV.Matricula, AV.Modelo, C.NombreCabina
ORDER BY AV.Matricula, C.NombreCabina;
GO
--VUELOS

;WITH VuelosNuevos AS (
    SELECT *
    FROM (VALUES
        ('AS001', 'N701AS', 'AS1001',
         CAST('2026-11-02T08:00:00' AS DATETIME2), 1),

        ('AS001', 'N701AS', 'AS1002',
         CAST('2026-11-05T08:00:00' AS DATETIME2), 4),

        ('AS002', 'N702AS', 'AS1003',
         CAST('2026-11-03T10:30:00' AS DATETIME2), 2),

        ('AS003', 'N703AS', 'AS1004',
         CAST('2026-11-06T22:00:00' AS DATETIME2), 5),

        ('AS004', 'N702AS', 'AS1005',
         CAST('2026-11-01T14:00:00' AS DATETIME2), 7)
    ) AS V(CodigoRuta, Matricula, CodigoVuelo,
           FechaHoraSalida, DiaSemana)
)
INSERT INTO dbo.Vuelos (
    RutaID,
    AvionID,
    EstadoVueloID,
    CodigoVuelo,
    FechaHoraSalida,
    FechaHoraLlegada
)
SELECT
    R.RutaID,
    A.AvionID,
    EV.EstadoVueloID,
    VN.CodigoVuelo,
    VN.FechaHoraSalida,
    DATEADD(MINUTE, HR.DuracionMinutos, VN.FechaHoraSalida)
FROM VuelosNuevos VN
INNER JOIN dbo.Rutas R
    ON R.CodigoRuta = VN.CodigoRuta
INNER JOIN dbo.Aviones A
    ON A.Matricula = VN.Matricula
INNER JOIN dbo.HorariosRuta HR
    ON HR.RutaID = R.RutaID
    AND HR.DiaSemana = VN.DiaSemana
    AND HR.HoraSalida = CAST(VN.FechaHoraSalida AS TIME)
INNER JOIN dbo.EstadosVuelo EV
    ON EV.Descripcion = 'Programado'
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Vuelos V
    WHERE V.CodigoVuelo = VN.CodigoVuelo
);
GO

--validacion
SELECT
    V.CodigoVuelo,
    R.CodigoRuta,
    LO.CodigoAeropuerto AS Origen,
    LD.CodigoAeropuerto AS Destino,
    A.Matricula,
    V.FechaHoraSalida,
    V.FechaHoraLlegada,
    EV.Descripcion AS Estado
FROM dbo.Vuelos V
INNER JOIN dbo.Rutas R
    ON V.RutaID = R.RutaID
INNER JOIN dbo.Localizaciones LO
    ON R.LocalizacionOrigenID = LO.LocalizacionID
INNER JOIN dbo.Localizaciones LD
    ON R.LocalizacionDestinoID = LD.LocalizacionID
INNER JOIN dbo.Aviones A
    ON V.AvionID = A.AvionID
INNER JOIN dbo.EstadosVuelo EV
    ON V.EstadoVueloID = EV.EstadoVueloID
ORDER BY V.FechaHoraSalida;
GO

-- PRECIOS


;WITH Precios AS (
    SELECT *
    FROM (VALUES
        ('AS001', 'N701AS', 'Economica', 250.00),
        ('AS001', 'N701AS', 'Ejecutiva', 750.00),
        ('AS002', 'N702AS', 'Economica', 180.00),
        ('AS002', 'N702AS', 'Ejecutiva', 550.00),
        ('AS003', 'N703AS', 'Economica', 650.00),
        ('AS003', 'N703AS', 'Ejecutiva', 1800.00),
        ('AS004', 'N702AS', 'Economica', 320.00),
        ('AS004', 'N702AS', 'Ejecutiva', 900.00)
    ) AS P(CodigoRuta, Matricula, NombreCabina, PrecioBase)
)
INSERT INTO dbo.PreciosRutaCabina (
    RutaID,
    CabinaID,
    MonedaID,
    PrecioBase,
    FechaInicio,
    FechaFin
)
SELECT
    R.RutaID,
    C.CabinaID,
    M.MonedaID,
    P.PrecioBase,
    '2026-10-28',
    '2026-12-31'
FROM Precios P
INNER JOIN dbo.Rutas R
    ON R.CodigoRuta = P.CodigoRuta
INNER JOIN dbo.Aviones A
    ON A.Matricula = P.Matricula
INNER JOIN dbo.Cabinas C
    ON C.AvionID = A.AvionID
    AND C.NombreCabina = P.NombreCabina
INNER JOIN dbo.Monedas M
    ON M.CodigoMoneda = 'USD'
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.PreciosRutaCabina PRC
    WHERE PRC.RutaID = R.RutaID
      AND PRC.CabinaID = C.CabinaID
      AND PRC.MonedaID = M.MonedaID
      AND PRC.FechaInicio = CAST('2026-10-28' AS DATE)
);
GO
--VALIDACION
SELECT
    R.CodigoRuta,
    LO.CodigoAeropuerto AS Origen,
    LD.CodigoAeropuerto AS Destino,
    C.NombreCabina,
    PRC.PrecioBase,
    M.CodigoMoneda,
    PRC.FechaInicio,
    PRC.FechaFin
FROM dbo.PreciosRutaCabina PRC
INNER JOIN dbo.Rutas R
    ON PRC.RutaID = R.RutaID
INNER JOIN dbo.Localizaciones LO
    ON R.LocalizacionOrigenID = LO.LocalizacionID
INNER JOIN dbo.Localizaciones LD
    ON R.LocalizacionDestinoID = LD.LocalizacionID
INNER JOIN dbo.Cabinas C
    ON PRC.CabinaID = C.CabinaID
INNER JOIN dbo.Monedas M
    ON PRC.MonedaID = M.MonedaID
ORDER BY R.CodigoRuta, C.NombreCabina;
GO
--DESCUENTOS

INSERT INTO dbo.Descuentos (
    CodigoDescuento,
    Descripcion,
    Porcentaje,
    FechaInicio,
    FechaFin,
    Activo
)
SELECT
    D.CodigoDescuento,
    D.Descripcion,
    D.Porcentaje,
    D.FechaInicio,
    D.FechaFin,
    1
FROM (
    VALUES
    (
        'BIENVENIDA10',
        'Descuento para nuevos clientes',
        10.00,
        CAST('2026-10-28' AS DATE),
        CAST('2026-12-31' AS DATE)
    ),
    (
        'PROMO15',
        'Promocion especial de temporada',
        15.00,
        CAST('2026-10-28' AS DATE),
        CAST('2026-12-31' AS DATE)
    ),
    (
        'ESPECIAL5',
        'Descuento especial del 5 por ciento',
        5.00,
        CAST('2026-10-28' AS DATE),
        CAST('2026-12-31' AS DATE)
    )
) AS D(
    CodigoDescuento,
    Descripcion,
    Porcentaje,
    FechaInicio,
    FechaFin
)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Descuentos EXISTENTE
    WHERE EXISTENTE.CodigoDescuento = D.CodigoDescuento
);
GO
-- VALIDACION

SELECT
    DescuentoID,
    CodigoDescuento,
    Descripcion,
    Porcentaje,
    FechaInicio,
    FechaFin,
    Activo
FROM dbo.Descuentos
ORDER BY CodigoDescuento;
GO

--TIQUETES

;WITH Reservas AS (
    SELECT *
    FROM (VALUES
        ('AS1001', 'AS100001', 'E001', 'TKAS1001', 250.00),
        ('AS1002', 'AS100002', 'E002', 'TKAS1002', 250.00),
        ('AS1003', 'AS100003', 'E001', 'TKAS1003', 180.00),
        ('AS1004', 'AS100001', 'E001', 'TKAS1004', 650.00),
        ('AS1005', 'AS100002', 'E002', 'TKAS1005', 320.00)
    ) AS X(
        CodigoVuelo, NumeroDocumento, NumeroAsiento,
        NumeroTiquete, PrecioBase
    )
)
INSERT INTO dbo.Tiquetes (
    VueloID,
    ClienteID,
    AsientoID,
    EstadoTiqueteID,
    NumeroTiquete,
    NombrePasajero,
    ApellidoPasajero,
    DocumentoPasajero,
    FechaEmision,
    PrecioBase,
    MonedaID
)
SELECT
    V.VueloID,
    C.ClienteID,
    A.AsientoID,
    ET.EstadoTiqueteID,
    R.NumeroTiquete,
    C.Nombres,
    C.Apellidos,
    C.NumeroDocumento,
    GETDATE(),
    R.PrecioBase,
    M.MonedaID
FROM Reservas R
INNER JOIN dbo.Vuelos V
    ON V.CodigoVuelo = R.CodigoVuelo
INNER JOIN dbo.Clientes C
    ON C.NumeroDocumento = R.NumeroDocumento
INNER JOIN dbo.Aviones AV
    ON AV.AvionID = V.AvionID
INNER JOIN dbo.Cabinas CB
    ON CB.AvionID = AV.AvionID
    AND CB.NombreCabina = 'Economica'
INNER JOIN dbo.Asientos A
    ON A.CabinaID = CB.CabinaID
    AND A.NumeroAsiento = R.NumeroAsiento
INNER JOIN dbo.EstadosTiquete ET
    ON ET.Descripcion = 'Pagado'
INNER JOIN dbo.Monedas M
    ON M.CodigoMoneda = 'USD'
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Tiquetes T
    WHERE T.NumeroTiquete = R.NumeroTiquete
);
GO
-- validacion
SELECT
    T.NumeroTiquete,
    V.CodigoVuelo,
    R.CodigoRuta,
    C.Nombres,
    C.Apellidos,
    A.NumeroAsiento,
    T.PrecioBase,
    M.CodigoMoneda,
    ET.Descripcion
FROM dbo.Tiquetes T
INNER JOIN dbo.Vuelos V
    ON T.VueloID = V.VueloID
INNER JOIN dbo.Rutas R
    ON V.RutaID = R.RutaID
INNER JOIN dbo.Clientes C
    ON T.ClienteID = C.ClienteID
INNER JOIN dbo.Asientos A
    ON T.AsientoID = A.AsientoID
INNER JOIN dbo.Monedas M
    ON T.MonedaID = M.MonedaID
INNER JOIN dbo.EstadosTiquete ET
    ON T.EstadoTiqueteID = ET.EstadoTiqueteID
ORDER BY V.CodigoVuelo;
GO

-- PAGOS

INSERT INTO dbo.Pagos
(
    TiqueteID,
    MetodoPagoID,
    MonedaID,
    FechaPago,
    Monto,
    ReferenciaTransaccion,
    EstadoPago
)
SELECT
    T.TiqueteID,
    (SELECT TOP 1 MetodoPagoID
     FROM dbo.MetodosPago
     ORDER BY MetodoPagoID),
    T.MonedaID,
    GETDATE(),
    T.PrecioBase,
    CONCAT('TRX-', T.NumeroTiquete),
    'Aprobado'
FROM dbo.Tiquetes AS T
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Pagos AS P
    WHERE P.TiqueteID = T.TiqueteID
);
GO
-- VALIDACION
SELECT
    T.NumeroTiquete,
    C.Nombres,
    C.Apellidos,
    MP.NombreMetodo,
    P.FechaPago,
    P.Monto,
    M.CodigoMoneda,
    P.EstadoPago
FROM dbo.Pagos AS P
INNER JOIN dbo.Tiquetes AS T
    ON P.TiqueteID = T.TiqueteID
LEFT JOIN dbo.Clientes AS C
    ON T.ClienteID = C.ClienteID
INNER JOIN dbo.MetodosPago AS MP
    ON P.MetodoPagoID = MP.MetodoPagoID
INNER JOIN dbo.Monedas AS M
    ON P.MonedaID = M.MonedaID
ORDER BY T.NumeroTiquete;
GO

-- Asignar al piloto al vuelo AS1001
INSERT INTO dbo.EmpleadoVuelo
(
    EmpleadoID,
    VueloID,
    Funcion
)
SELECT
    E.EmpleadoID,
    V.VueloID,
    'Piloto'
FROM dbo.Empleados AS E
CROSS JOIN dbo.Vuelos AS V
WHERE E.NumeroDocumento = 'EMP1001'
  AND V.CodigoVuelo = 'AS1001'
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.EmpleadoVuelo AS EV
      WHERE EV.EmpleadoID = E.EmpleadoID
        AND EV.VueloID = V.VueloID
  );

-- Asignar al copiloto al vuelo AS1001
INSERT INTO dbo.EmpleadoVuelo
(
    EmpleadoID,
    VueloID,
    Funcion
)
SELECT
    E.EmpleadoID,
    V.VueloID,
    'Copiloto'
FROM dbo.Empleados AS E
CROSS JOIN dbo.Vuelos AS V
WHERE E.NumeroDocumento = 'EMP1002'
  AND V.CodigoVuelo = 'AS1001'
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.EmpleadoVuelo AS EV
      WHERE EV.EmpleadoID = E.EmpleadoID
        AND EV.VueloID = V.VueloID
  );

-- Asignar al tripulante de cabina al vuelo AS1001
INSERT INTO dbo.EmpleadoVuelo
(
    EmpleadoID,
    VueloID,
    Funcion
)
SELECT
    E.EmpleadoID,
    V.VueloID,
    'Tripulante de cabina'
FROM dbo.Empleados AS E
CROSS JOIN dbo.Vuelos AS V
WHERE E.NumeroDocumento = 'EMP1003'
  AND V.CodigoVuelo = 'AS1001'
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.EmpleadoVuelo AS EV
      WHERE EV.EmpleadoID = E.EmpleadoID
        AND EV.VueloID = V.VueloID
  );
GO
/*
SELECT
    t.name AS Tabla,
    c.name AS Columna,
    ty.name AS TipoDato,
    CASE WHEN c.is_nullable = 1 THEN 'NULL' ELSE 'NOT NULL' END AS Nulabilidad,
    CASE WHEN pk.column_id IS NOT NULL THEN 'SI' ELSE 'NO' END AS PK,
    CASE WHEN fk.parent_column_id IS NOT NULL THEN 'SI' ELSE 'NO' END AS FK,
    OBJECT_NAME(fk.referenced_object_id) AS ReferenciaTabla,
    COL_NAME(fk.referenced_object_id, fk.referenced_column_id) AS ReferenciaColumna
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
LEFT JOIN (
    SELECT ic.object_id, ic.column_id
    FROM sys.indexes i
    JOIN sys.index_columns ic
      ON i.object_id = ic.object_id
     AND i.index_id = ic.index_id
    WHERE i.is_primary_key = 1
) pk
ON c.object_id = pk.object_id
AND c.column_id = pk.column_id
LEFT JOIN sys.foreign_key_columns fk
ON c.object_id = fk.parent_object_id
AND c.column_id = fk.parent_column_id
ORDER BY Tabla, Columna;*/