use DB01ER
go

ALTER TABLE Produccion.Productos
	ADD CONSTRAINT FK_Productos_Categorias FOREIGN KEY (categoriaid) REFERENCES Produccion.Categorias(categoriaid)
go

ALTER TABLE Produccion.Productos
	ADD CONSTRAINT FK_Productos_Proveedores FOREIGN KEY (proveedorid) REFERENCES Produccion.Proveedores(proveedorid)
go
