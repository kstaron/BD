--- tworzenie tabeli
CREATE TABLE staronk (
    badanie_id int PRIMARY KEY,
    imie varchar(15) NOT NULL,
	nazwisko varchar(30) NOT NULL,
	nr_telefonu char(9) NULL,
	data_badania date NULL,
	wynik bit NOT NULL
);

--- dodawanie rekord�w pocz�tkowych dla nast�pnej cz�ci zadania

insert into staronk 
values (1, 'Jakub', 'Szypu�a', 123456789, '2019-10-2', 0)
insert into staronk 
values (3, 'Przemys�aw', 'Chojecki', 123321321, '2019-2-15', 1)
insert into staronk 
values (2, 'Kacper', 'Staro�', 111111111, '2020-10-1', 0)

--- Potwierdzam samodzielno�� powy�szej pracy oraz niekorzystanie przeze mnie z niedozwolonych �r�de�.