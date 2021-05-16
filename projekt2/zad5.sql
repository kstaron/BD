SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dodajKontenery
	@kraj varchar(30),
	@data date
AS
BEGIN
	SET NOCOUNT ON;

	-- dodawanie nowego �adunku
	declare @id_�adunek int
	declare @id_klient int
	declare @typ_�adunku bit
	declare @ilo�� float
	set @id_klient = 0
	set @typ_�adunku = 1
	set @ilo�� = 1
	select @id_�adunek = max(id_�adunek) + 1 from �adunek
	
	insert into �adunek 
	values (@id_�adunek, @id_klient, @typ_�adunku, @ilo��, NULL)

	-- dodawanie nowego transportu
	declare @id_transport int
	declare @max_pojemno�� float
	declare @kontenery bit
	declare @paliwa bit
	select @id_transport = max(id_transport) + 1 from transport
	set @max_pojemno�� = 100
	set @kontenery = 1
	set @paliwa = 0

	insert into transport
	values (@id_transport, @max_pojemno��, @kontenery, @paliwa)
	

	-- dodawanie �adunk�w do po��cze� i tworzenie listy po��cze� do dodania
	declare @id_po��czenie int
	declare @suma float

	declare @nowe_po��czenia table (
		po��czenie int
	)

	declare kursor cursor local
	forward_only
	for select po��czenia.id_po��czenie, transport.max_pojemno��, transport.kontenery, s.suma from po��czenia
		join trasy on po��czenia.id_trasa = trasy.id_trasa
		join porty on porty.nazwa_portu = trasy.port_pocz�tkowy
		join transport on transport.id_transport = po��czenia.id_transport
		join (select id_po��czenie, sum(ilo��) as suma from po��czenia_�adunek 
		join �adunek on po��czenia_�adunek.id_�adunek = �adunek.id_�adunek
		group by id_po��czenie
		union
		select p.id_po��czenie, 0 as x
		from po��czenia as p
		where not exists (select * from po��czenia_�adunek where id_po��czenie = p.id_po��czenie)) as s on s.id_po��czenie = po��czenia.id_po��czenie
		where @kraj = porty.kraj and @data < po��czenia.wyp�yni�cie

	open kursor
	fetch next from kursor into @id_po��czenie, @max_pojemno��, @kontenery, @suma

	while @@FETCH_STATUS = 0
	begin
		if @max_pojemno�� >= @suma + 1 and @kontenery = 1
			insert into po��czenia_�adunek
			values (@id_po��czenie, @id_�adunek)
		else
			insert into @nowe_po��czenia values (@id_po��czenie)

		fetch next from kursor into @id_po��czenie, @max_pojemno��, @kontenery, @suma
	end

	close kursor
	deallocate kursor

	-- tworzenie nowych po��cze� z �adunkiem

	declare @id1 int
	declare @id2 int
	declare @id3 int
	declare @id4 int
	declare @czas date

	declare kursor2 cursor local forward_only
	for select * from @nowe_po��czenia

	open kursor2
	fetch next from kursor2 into @id_po��czenie

	while @@FETCH_STATUS = 0
	begin
		select @id1 = id_po��czenie, @id2 = id_armator, @id3 = id_trasa, @id4 = id_transport, @czas = dateadd(day, 1, wyp�yni�cie) 
		from po��czenia where id_po��czenie = @id_po��czenie 
		select @id_po��czenie = max(id_po��czenie) + 1 from po��czenia
		insert into po��czenia values
		(@id_po��czenie, @id2, @id3, @id4, @czas)

		fetch next from kursor2 into @id_po��czenie

	end

	close kursor2
	deallocate kursor2

END
GO