--- tworzenie tabeli
CREATE TABLE staronk (
    badanie_id int PRIMARY KEY,
    imie varchar(15) NOT NULL,
	nazwisko varchar(30) NOT NULL,
	nr_telefonu char(9) NULL,
	data_badania date NULL,
	wynik bit NOT NULL
);

--- dodawanie rekordów pocz¹tkowych dla nastêpnej czêœci zadania

insert into staronk 
values (1, 'Jakub', 'Szypu³a', 123456789, '2019-10-2', 0)
insert into staronk 
values (3, 'Przemys³aw', 'Chojecki', 123321321, '2019-2-15', 1)
insert into staronk 
values (2, 'Kacper', 'Staroñ', 111111111, '2020-10-1', 0)

--- Potwierdzam samodzielnoœæ powy¿szej pracy oraz niekorzystanie przeze mnie z niedozwolonych Ÿróde³.