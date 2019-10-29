use DB01ER
go

-- Crear tabla Produccion.Categorias
CREATE TABLE produccion.Categorias
(
  categoriaid    int    NOT NULL IDENTITY,
  categoriaNombre  NVARCHAR(50) NOT NULL,
  descripcion   NVARCHAR(100) NOT NULL
  CONSTRAINT PK_Categorias PRIMARY KEY(categoriaid)
);

--Insertar el contenido de Categorias.csv
BULK INSERT DB01ER.Produccion.Categorias FROM 'C:\home\jaime\Escritorio\ETL\Categorias.csv'
WITH (
FIELDTERMINATOR = ';'
, ROWTERMINATOR = '\n'
, TABLOCK
, ORDER(categoriaid)
)

-- Crear tabla Produccion.Proveedores
CREATE TABLE produccion.Proveedores
(
  proveedorid    INT NOT NULL,
  nombreEmpresa  NVARCHAR(50) NOT NULL,
  nombreContacto   NVARCHAR(50) NOT NULL,
  contactoTitulo   NVARCHAR(50) NOT NULL,
  direccion   NVARCHAR(50) NOT NULL,
  ciudad   NVARCHAR(50) NOT NULL,
  region   NVARCHAR(50) NULL,
  codigoPostal   NVARCHAR(50) NOT NULL,
  pais   NVARCHAR(50) NOT NULL,
  telefono   NVARCHAR(50) NULL,
  fax   NVARCHAR(50) NULL
  CONSTRAINT PK_Proveedores PRIMARY KEY(proveedorid)
);

BULK INSERT DB01ER.Produccion.Proveedores FROM 'C:\home\jaime\Escritorio\ETL\Proveedores.xlsx'
WITH (
FIELDTERMINATOR = ';'
, ROWTERMINATOR = '\n'
, TABLOCK
, ORDER(proveedorid)
);



BULK INSERT DB01ER.Produccion.Proveedores FROM 'C:\Carga\Proveedores.csv'
WITH (
FIELDTERMINATOR = ';'
, ROWTERMINATOR = '\n'
, TABLOCK
, ORDER(proveedorid)
);
