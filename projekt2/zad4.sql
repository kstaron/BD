/* 4.1 */

select id_po³¹czenie from 
(select p.id_po³¹czenie, 0 as x
from po³¹czenia as p
where not exists (select * from po³¹czenia_³adunek where id_po³¹czenie = p.id_po³¹czenie)
union 
select id_po³¹czenie, count(id_³adunek) as x from po³¹czenia_³adunek group by id_po³¹czenie ) as q
order by x

/* 4.2 */

select port_pocz¹tkowy from 
po³¹czenia 
join trasy on po³¹czenia.id_trasa = trasy.id_trasa
group by port_pocz¹tkowy
having count(port_pocz¹tkowy) > (select count(id_po³¹czenie) from po³¹czenia)/(select count( distinct port_pocz¹tkowy ) from 
po³¹czenia 
join trasy on po³¹czenia.id_trasa = trasy.id_trasa)

/* 4.3 */

select port_pocz¹tkowy from (
select p.id_po³¹czenie, 0 as x
from po³¹czenia as p
where not exists (select * from po³¹czenia_³adunek where id_po³¹czenie = p.id_po³¹czenie)
union 
select id_po³¹czenie, count(id_³adunek) as x from po³¹czenia_³adunek group by id_po³¹czenie having count(id_³adunek) < 2 ) as q
join po³¹czenia as p on p.id_po³¹czenie = q.id_po³¹czenie
join trasy as t on t.id_trasa = p.id_trasa
group by port_pocz¹tkowy
having count(port_pocz¹tkowy) < 3

/* 4.4 */

select id_armator, sum(iloœæ)/count(iloœæ) as œrednia from (
select p.id_armator, 0 as iloœæ
from po³¹czenia as p
where not exists (select * from po³¹czenia_³adunek where id_po³¹czenie = p.id_po³¹czenie)
union all
select id_armator, iloœæ from po³¹czenia_³adunek
join ³adunek on ³adunek.id_³adunek = po³¹czenia_³adunek.id_³adunek
join po³¹czenia on po³¹czenia_³adunek.id_po³¹czenie = po³¹czenia.id_po³¹czenie) as a
group by id_armator
union
select a.id_armator, 0 as œrednia
from armatorzy as a
where not exists (select * from po³¹czenia where id_armator = a.id_armator)

/* 4.5 */

select nazwa_portu from porty 
except
(select port_pocz¹tkowy from
³adunek 
right join po³¹czenia_³adunek as pl on pl.id_³adunek = ³adunek.id_³adunek
join po³¹czenia as p on p.id_po³¹czenie = pl.id_po³¹czenie
join trasy as t on t.id_trasa = p.id_trasa
where typ_³adunku = 1
union
select port_koñcowy from
³adunek 
right join po³¹czenia_³adunek as pl on pl.id_³adunek = ³adunek.id_³adunek
join po³¹czenia as p on p.id_po³¹czenie = pl.id_po³¹czenie
join trasy as t on t.id_trasa = p.id_trasa
where typ_³adunku = 1)
