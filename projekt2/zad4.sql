/* 4.1 */

select id_po��czenie from 
(select p.id_po��czenie, 0 as x
from po��czenia as p
where not exists (select * from po��czenia_�adunek where id_po��czenie = p.id_po��czenie)
union 
select id_po��czenie, count(id_�adunek) as x from po��czenia_�adunek group by id_po��czenie ) as q
order by x

/* 4.2 */

select port_pocz�tkowy from 
po��czenia 
join trasy on po��czenia.id_trasa = trasy.id_trasa
group by port_pocz�tkowy
having count(port_pocz�tkowy) > (select count(id_po��czenie) from po��czenia)/(select count( distinct port_pocz�tkowy ) from 
po��czenia 
join trasy on po��czenia.id_trasa = trasy.id_trasa)

/* 4.3 */

select port_pocz�tkowy from (
select p.id_po��czenie, 0 as x
from po��czenia as p
where not exists (select * from po��czenia_�adunek where id_po��czenie = p.id_po��czenie)
union 
select id_po��czenie, count(id_�adunek) as x from po��czenia_�adunek group by id_po��czenie having count(id_�adunek) < 2 ) as q
join po��czenia as p on p.id_po��czenie = q.id_po��czenie
join trasy as t on t.id_trasa = p.id_trasa
group by port_pocz�tkowy
having count(port_pocz�tkowy) < 3

/* 4.4 */

select id_armator, sum(ilo��)/count(ilo��) as �rednia from (
select p.id_armator, 0 as ilo��
from po��czenia as p
where not exists (select * from po��czenia_�adunek where id_po��czenie = p.id_po��czenie)
union all
select id_armator, ilo�� from po��czenia_�adunek
join �adunek on �adunek.id_�adunek = po��czenia_�adunek.id_�adunek
join po��czenia on po��czenia_�adunek.id_po��czenie = po��czenia.id_po��czenie) as a
group by id_armator
union
select a.id_armator, 0 as �rednia
from armatorzy as a
where not exists (select * from po��czenia where id_armator = a.id_armator)

/* 4.5 */

select nazwa_portu from porty 
except
(select port_pocz�tkowy from
�adunek 
right join po��czenia_�adunek as pl on pl.id_�adunek = �adunek.id_�adunek
join po��czenia as p on p.id_po��czenie = pl.id_po��czenie
join trasy as t on t.id_trasa = p.id_trasa
where typ_�adunku = 1
union
select port_ko�cowy from
�adunek 
right join po��czenia_�adunek as pl on pl.id_�adunek = �adunek.id_�adunek
join po��czenia as p on p.id_po��czenie = pl.id_po��czenie
join trasy as t on t.id_trasa = p.id_trasa
where typ_�adunku = 1)
