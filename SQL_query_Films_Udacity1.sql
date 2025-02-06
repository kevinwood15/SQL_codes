/*Slide #1 'What is the most popular movie type watched by families?'*/

SELECT COUNT(c.name) rental_count
	, c.name cat_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;


/*Slide #2 'Which store performed better each month by having more rentals?'*/
WITH t1
AS (
	SELECT DATE_PART('month', r.rental_date) AS month
		,DATE_PART('year', r.rental_date) AS year
		,i.store_id id
	FROM rental r
	JOIN inventory i ON i.inventory_id = r.inventory_id
	)
SELECT COUNT(*)
	,month
	,year
	,id
FROM t1
GROUP BY month
	,year
	,id
ORDER BY year
	,month
	,id;


/*Slide #3 'Which month had the highest rental count for the top 10 highest spending customers?'*/
WITH t1
AS (
	SELECT c.first_name || ' ' || c.last_name AS full_name
		,DATE_TRUNC('month', p.payment_date) DATE
		,p.amount
	FROM payment p
	JOIN customer c ON p.customer_id = c.customer_id
	WHERE DATE_TRUNC('month', p.payment_date) BETWEEN '2007-01-01'
			AND '2007-12-31'
	)
	,t2
AS (
	SELECT SUM(amount) total
		,full_name
		,DATE
		,COUNT(DATE) count
	FROM t1
	GROUP BY full_name
		,DATE
	ORDER BY SUM(amount) DESC
	)
	,t3
AS (
	SELECT SUM(amount)
		,full_name
	FROM t1
	GROUP BY full_name
	ORDER BY SUM(amount) DESC LIMIT 10
	)
SELECT t3.full_name
	,t2.total
	,t2.DATE
	,t2.count
FROM t2
JOIN t3 ON t2.full_name = t3.full_name
ORDER BY t3.full_name
	,t2.DATE;

/*Slide #4 'What family friendly movie categories type tends to have the shortest rental duration?'*/
WITH t1 AS (
		SELECT f.title film_title
			,c.name cat_name
			,fc.category_id cat_id
			,f.rental_duration
			,NTILE(4) OVER (
				ORDER BY f.rental_duration
				) AS standard_quartile
		FROM film f
		JOIN film_category fc ON f.film_id = fc.film_id
		JOIN category c ON fc.category_id = c.category_id
		WHERE fc.category_id IN (
				2
				,3
				,4
				,5
				,8
				,12
				)
		)

SELECT COUNT(cat_name)
	,standard_quartile
	,cat_name
FROM t1
GROUP BY standard_quartile
	,cat_name
ORDER BY cat_name
	,standard_quartile;
