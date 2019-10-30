-- SDC Tipo 2. Se añade fila
----------------------------
--Reseteamos DimVendedor
	use DB01DW;
	go

	If (object_id('DimVendedor') is not null) Drop Table DimVendedor;
	Create
	Table dbo.DimVendedor
	( VendedorId int Primary Key
	, nombre nVarchar(100)
	, email nVarchar(100));

-- Cambiamos la tabla de Destino para que soporte SCD 2
ALTER TABLE dbo.DimVendedor
	  Add FechaInicioCambio DateTime Null
		  ,  FechaFinCambio DateTime Null
	      ,  EsActual char(1) Null Check (EsActual in ('y', 'n'));
go

Update DB01ER.dbo.Vendedor
	Set nombre = 'Andrés Gomez'
	Where VendedorId = 7;
Delete From DB01ER.dbo.Vendedor
	Where VendedorId = 8;
Insert into DB01ER.dbo.Vendedor (nombre, email)
	Values ('Laura Muñoz', 'lmunoz@danysoft.com' );
go

Exec pCompararVendedorConDimVendedor

Merge Into DimVendedor as Destino
	Using DB01ER.dbo.Vendedor as Origen
		ON Destino.VendedorId = Origen.VendedorId
		When Not Matched
			Then -- no se encuentra el ID en el destino
				INSERT
				Values ( Origen.VendedorId
				, Origen.nombre
				, Origen.email
				, GetDate() --Para FechaiInicioCambio
				, Null -- Para FechaFinCambio
				, 'y' -- Para EsActual
				)
		When Matched -- Cuando se ha actualizado por tanto
			--pero el nombre no coincide
			AND ( Origen.nombre <> Destino.nombre
			-- o no coincide el email
			OR Origen.email <> Destino.email)
		Then -- Merge no permite Insertar una fila bajo la clausula MATCHED así que solo cambiamos si es actual
			UPDATE -- Actualizamos
			SET Destino.EsActual = 'n'
		When Not Matched By Source
			Then 
			UPDATE
			SET Destino.FechaFinCambio = GetDate()
				, Destino.EsActual = 'n'
;
go
Select * From DB01ER.dbo.Vendedor;
Select * From DB01DW.dbo.DimVendedor;




-- SDC Tipo 3. Se añade columna
-------------------------------
--Reseteamos DimVendedor
	use DB01DW;
	go

	If (object_id('DimVendedor') is not null) Drop Table DimVendedor;
	Create
	Table dbo.DimVendedor
	( VendedorId int Primary Key
	, nombre nVarchar(100)
	, email nVarchar(100));

--Añadimos dos filas a la tabla Vendedor
Insert into DB01ER.dbo.Vendedor(nombre, email)
	Values('Ana Burgos', 'aburgos@danysoft.com')
	, ('Luis Vicente', 'lvicente@danysoft.com');

Exec pCompararVendedorConDimVendedor

-- Merge para rellenar DimVendedor
Merge Into DimVendedor as Destino
	Using DB01ER.dbo.Vendedor as Origen
		ON Destino.VendedorId = Origen.VendedorId
		When Not Matched
			Then -- no se encuentra el ID en el destino
				INSERT
				Values ( Origen.VendedorId, Origen.nombre, Origen.email);
				-- Merge siempre acaba con ; obligatorio.
go
Exec pCompararVendedorConDimVendedor

--Actualizar la tabla
---------------------
Update DB01ER.dbo.Vendedor
	Set nombre= 'Carmen Lucio'
		, email= 'clucas@danysoft.com'
	Where VendedorId = 9
go

--Incluimos un campo que guarda el nombre antiguo
ALTER TABLE DimVendedor
	Add nombrePrevio varchar(50) Null;
go

Merge Into DimVendedor as Destino
	Using DB01ER.dbo.Vendedor as Origen
		ON Destino.VendedorId = Origen.VendedorId
		When Not Matched
			Then 
				INSERT
				Values ( Origen.VendedorId
				, Origen.nombre
				, Origen.email
				, Null) --AÑADIMOS AQUÍ PARA nombrePrevio
		When Matched 
			AND ( Origen.nombre <> Destino.nombre
			OR Origen.email <> Destino.email)
			Then
			UPDATE 
			SET Destino.nombre = Origen.nombre
				, Destino.email = Origen.email	
				, Destino.nombrePrevio = Destino.nombre --AÑADIMOS AQUÍ
		When Not Matched By Source
			Then -- está en Destino, pero no en origen
			DELETE
;
go
Select * from DB01ER.dbo.Vendedor;
Select * from DB01DW.dbo.DimVendedor;
