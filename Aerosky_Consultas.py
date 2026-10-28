
# ============================================================
# PROYECTO: SISTEMA DE GESTION AEROSKY
# Implementación de consultas SQL mediante Python
# Lenguaje: Python
# Base de datos: SQL Server AEROSKYBD
# Fecha: 28/10/2026
# ============================================================

from sqlalchemy import create_engine
from urllib.parse import quote_plus
import pandas as pd

# ============================================================
# 1. CONFIGURACIÓN DE LA CONEXIÓN
# ============================================================

cadena_conexion = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=DESKTOP-657F9IE;"
    "DATABASE=AEROSKYBD;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

parametros = quote_plus(cadena_conexion)

engine = create_engine(
    f"mssql+pyodbc:///?odbc_connect={parametros}"
)

# ============================================================
# 2. CONEXIÓN A LA BASE DE DATOS
# ============================================================
def conectar_bd():

    try:

        print("\n" + "=" * 70)
        print("CONEXIÓN EXITOSA")
        print("Base de datos: AEROSKYBD")
        print("=" * 70)

        return engine

    except Exception as error:

        print("\n" + "=" * 70)
        print("ERROR DE CONEXIÓN")
        print("=" * 70)
        print(error)

        return None

# ============================================================
# 3. EJECUTAR PROCEDIMIENTO ALMACENADO DE CONSULTA
# ============================================================

def ejecutar_sp(conexion, nombre_sp):

    try:
        consulta = f"EXEC dbo.{nombre_sp}"

        resultado = pd.read_sql_query(
            consulta,
            conexion
        )

        return resultado

    except Exception as error:
        print("\nERROR AL EJECUTAR EL PROCEDIMIENTO")
        print("Procedimiento:", nombre_sp)
        print(error)

        return None


# ============================================================
# 4. MOSTRAR LOS RESULTADOS DE LAS CONSULTAS
# ============================================================

def mostrar_resultado(titulo, resultado):

    print("\n" + "=" * 100)
    print(titulo.upper())
    print("=" * 100)

    if resultado is not None:

        if not resultado.empty:
            print(resultado.to_string(index=False))
            print("\nTotal de registros:", len(resultado))

        else:
            print("La consulta se ejecutó correctamente,")
            print("pero no se encontraron registros.")

    else:
        print("No se pudo obtener el resultado.")


# ============================================================
# 5. CONSULTA 1: VUELOS Y RUTAS
# Procedimiento: usp_ConsultarVuelosRutas
# ============================================================

def consultar_vuelos_rutas(conexion):

    resultado = ejecutar_sp(
        conexion,
        "usp_ConsultarVuelosRutas"
    )

    mostrar_resultado(
        "CONSULTA 1: VUELOS Y RUTAS",
        resultado
    )


# ============================================================
# 6. CONSULTA 2: TIQUETES POR CLIENTE
# Procedimiento: usp_ConsultarTiquetesCliente
# ============================================================

def consultar_tiquetes_cliente(conexion):

    resultado = ejecutar_sp(
        conexion,
        "usp_ConsultarTiquetesCliente"
    )

    mostrar_resultado(
        "CONSULTA 2: TIQUETES POR CLIENTE",
        resultado
    )


# ============================================================
# 7. CONSULTA 3: INGRESOS POR RUTA
# Procedimiento: usp_ConsultarIngresosRuta
# ============================================================

def consultar_ingresos_ruta(conexion):

    resultado = ejecutar_sp(
        conexion,
        "usp_ConsultarIngresosRuta"
    )

    mostrar_resultado(
        "CONSULTA 3: INGRESOS POR RUTA",
        resultado
    )


# ============================================================
# 8. CONSULTA 4: HISTORIAL DE PAGOS
# Procedimiento: usp_ConsultarHistorialPagos
# ============================================================

def consultar_historial_pagos(conexion):

    resultado = ejecutar_sp(
        conexion,
        "usp_ConsultarHistorialPagos"
    )

    mostrar_resultado(
        "CONSULTA 4: HISTORIAL DE PAGOS",
        resultado
    )


# ============================================================
# 9. CONSULTA 5: PERSONAL ASIGNADO A VUELOS
# Procedimiento: usp_ConsultarPersonalVuelo
# ============================================================

def consultar_personal_vuelo(conexion):

    resultado = ejecutar_sp(
        conexion,
        "usp_ConsultarPersonalVuelo"
    )

    mostrar_resultado(
        "CONSULTA 5: PERSONAL ASIGNADO A VUELOS",
        resultado
    )


# ============================================================
# 10. MENÚ PRINCIPAL
# ============================================================

def menu_principal(conexion):

    while True:

        print("\n")
        print("=" * 70)
        print("       SISTEMA DE GESTION AEROSKY")
        print("=" * 70)
        print("1. Consultar vuelos y rutas")
        print("2. Consultar tiquetes por cliente")
        print("3. Consultar ingresos por ruta")
        print("4. Consultar historial de pagos")
        print("5. Consultar personal asignado a vuelos")
        print("6. Ejecutar todas las consultas")
        print("0. Salir")
        print("=" * 70)

        opcion = input("Seleccione una opción: ").strip()

        if opcion == "1":
            consultar_vuelos_rutas(conexion)

        elif opcion == "2":
            consultar_tiquetes_cliente(conexion)

        elif opcion == "3":
            consultar_ingresos_ruta(conexion)

        elif opcion == "4":
            consultar_historial_pagos(conexion)

        elif opcion == "5":
            consultar_personal_vuelo(conexion)

        elif opcion == "6":
            consultar_vuelos_rutas(conexion)
            consultar_tiquetes_cliente(conexion)
            consultar_ingresos_ruta(conexion)
            consultar_historial_pagos(conexion)
            consultar_personal_vuelo(conexion)

        elif opcion == "0":
            print("\nSaliendo del sistema AeroSky...")
            break

        else:
            print("\nOpción no válida. Intente nuevamente.")


# ============================================================
# 11. EJECUCIÓN DEL PROGRAMA
# ============================================================

if __name__ == "__main__":

    conexion = conectar_bd()

    if conexion:
        menu_principal(conexion)
    else:
        print("No fue posible conectar con la base de datos.")