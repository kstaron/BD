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

	-- dodawanie nowego ³adunku
	declare @id_³adunek int
	declare @id_klient int
	declare @typ_³adunku bit
	declare @iloœæ float
	set @id_klient = 0
	set @typ_³adunku = 1
	set @iloœæ = 1
	select @id_³adunek = max(id_³adunek) + 1 from ³adunek
	
	insert into ³adunek 
	values (@id_³adunek, @id_klient, @typ_³adunku, @iloœæ, NULL)

	-- dodawanie nowego transportu
	declare @id_transport int
	declare @max_pojemnoœæ float
	declare @kontenery bit
	declare @paliwa bit
	select @id_transport = max(id_transport) + 1 from transport
	set @max_pojemnoœæ = 100
	set @kontenery = 1
	set @paliwa = 0

	insert into transport
	values (@id_transport, @max_pojemnoœæ, @kontenery, @paliwa)
	

	-- dodawanie ³adunków do po³¹czeñ i tworzenie listy po³¹czeñ do dodania
	declare @id_po³¹czenie int
	declare @suma float

	declare @nowe_po³¹czenia table (
		po³¹czenie int
	)

	declare kursor cursor local
	forward_only
	for select po³¹czenia.id_po³¹czenie, transport.max_pojemnoœæ, transport.kontenery, s.suma from po³¹czenia
		join trasy on po³¹czenia.id_trasa = trasy.id_trasa
		join porty on porty.nazwa_portu = trasy.port_pocz¹tkowy
		join transport on transport.id_transport = po³¹czenia.id_transport
		join (select id_po³¹czenie, sum(iloœæ) as suma from po³¹czenia_³adunek 
		join ³adunek on po³¹czenia_³adunek.id_³adunek = ³adunek.id_³adunek
		group by id_po³¹czenie
		union
		select p.id_po³¹czenie, 0 as x
		from po³¹czenia as p
		where not exists (select * from po³¹czenia_³adunek where id_po³¹czenie = p.id_po³¹czenie)) as s on s.id_po³¹czenie = po³¹czenia.id_po³¹czenie
		where @kraj = porty.kraj and @data < po³¹czenia.wyp³yniêcie

	open kursor
	fetch next from kursor into @id_po³¹czenie, @max_pojemnoœæ, @kontenery, @suma

	while @@FETCH_STATUS = 0
	begin
		if @max_pojemnoœæ >= @suma + 1 and @kontenery = 1
			insert into po³¹czenia_³adunek
			values (@id_po³¹czenie, @id_³adunek)
		else
			insert into @nowe_po³¹czenia values (@id_po³¹czenie)

		fetch next from kursor into @id_po³¹czenie, @max_pojemnoœæ, @kontenery, @suma
	end

	close kursor
	deallocate kursor

	-- tworzenie nowych po³¹czeñ z ³adunkiem

	declare @id1 int
	declare @id2 int
	declare @id3 int
	declare @id4 int
	declare @czas date

	declare kursor2 cursor local forward_only
	for select * from @nowe_po³¹czenia

	open kursor2
	fetch next from kursor2 into @id_po³¹czenie

	while @@FETCH_STATUS = 0
	begin
		select @id1 = id_po³¹czenie, @id2 = id_armator, @id3 = id_trasa, @id4 = id_transport, @czas = dateadd(day, 1, wyp³yniêcie) 
		from po³¹czenia where id_po³¹czenie = @id_po³¹czenie 
		select @id_po³¹czenie = max(id_po³¹czenie) + 1 from po³¹czenia
		insert into po³¹czenia values
		(@id_po³¹czenie, @id2, @id3, @id4, @czas)

		fetch next from kursor2 into @id_po³¹czenie

	end

	close kursor2
	deallocate kursor2

END
GO