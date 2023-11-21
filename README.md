# IPC_Honduras

Se presenta una forma de descargar los datos del Índice de Precios al Consumidor (IPC) por [rubros](https://www.bch.hn/estadisticos/GIE/LIBSERIE%20IPC%20RUBROS/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Rubros.xlsx) y [regiones](https://www.bch.hn/estadisticos/GIE/LIBSerie%20IPC%20Region/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Regi%C3%B3n.xlsx) publicados por el Banco Central de Honduras en su [página web](https://www.bch.hn/estadisticas-y-publicaciones-economicas/publicaciones-de-precios/series-ipc), en un formato compatible con el programa Julia. Se incluye un procedimiento para obtener pronósticos con modelos univariados.

Previo a su utilización, se debe:

1. Descargar e instalar [Julia](https://julialang.org/downloads/).
2. Descargar e instalar [Python](https://www.python.org/downloads/).
3. En Python, installar las siguientes librerías: "pandas" y "openpyxl".
4. En Julia, instalar las siguientes librerías: Conda,CSV,DataFrames,Dates,FileIO,GLM,Plots,PrettyTables,PyCall,StateSpaceModels.
5. Abrir el archivo "Inflacion_Componentes_Webpage.qmd" y ejecutar el proceso.

Los resultados en formato ".csv" se guardan en la carpeta "Results".
