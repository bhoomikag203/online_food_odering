create table CUSTOMERS (id int  prrimary key auto_increment, name  varchar(20), address varchar(100), email varchar(25), phone_no varchar(20));

create table ORDERS( id int primary key auto_increment, catalog_id int references catalogs(id),  customer_id int references customers(id), payment_id int references payments(id), shipment_id int references shipments(id), total_cost int);

create table CATALOGS(id int primary key auto_increment, name varchar(20), price int);

create table ORDER_DETAILS(id int primary key auto_increment, order_id int references ORDERS(id), catalog_id int references CATALOGS(id), quantity int);
 
create table PAYMENTS(id int primary key auto_increment,order_id int  references 	ORDERS(id), payment_type varchar(50), status varchar(30));

create table SHIPMENTS(id int primary key auto_increment, order_id int references orders(id), staff_name varchar(20), phone_no int(20),  status varchar(30)); 


