--Capas Abstraccion Vistas y Procedimientos almacenados
-------------------------------------------------------
use DB01ER
go

--Select para Productos para Vista
--No lo llevamos al DW, es para hacer listados
CREATE VIEW vListadoProductos
AS
Select 
  [Categoria/Producto] = CAST(pr.categoriaid as nVarchar(4))+'/'+CAST(pr.productoid as nVarchar(4))
, [Nombre Producto] = substring(pr.productoNombre, 9, 20)
, [Categoria Español] = CASE ca.categoriaNombre
	When 'Beverages' Then 'Bebidas'
	When 'Condiments' Then 'Condimentos'
	When 'Meat/Poultry' Then 'Carnes'
	When 'Grains/Cereals' Then 'Cereales'
	When 'Seafood' Then 'Pescados'
	When 'Confections' Then 'Confecciones'
	When 'Produce' Then 'Otros'
	When 'Dairy Productos' Then 'Lacteos'
	end
FROM Produccion.Productos as pr
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid;

--Select para cargar DimProductos
use DB01ER
go

INSERT INTO DB01DW.dbo.DimProductos
Select 
  pr.productoid
, pr.productoNombre
, pr.categoriaid
, ca.categoriaNombre
FROM Produccion.Productos as pr
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid;

--Crear Procedimiento almacenado en el que Limpiamos y Rellenamos
If (object_id('pETLInsertarDimProductos') is not null) Drop Procedure pETLInsertarDimProductos;

CREATE PROCEDURE pETLInsertarDimProductos
AS
DELETE FROM DB01DW.dbo.DimProductos;
INSERT INTO DB01DW.dbo.DimProductos
Select 
  pr.productoid
, pr.productoNombre
, pr.categoriaid
, ca.categoriaNombre
FROM Produccion.Productos as pr
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid;

Execute pETLInsertarDimProductos;
go
USE DB01DW
SELECT * FROM dbo.DimProductos
go

--Limpiar y Rellenar con TRUNCATE - ClaveProducto comienza por 1 y el rendimiento es mayor
If (object_id('pETLInsertarDimProductos') is not null) Drop Procedure pETLInsertarDimProductos;

USE DB01ER;
go

CREATE PROCEDURE pETLInsertarDimProductos
AS
TRUNCATE TABLE DB01DW.dbo.DimProductos;
INSERT INTO DB01DW.dbo.DimProductos
Select 
  pr.productoid
, pr.productoNombre
, pr.categoriaid
, ca.categoriaNombre
FROM Produccion.Productos as pr
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid;

USE DB01ER;
go
Execute pETLInsertarDimProductos;
go

USE DB01DW
SELECT * FROM dbo.DimProductos
go






