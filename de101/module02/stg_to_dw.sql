-- create schema dw;

-- ************************************** shipping_dim
drop table if exists dw.calendar_dim;
CREATE TABLE dw.calendar_dim
(
 date     date NOT NULL,
 year     int NOT NULL,
 month    int NOT NULL,
 quater   int NOT NULL,
 week     int NOT NULL,
 week_day int NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( "date" )
);
truncate table dw.calendar_dim;


insert into dw.calendar_dim 
select date::date, 
	   extract (year from date)::int ,
	   extract (month from date)::int,
	   to_char(date, 'q')::int,
	   extract (week from date)::int,
	   extract (dow from date)::int
from generate_series(date '2000-01-01',
                       date '2030-12-31',
                       interval '1 day') as date;
   
                       
--select * from dw.calendar_dim cd;


-- ************************************** shipping_dim
drop table if exists dw.shipping_dim;
CREATE TABLE dw.shipping_dim
	(
	 ship_id   int NOT NULL,
	 ship_mode varchar(20) NOT NULL,
	 CONSTRAINT PK_2 PRIMARY KEY ( ship_id )
	);

truncate table dw.shipping_dim;

insert into dw.shipping_dim 
select 100 + row_number() over(order by diff),
	  ship_mode 
	  from( 
			select avg(ship_date - order_date) diff, -- set the ship mode order like the velocity
					ship_mode  from public.orders o 
			group by ship_mode ) s
	 ;
		

--select * from dw.shipping_dim;

-- ************************************** customer_dim
drop table if exists dw.customer_dim;

CREATE TABLE dw.customer_dim
(
 customer_id   varchar(20) NOT NULL,
 customer_name varchar(50) NOT NULL,
 segment       varchar(20) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( customer_id )
);
truncate table dw.customer_dim;

insert into dw.customer_dim
select distinct  customer_id, customer_name, segment
from orders;


--select * from dw.customer_dim;


-- ************************************** product_dim
drop table if exists dw.product_dim;


CREATE TABLE dw.product_dim
(
 prod_id SERIAL NOT NULL,  -- there are different product names for the same product_id, that's why I put the new id column
 product_id   varchar(20) NOT NULL,
 category     varchar(20) NOT NULL,
 subcategory  varchar(20) NOT NULL,
 product_name varchar(150) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( prod_id )
);

truncate table dw.product_dim;

insert into dw.product_dim
select  
	row_number() over() as prod_id, t.* 
from (select distinct product_id, category, subcategory, product_name
	 from orders) t
order by prod_id, product_id;

--select * from dw.product_dim;


-- ************************************** geo_dim

drop table if exists dw.geo_dim;


CREATE TABLE dw.geo_dim
(
 geo_id      serial NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 state       varchar(50) NOT NULL,
 postal_code varchar(20) NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( geo_id )
);

truncate table dw.geo_dim;

insert into dw.geo_dim 
select 100 + row_number() over(), o.*
from (select distinct country, city, state, postal_code 
	 from orders ) o;

update dw.geo_dim 
set postal_code = '05405'
where city = 'Burlington' and postal_code is null;

-- select * from dw.geo_dim;

-- ************************************** manager_dim
drop table if exists dw.manager_dim;

CREATE TABLE dw.manager_dim
(
 manager_id serial not null, 
 person varchar(50) NOT NULL,
 region varchar(50) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( person )
);

truncate table dw.manager_dim;

insert into dw.manager_dim
select 100 + row_number() over(), p.*
from (select person, region 
	 from people) p;
	
--select * from dw.manager_dim

-- ************************************** sales_fact
drop table if exists dw.sales_fact;

CREATE TABLE dw.sales_fact
(
 row_id       int NOT NULL,
 order_id     varchar(25) NOT NULL,
 order_date   date NOT NULL,
 ship_date    date NOT NULL,
 prod_id   	  int NOT NULL,
 quantity     numeric(5,2) NOT NULL,
 sales_amount numeric(9,4) NOT NULL,
 discount     numeric(4,2) NOT NULL,
 profit       numeric(21,16) NOT NULL,
 ship_id    int NOT NULL,
 customer_id  varchar(20) NOT NULL,
 geo_id       int NOT NULL,
 manager_id       int NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( row_id )
);

truncate table dw.sales_fact;

insert into dw.sales_fact
select 100 + row_number() over() as row_id,
	   order_id,
	   order_date,
	   ship_date,
	   pd.prod_id,
	   quantity,
	   sales,
	   discount,
	   profit,
	   s.ship_id,
	   customer_id,
	   gd.geo_id,
	   md.manager_id
	   
	   
	 from orders  o
left join dw.shipping_dim s 
		  on s.ship_mode = o.ship_mode
left join dw.product_dim pd 
		  on o.product_id = pd.product_id 
		  and  o.category = pd.category
		  and o.subcategory = pd.subcategory 
		  and o.product_name = pd.product_name
left join dw.geo_dim gd
		  on gd.city = o.city 
		  and gd.state = gd.state 
		  and gd.country = o.country 
		  and gd.postal_code::int = o.postal_code
left join dw.manager_dim md 
		  on o.region = md.region;
		  
--select * from dw.sales_fact;
		 

-- ************************************** returns_dim

drop table if exists dw.returns_dim;
		 
CREATE TABLE dw.returns_dim
(
 order_id varchar(25) NOT NULL,
 returns  boolean NOT NULL,
 CONSTRAINT PK_8 PRIMARY KEY ( order_id )
);

truncate table dw.returns_dim;

insert into dw.returns_dim
select distinct order_id, true from returns;

select * from dw.returns_dim