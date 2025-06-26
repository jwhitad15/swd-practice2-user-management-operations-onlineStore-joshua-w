START TRANSACTION;

DROP TABLE IF EXISTS orders, customers;

--Creating two tables named 'customers' & 'orders'. Both have fields that correspond to the table columns.
CREATE TABLE customers (
 id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(50),
 last_name VARCHAR(50)
);

CREATE TABLE orders (
 id INT PRIMARY KEY,
 customer_id INT NULL,
 order_date DATE,
 total_amount DECIMAL(10, 2),
 FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- inserting parameter (column) values into the 'customers' table
INSERT INTO customers (id, first_name, last_name) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Smith'),
(4, 'Bob', 'Brown');

-- inserting parameter (column) values into the 'orders' table
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-02-01', 150.00),
(3, 2, '2023-01-01', 200.00),
(4, 3, '2023-04-01', 250.00),
(5, 3, '2023-04-01', 300.00),
(6, NULL, '2023-04-01', 100.00);


-- running query to select & display the total amount each customer spent (uses sum to add all order amounts for each individual customer ID) 
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- running query to select & display the total amount each customer spent on a particular data (uses sum to add all order amounts for each individual customer ID for the specified date value)
SELECT customer_id, order_date, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id, order_date;

-- running query to select & display all individual rows of total amounts over $200 for each customer that meets that condition (uses Where to set the condition for selection)
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
WHERE total_amount > 200
GROUP BY customer_id;

-- running query to select & display all customers who have combined order totals of over $200 (uses HAVING to set the condition for selection)
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;

-- running query to select & display all logged orders
SELECT * FROM orders;

-- running query to select & display customer details by the order ID, customer first name, customer last name, order date, and the total amount of orders for that date (Uses INNER JOIN to combine data
-- between the 'customers' table & the corresponding conjunctions from the 'orders' table)
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

-- running query to select & display all customer details (rows) from the 'customer' table by the order ID, customer first name, customer last name, order date, and the total amount of orders for that date (Uses LEFT JOIN to display
-- connection between all rows of the 'customers' table & the corresponding conjunctions from the 'orders' table)
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

-- running a combined query to select & display the total amount each customer spent by the order date & id (uses WHERE to set the condition by which the data displayed must be greater than or equal to
-- the average total amount from the 'orders' table)
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders);

-- running a combined query to select & display the total amount each customer spent by the order date, id, and customer id (uses WHERE to set the condition by which the data displayed is derived from the 
-- customer ID whose last name(s) is/are equal to 'Smith')
SELECT id, order_date, total_amount, customer_id
FROM orders
WHERE customer_id IN (SELECT id FROM customers WHERE last_name = 'Smith');

-- running query & subquery to select & display the order dates (uses subquery to display all the columns from the 'orders' table and the main query to select only the order dates)
SELECT order_date
FROM (SELECT id, order_date, total_amount FROM orders) AS order_summary;

COMMIT;
