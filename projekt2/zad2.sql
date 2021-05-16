/* 2.1 tworzenie bazy danych */
CREATE DATABASE statki;

CREATE TABLE porty (
    nazwa_portu varchar(30) PRIMARY KEY,
    kraj varchar(30) NOT NULL
);

CREATE TABLE trasy (
	id_trasa int PRIMARY KEY,
	port_pocz¹tkowy varchar(30) FOREIGN KEY REFERENCES porty(nazwa_portu),
	port_koñcowy varchar(30) FOREIGN KEY REFERENCES porty(nazwa_portu)
);

CREATE TABLE armatorzy (
	id_armator int PRIMARY KEY,
	nazwa_linii varchar(30) NOT NULL,
	bandera varchar(30) NULL
);

CREATE TABLE transport (
	id_transport int PRIMARY KEY,
	max_pojemnoœæ float NOT NULL,
	kontenery bit NOT NULL,
	paliwa bit NOT NULL
);


CREATE TABLE po³¹czenia (
	id_po³¹czenie int PRIMARY KEY,
	id_armator int FOREIGN KEY REFERENCES armatorzy(id_armator),
	id_trasa int FOREIGN KEY REFERENCES trasy(id_trasa),
	id_transport int FOREIGN KEY REFERENCES transport(id_transport),
	wyp³yniêcie date NOT NULL
);

CREATE TABLE ³adunek (
	id_³adunek int PRIMARY KEY,
	id_klient int NOT NUll,
	typ_³adunku bit NOT NULL, /* 0 - paliwo, 1 - kontener */
	iloœæ float NOT NULL, 
	wartoœæ money NULL,
);

CREATE TABLE po³¹czenia_³adunek (
	id_po³¹czenie int FOREIGN KEY REFERENCES po³¹czenia(id_po³¹czenie),
	id_³adunek int FOREIGN KEY REFERENCES ³adunek(id_³adunek)
);

/* 2.2 wype³nianie bazy danych */
insert into porty
values ('Szczecin', 'Polska'), ('Gdañsk', 'Polska'), ('Primorsk', 'Rosja'), ('W³adywostok', 'Rosja'), ('Kopenhaga', 'Dania')
insert into trasy
values (1, 'Szczecin', 'W³adywostok'), (2, 'Gdañsk', 'Primorsk'), (3, 'Kopenhaga', 'Primorsk'), (4, 'Gdañsk', 'Szczecin'), (5, 'W³adywostok', 'Kopenhaga')
insert into armatorzy
values (1, 'Argo', 'Grecja'), (2, 'Titanic', 'Anglia'), (3, 'Kamikaze', 'W³ochy'), (4, 'Santa Maria', 'Kastylia'), (5, 'Nagelfar', 'Asgard')
insert into transport
values (1, 1000, 1, 0), (2, 600, 0, 1), (3, 300, 1, 0), (4, 300, 1, 0), (5, 2000, 1, 1)
insert into ³adunek
values (1, 7, 0, 20, 100), (2, 10, 1, 15, 1000), (3, 1, 0, 2000, NULL), (4, 11, 1, 300, 12000), (5, 99, 1, 9, NULL), (6, 9, 0, 25, 400)
insert into po³¹czenia
values (1, 1, 3, 5, '2015-10-30'), (2, 1, 4, 4, '2000-1-1'), (3, 4, 1, 4, '1890-3-15'), (4, 2, 5, 1, '2011-2-4'), (5, 5, 3, 2, '2020-5-5'),
(6, 2, 3, 4, '0040-2-27'), (7, 2, 2, 2, '2002-11-11'), (8, 1, 3, 1, '3000-2-20'), (9, 2, 1, 5, '1466-8-11'), (10, 1, 1, 1, '0999-12-31')
insert into po³¹czenia_³adunek
values (1, 2), (2, 2), (5, 3), (5, 1), (2, 5), (3, 6), (2, 1)

/* 2.3 edycja tabeli */
update porty
set kraj = 'Wolne Miasto Gdañsk'
where nazwa_portu = 'Gdañsk';





