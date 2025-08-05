SET-1
-------
/* Q1: Who is the senior most employee based on job title? */

select * from employee 
order by levels desc
limit 1;

/* Q2: Which countries have the most Invoices? */

select count(*) as most_invoices, billing_country 
from invoice
group by billing_country
order by most_invoices desc;

/* Q3: What are top 3 values of total invoice? */

select total
from invoice
order by total desc
limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city as City, sum (total) as Total_Invoice
from invoice
group by City
order by Total_Invoice desc
limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select customer.customer_id, customer.first_name, customer.last_name, sum (invoice.total) as total
from customer
inner join invoice
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;


SET-2
------

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id 
	FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count (artist.artist_id) as num_of_songs
from artist
inner join album on artist.artist_id = album.artist_id
inner join track on album.album_id = track.album_id
inner join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by num_of_songs desc
limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select track.name, track.milliseconds
from track
where track.milliseconds > (
select avg(track.milliseconds)
from track)
order by track.milliseconds desc;

select avg(track.milliseconds) from track;



SET-3
------

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH top_selling_artists AS (
    SELECT 
        (customer.first_name || ' ' || customer.last_name) AS customer_name, 
        artist.name AS singer_name,
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
    FROM customer 
    JOIN invoice ON customer.customer_id = invoice.customer_id
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
    JOIN track ON invoice_line.track_id = track.track_id
    JOIN album ON track.album_id = album.album_id
    JOIN artist ON album.artist_id = artist.artist_id
    GROUP BY (customer.first_name || ' ' || customer.last_name), artist.name
)
SELECT *   
FROM top_selling_artists
-- ORDER BY customer_name, total_spent DESC;
ORDER BY total_spent DESC;

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with popular_genre as 
(
Select customer.country, genre.name, count(invoice_line.quantity) as purchase_num,
row_number() over (partition by customer.country
order by count(invoice_line.quantity)desc) as row_no
from customer 
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 1,2
order by 1 asc, 3 desc
)
select * from popular_genre
where  row_no <= 1 ;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with top_buyer as 
(
Select customer.first_name, customer.country, sum(invoice.total) as total_purchase,
row_number() over (partition by customer.country
order by sum(invoice.total)desc) as total
from customer 
join invoice on invoice.customer_id = customer.customer_id
group by 1 , 2
order by 2 asc, 3 desc
)
select * from top_buyer
where  total = 1 ;



