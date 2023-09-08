-- draft for creating dw layer, dll expressions for create tables


CREATE TABLE calendar_dim
(
 "date"     date NOT NULL,
 year     int4range NOT NULL,
 quater   int4range NOT NULL,
 month    int4range NOT NULL,
 week     int4range NOT NULL,
 week_day int4range NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( "date" )
);


-- ************************************** shipping_dim

CREATE TABLE shipping_dim
(
 ship_id   int4range NOT NULL,
 ship_mode varchar(20) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( ship_id )
);



-- ************************************** customer_dim

CREATE TABLE customer_dim
(
 customer_id   int4range NOT NULL,
 customer_name varchar(50) NOT NULL,
 segment       varchar(20) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( customer_id )
);




-- ************************************** product_dim

CREATE TABLE product_dim
(
 product_id   int4range NOT NULL,
 category     varchar(50) NOT NULL,
 sub_category varchar(50) NOT NULL,
 product_name varchar(50) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( product_id )
);


-- ************************************** geo_dim

CREATE TABLE geo_dim
(
 geo_id      int4range NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 "state"       varchar(50) NOT NULL,
 postal_code int4range NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( geo_id )
);



-- ************************************** manager_dim

CREATE TABLE manager_dim
(
 person varchar(50) NOT NULL,
 region varchar(50) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( person )
);



-- ************************************** sales_fact

CREATE TABLE sales_fact
(
 row_id       int4range NOT NULL,
 order_id     varchar(25) NOT NULL,
 sales_amount numeric(9,4) NOT NULL,
 discount     numeric(4,2) NOT NULL,
 profit       numeric(21,16) NOT NULL,
 quantity     numeric(5,2) NOT NULL,
 ship_date    date NOT NULL,
 order_date   date NOT NULL,
 ship_id_1    int4range NOT NULL,
 customer_id  int4range NOT NULL,
 product_id   int4range NOT NULL,
 geo_id       int4range NOT NULL,
 person       varchar(50) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( order_date ) REFERENCES calendar_dim ( "date" ),
 CONSTRAINT FK_2 FOREIGN KEY ( ship_id_1 ) REFERENCES shipping_dim ( ship_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( customer_id ) REFERENCES customer_dim ( customer_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( product_id ) REFERENCES product_dim ( product_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( geo_id ) REFERENCES geo_dim ( geo_id ),
 CONSTRAINT FK_6 FOREIGN KEY ( person ) REFERENCES manager_dim ( person )
);

CREATE INDEX FK_1 ON sales_fact
(
 order_date
);

CREATE INDEX FK_2 ON sales_fact
(
 ship_id_1
);

CREATE INDEX FK_3 ON sales_fact
(
 customer_id
);

CREATE INDEX FK_4 ON sales_fact
(
 product_id
);

CREATE INDEX FK_5 ON sales_fact
(
 geo_id
);

CREATE INDEX FK_6 ON sales_fact
(
 person
);



-- ************************************** returns_dim

CREATE TABLE returns_dim
(
 order_id varchar(25) NOT NULL,
 returns  boolean NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( order_id )
);





