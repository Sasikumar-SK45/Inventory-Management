Create database inventorymanagement;

use inventorymanagement;

create table products(
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(100) NOT NULL,
category_id INT NOT NULL,
price DECIMAL(10, 2) NOT NULL,
stock_quantity INT NOT NULL,
reorder_level INT NOT NULL
);

create table Categories(
category_id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(100) UNIQUE NOT NULL,
description TEXT
);

Create table Suppliers(
supplier_id INT PRIMARY KEY AUTO_INCREMENT,
supplier_name VARCHAR(100) NOT NULL,
contact_name VARCHAR(50),
address TEXT,
phone_number VARCHAR(15) UNIQUE
);

create table Orders(
order_id INT PRIMARY KEY AUTO_INCREMENT,
order_date DATE NOT NULL,
supplier_id INT NOT NULL,
total_amount DECIMAL(10, 2) NOT NULL
);

create table OrderDetails(
order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL
);

INSERT INTO Categories (category_name, description) 
VALUES 
('Electronics', 'Electronic devices and gadgets'),
('Fashion', 'Clothing, shoes, and accessories'),
('Home and Kitchen', 'Home decor and kitchen appliances'),
('Sports', 'Sports equipment and gear'),
('Beauty and Health', 'Beauty products and health supplements');

INSERT INTO Suppliers (supplier_name, contact_name, address, phone_number) 
VALUES 
('Tech Solutions', 'John Doe', '123 Main St, New York', '123-456-7890'),
('Fashion Forward', 'Jane Smith', '456 Broadway, Los Angeles', '987-654-3210'),
('Home Essentials', 'Bob Johnson', '789 Oak St, Chicago', '555-123-4567'),
('Sports World', 'Mike Brown', '901 Maple St, Houston', '111-222-3333'),
('Beauty Care', 'Emily Davis', '345 Pine St, Miami', '444-555-6666');

INSERT INTO Products (product_name, category_id, price, stock_quantity, reorder_level) 
VALUES 
('Smartphone', 1, 599.99, 50, 20),
('Laptop', 1, 999.99, 20, 10),
('T-Shirt', 2, 19.99, 100, 50),
('Sneakers', 2, 49.99, 50, 20),
('Coffee Maker', 3, 29.99, 20, 10),
('Football', 4, 9.99, 50, 20),
('Skincare Set', 5, 39.99, 20, 10),
('Headphones', 1, 99.99, 30, 15),
('Jacket', 2, 29.99, 40, 20),
('Vitamin Pack', 5, 19.99, 0, 25);

INSERT INTO Orders (order_date, supplier_id, total_amount) 
VALUES 
('2024-01-01', 1, 15000.00),
('2024-01-15', 2, 5000.00),
('2024-02-01', 3, 8000.00),
('2024-03-01', 4, 3000.00),
('2024-04-01', 5, 6000.00),
('2024-09-01', 1, 12000.00),
('2024-09-10', 2, 7000.00);

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) 
VALUES 
(1, 1, 10, 599.99),
(1, 2, 5, 999.99),
(2, 3, 20, 19.99),
(2, 4, 10, 49.99),
(3, 5, 15, 29.99),
(3, 6, 20, 9.99),
(4, 7, 10, 39.99),
(4, 8, 5, 99.99),
(5, 9, 20, 29.99),
(5, 10, 10, 19.99),
(6, 1, 15, 599.99),
(6, 2, 10, 999.99),
(7, 3, 30, 19.99);

## 1.	Retrieve the names and prices of all products that are currently out of stock.

select p.product_name,p.price 
from products as p
where stock_quantity = 0;

## 2.	List the total number of products in each category.

select c.category_id, count(p.product_id) as numofproduct
from categories as c
left join products as p on c.category_id = p.category_id
group by c.category_name;

## 3.	Find all suppliers who have supplied products worth more than $10,000.

select s.supplier_name,sum(o.total_amount) as total_supplied
from suppliers as s 
join orders as o on s.supplier_id = o.supplier_id
group by s.supplier_name
having sum(o.total_amount) > 10000;

select * from categories;
select * from orders;
select * from orderdetails;
select * from products;
select * from suppliers;

## 4.	Get the details of products with a stock quantity less than their reorder level.

select * from products where stock_quantity < reorder_level;

## 5.	Retrieve the order IDs and total amounts for orders placed in the last 30 days.

select order_id, total_amount
from orders 
where order_date >= now() -interval 30 day;

## 6.	List all products along with their categories, ordered by product name.

select p.product_name,c.category_name,p.price,p.stock_quantity
from products as p 
join categories as c on p.category_id = c.category_id
order by  p.product_name asc;

## 7.	Get the names of suppliers who have not supplied any products in the last 6 months.

select s.supplier_name
from suppliers as s 
where s.supplier_id not in(
select o.order_id
from orders as o 
where o.order_date >= now() - interval 6 month)
;


## 8.	Find the total amount spent on orders for each supplier.

select s.supplier_name,sum(o.tatal_amount) as totalamount
from suppilers as s
join orders as o on s.supplier_id = o.supplier_id
group by s.supplier_name
order by totalamount ;

## 9.	Retrieve the product names and total quantities ordered for each product in the last year.

SELECT p.product_name, SUM(od.quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id
WHERE o.order_date >= NOW() - INTERVAL 1 YEAR
GROUP BY p.product_name
ORDER BY total_quantity DESC;

## 10.	Get a list of products that belong to the Electronics category and have a price greater than $500.

select p.product_name,p.price 
from products as p 
join categories as c on p.category_id = c.category_id
order by  c.category_name =" Electronics "
and p.price > 500;
