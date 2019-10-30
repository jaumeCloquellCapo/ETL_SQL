-- Carga Incremental con Merge
-------------------------------
use DB01DW;
go

delete DimVendedor;

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

--Actualizar
-------------
Update DB01ER.dbo.Vendedor
	Set nombre= 'Fernando Ruiz'
		, email= 'fruiz@danysoft.com'
	Where VendedorId = 6
go

Merge Into DimVendedor as Destino
	Using DB01ER.dbo.Vendedor as Origen
		ON Destino.VendedorId = Origen.VendedorId
		When Not Matched
			Then -- no se encuentra el ID en el destino
				INSERT
				Values ( Origen.VendedorId, Origen.nombre, Origen.email)
		When Matched -- Cuando se ha actualizado por tanto
			--pero el nombre no coincide
			AND ( Origen.nombre <> Destino.nombre
			-- o no coincide el email
			OR Origen.email <> Destino.email)
			Then
			UPDATE -- Actualizamos
			SET Destino.nombre = Origen.nombre
				, Destino.email = Origen.email		
;
go
Exec pCompararVendedorConDimVendedor

--Borar. Ahora inserta, actualiza y borra
-----------------------------------------
Delete
	From DB01ER.dbo.Vendedor
	Where VendedorId = 6
go

Merge Into DimVendedor as Destino
	Using DB01ER.dbo.Vendedor as Origen
		ON Destino.VendedorId = Origen.VendedorId
		When Not Matched
			Then -- no se encuentra el ID en el destino
				INSERT
				Values ( Origen.VendedorId, Origen.nombre, Origen.email)
		When Matched -- Cuando se ha actualizado por tanto
			--pero el nombre no coincide
			AND ( Origen.nombre <> Destino.nombre
			-- o no coincide el email
			OR Origen.email <> Destino.email)
			Then
			UPDATE -- Actualizamos
			SET Destino.nombre = Origen.nombre
				, Destino.email = Origen.email	
		When Not Matched By Source
			Then -- está en Destino, pero no en origen
			DELETE
;
go
Exec pCompararVendedorConDimVendedor
