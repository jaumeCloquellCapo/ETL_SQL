--Transformaciones
-------------------
use DB01ER
go

-- Uso de alias en columnas para tener los nombres de campos normalizados
-- Select para Pedidos pCargaDimPedidos
SELECT 
  pedidoId = pe.pedidoid --El nombre normalizado va a la izquierda y el original a la derecha. Es igual que utilizar as
, pe.fechaPedido 
, pe.fechaEntrega
, pe.ciudadEnvio
, pe.paisEnvio
, prodcutoID = pd.productoid --Cambio
, pd.precioUnitario
, pd.cantidad
, pd.descuento
FROM Ventas.Pedidos as pe
Join Ventas.PedidoDetalle as pd on pe.pedidoid = pd.pedidoid;
go

--Select para Productos
Select 
  pr.productoid
, pr.categoriaid
, pr.productoNombre
, ca.categoriaNombre
FROM Produccion.Productos as pr
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid;

--Select para Productos para Vista
--No lo llevamos al DW, es para hacer listados
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
join Produccion.Categorias as ca on pr.categoriaid=ca.categoriaid
order by [Categoria/Producto];

