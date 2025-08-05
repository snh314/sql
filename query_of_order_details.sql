--1. View the order_details table.
select * from order_details;

--2. What is the date range of the table?
select min(order_date) as start_date, max(order_date) as end_date
from order_details;

--3. How many orders were made within this date range?
select min(order_date) as start_date, max(order_date) as end_date, 
count (distinct order_id) as total_order
from order_details;

--4. How many items were ordered within this date range?
select min(order_date) as start_date, max(order_date) as end_date, 
count (item_id) as total_item_order
from order_details;
    
--5. Which orders had the most number of items?
select order_id, count(item_id) as num_of_items
from order_details
group by order_id
order by num_of_items desc;


--6. How many orders had more than 12 items?
\select count(*) as num_of_orders 
from 
(select order_id, count(item_id) as num_of_items
from order_details
group by order_id
having count(item_id) > 12);