USE AEROSKYBD
GO

USE AEROSKYBD;
GO

IF OBJECT_ID('dbo.usp_ConsultarVuelosRutas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarVuelosRutas;
GO

/*
Objetivo:
    Consultar los vuelos registrados y sus respectivas rutas.

Descripción:
    Muestra el código del vuelo, origen, destino, fechas y estado.

Fecha de creación: 28/10/2026
Autor: Cielo Sotomayor

Control de cambios:
    28/10/2026 - Creación del procedimiento.

Sintaxis de Ejemplo:

	EXEC dbo.usp_ConsultarVuelosRutas;

*/

CREATE PROCEDURE dbo.usp_ConsultarVuelosRutas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.CodigoVuelo,
        R.CodigoRuta,
        LO.Ciudad AS CiudadOrigen,
        LO.CodigoAeropuerto AS AeropuertoOrigen,
        LD.Ciudad AS CiudadDestino,
        LD.CodigoAeropuerto AS AeropuertoDestino,
        V.FechaHoraSalida,
        V.FechaHoraLlegada,
        EV.Descripcion AS EstadoVuelo
    FROM dbo.Vuelos AS V
    INNER JOIN dbo.Rutas AS R
        ON V.RutaID = R.RutaID
    INNER JOIN dbo.Localizaciones AS LO
        ON R.LocalizacionOrigenID = LO.LocalizacionID
    INNER JOIN dbo.Localizaciones AS LD
        ON R.LocalizacionDestinoID = LD.LocalizacionID
    INNER JOIN dbo.EstadosVuelo AS EV
        ON V.EstadoVueloID = EV.EstadoVueloID
    ORDER BY V.FechaHoraSalida;
END;
GO


IF OBJECT_ID('dbo.usp_ConsultarTiquetesCliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarTiquetesCliente;
GO

/*
Objetivo:
    Consultar los tiquetes asociados a cada cliente.

Descripción:
    Presenta los datos del pasajero, vuelo, asiento,
    precio y estado del tiquete.

Fecha de creación: 28/10/2026
Autor: Cielo Sotomayor

Control de cambios:
    28/10/2026 - Creación del procedimiento.

Sintaxis de Ejemplo:

	EXEC dbo.usp_ConsultarTiquetesCliente;

*/

CREATE PROCEDURE dbo.usp_ConsultarTiquetesCliente
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.Nombres,
        C.Apellidos,
        T.NumeroTiquete,
        V.CodigoVuelo,
        A.NumeroAsiento,
        T.PrecioBase,
        M.CodigoMoneda,
        ET.Descripcion AS EstadoTiquete
    FROM dbo.Tiquetes AS T
    INNER JOIN dbo.Clientes AS C
        ON T.ClienteID = C.ClienteID
    INNER JOIN dbo.Vuelos AS V
        ON T.VueloID = V.VueloID
    INNER JOIN dbo.Asientos AS A
        ON T.AsientoID = A.AsientoID
    INNER JOIN dbo.Monedas AS M
        ON T.MonedaID = M.MonedaID
    INNER JOIN dbo.EstadosTiquete AS ET
        ON T.EstadoTiqueteID = ET.EstadoTiqueteID
    ORDER BY C.Apellidos, C.Nombres;
END;
GO


IF OBJECT_ID('dbo.usp_ConsultarIngresosRuta', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarIngresosRuta;
GO

/*
Objetivo:
    Obtener los ingresos registrados por cada ruta aérea.

Descripción:
    Agrupa los pagos aprobados por ruta y moneda,
    calculando la cantidad de pagos y los ingresos totales.

Fecha de creación: 28/10/2026
Autor: Cielo Sotomayor

Control de cambios:
    28/10/2026 - Creación del procedimiento.

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
        M.CodigoMoneda,
        COUNT(P.PagoID) AS CantidadPagos,
        SUM(P.Monto) AS IngresosTotales
    FROM dbo.Pagos AS P
    INNER JOIN dbo.Tiquetes AS T
        ON P.TiqueteID = T.TiqueteID
    INNER JOIN dbo.Vuelos AS V
        ON T.VueloID = V.VueloID
    INNER JOIN dbo.Rutas AS R
        ON V.RutaID = R.RutaID
    INNER JOIN dbo.Localizaciones AS LO
        ON R.LocalizacionOrigenID = LO.LocalizacionID
    INNER JOIN dbo.Localizaciones AS LD
        ON R.LocalizacionDestinoID = LD.LocalizacionID
    INNER JOIN dbo.Monedas AS M
        ON P.MonedaID = M.MonedaID
    WHERE P.EstadoPago = 'Aprobado'
    GROUP BY
        R.CodigoRuta,
        LO.Ciudad,
        LD.Ciudad,
        M.CodigoMoneda
    ORDER BY IngresosTotales DESC;
END;
GO

IF OBJECT_ID('dbo.usp_ConsultarHistorialPagos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarHistorialPagos;
GO

/*
Objetivo:
    Consultar el historial de pagos de los tiquetes.

Descripción:
    Muestra el pasajero, método de pago, fecha,
    monto, moneda y estado de cada transacción.

Fecha de creación: 28/10/2026
Autor: Cielo Sotomayor

Control de cambios:
    28/10/2026 - Creación del procedimiento.
Sintaxis de Ejemplo:

	EXEC dbo.usp_ConsultarHistorialPagos;

*/

CREATE PROCEDURE dbo.usp_ConsultarHistorialPagos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.PagoID,
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
    ORDER BY P.FechaPago DESC;
END;
GO


IF OBJECT_ID('dbo.usp_ConsultarPersonalVuelo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ConsultarPersonalVuelo;
GO

/*
Objetivo:
    Consultar los empleados asignados a los vuelos.

Descripción:
    Presenta el código del vuelo, nombre del empleado,
    cargo y función desempeñada.

Fecha de creación: 28/10/2026
Autor: Cielo Sotomayor

Control de cambios:
    28/10/2026 - Creación del procedimiento.

Sintaxis de Ejemplo:

	EXEC dbo.usp_ConsultarPersonalVuelo;

*/

CREATE PROCEDURE dbo.usp_ConsultarPersonalVuelo
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.CodigoVuelo,
        E.Nombres,
        E.Apellidos,
        C.NombreCargo,
        EV.Funcion
    FROM dbo.EmpleadoVuelo AS EV
    INNER JOIN dbo.Empleados AS E
        ON EV.EmpleadoID = E.EmpleadoID
    INNER JOIN dbo.Cargos AS C
        ON E.CargoID = C.CargoID
    INNER JOIN dbo.Vuelos AS V
        ON EV.VueloID = V.VueloID
    ORDER BY V.CodigoVuelo, C.NombreCargo;
END;
GO






