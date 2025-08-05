-- View the menu_items table
select * from menu_items;

-- Find the number of items on the menu
select count(*) from menu_items;

-- What are the least and most expensive items on the menu ?
select * from menu_items
order by price desc
limit 1;

select * from menu_items
order by price
limit 1;

-- How many Italian dishes on the menu ?
select count(*) from menu_items
where category = 'Italian';

-- What are the least and most expensive Italians dishes on the menu ?
select * from menu_items
where category = 'Italian'
order by price desc
limit 1;

select * from menu_items
where category = 'Italian'
order by price
limit 1;

-- How many dishes are in each category ?
select category, count(item_name) as num_dishes
from menu_items
group by category;

-- What is the average dish price within each category ?
select category, avg(price) as avg_price
from menu_items
group by category;
