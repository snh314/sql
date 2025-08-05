
--1. Combine the menu_items and order_details tables into a single table.
select * from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id;

--2. What were the least and most ordered items? What categories were they in?
select count(order_details_id) as num_of_purchases, item_name, category from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id
group by item_name, category
order by num_of_purchases desc;


--3. What were the top 5 orders that spent the most money?
select order_id, sum(price) as total_cost from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id
group by order_id
order by total_cost desc NULLS LAST
limit 5;

--4. View the details of the highest spend order. What insights can you gather from the output ?

select category, count(menu_item_id) as num_of_items
from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id
where order_id = 440
group by category 
order by num_of_items desc;

--5. View the details of the top 5 highest spend orders. 
--What insights can you gather from the output ?

select order_id, category, count(menu_item_id) as num_of_items
from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id
where order_id in (440, 2075, 1957, 330, 2675)
group by order_id, category 
order by num_of_items desc;

