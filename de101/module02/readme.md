# Module 2 - Databases and SQL
The goal is to learn how to create a cloud database and connect to it by an web-based data visualization tool.  
As a homework, I created a Postgres database in AWS RDS, and created two dashboards (Google Locker Studio and Klipfolio Power Metrics)
### Queries for create stage layer of database:
orders.sql  
returns.sql  
people.sql  
### Queries for create datawarehouse from stage layer:
stg_to_dw.sql  
### Queries samples for get some metrics:
p1_main_info_STG.sql
### Database schemas:
conceptual model: 

![conceptual model](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/mdb01_conceptual.jpg)  

logical model:  
![logical model](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/mdb02_logical.jpg)  


physical model:    
![physical model](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/mdb03_physical.jpg)  


#### Simple Dashboards

[Dashboard in Locker Studio](https://lookerstudio.google.com/reporting/88675a84-fc9e-4d5e-9a25-2fddebf85808)  
![Locker1](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/img2_Locker.jpg)

![Locker2](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/img3_Locker.jpg) 

[Dashboard in Klipfolio](https://app.klipfolio.com/gateway/published/view/55b425ce4b4454ee4ccbd4966b94af42?accessToken=49297c8eea5b214111643c75dbc3db83c5407bd764d4e12e95e82e26fdc7d2a1)  
![Klip](https://github.com/AnnaGrechina/DataLearn/blob/main/de101/module02/img1_Klipfolio.jpg)
