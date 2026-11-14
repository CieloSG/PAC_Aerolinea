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

-- LIMPIEZA ------------------------------------------------------------------------------
DELETE FROM dbo.EmpleadoVuelo;
DELETE FROM dbo.Equipaje;
DELETE FROM dbo.Pagos;
DELETE FROM dbo.TiqueteDescuento;
DELETE FROM dbo.Tiquetes;
DELETE FROM dbo.PreciosRutaCabina;
DELETE FROM dbo.Vuelos;
DELETE FROM dbo.Asientos;
DELETE FROM dbo.Cabinas;
DELETE FROM dbo.Aviones;
DELETE FROM dbo.HorariosRuta;
DELETE FROM dbo.Rutas;
DELETE FROM dbo.Empleados;
DELETE FROM dbo.Clientes;
DELETE FROM dbo.Localizaciones;
DELETE FROM dbo.Descuentos;
DELETE FROM dbo.TiposEquipaje;
DELETE FROM dbo.EstadosTiquete;
DELETE FROM dbo.EstadosVuelo;
DELETE FROM dbo.Monedas;
DELETE FROM dbo.MetodosPago;
DELETE FROM dbo.Cargos;
DELETE FROM dbo.EstadosCliente;
DELETE FROM dbo.TiposDocumento;
DELETE FROM dbo.Generos;
DELETE FROM dbo.Paises;
EXEC sp_MSforeachtable 'DBCC CHECKIDENT (''?'', RESEED, 0) WITH NO_INFOMSGS';

-- AUXILIARES ----------------------------------------------------------------------------
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
INSERT dbo.Monedas (CodigoMoneda, NombreMoneda) VALUES ('COP','Peso colombiano'),('USD','Dolar estadounidense'),('EUR','Euro');
INSERT dbo.EstadosVuelo (Descripcion) VALUES ('Programado'),('Abordando'),('En Vuelo'),('Aterrizado'),('Retrasado'),('Cancelado');
INSERT dbo.EstadosTiquete (Descripcion) VALUES ('Reservado'),('Emitido'),('Abordado'),('Cancelado'),('No Presentado');
INSERT dbo.TiposEquipaje (NombreTipo) VALUES ('Equipaje de mano'),('Equipaje de bodega'),('Equipo deportivo'),('Mascota'),('Instrumento musical');

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
