-- Stored Procedures

SELECT *
FROM customer;


-- ALTER TABLE customer
-- ADD COLUMN loyalty_member BOOLEAN DEFAULT FALSE;

-- Subquery to find customers who have spent more than $100
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100;

-- Create the procedure to update customers who have spent over $100 to be loyalty members
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer
	SET loyalty_member = true
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) > 100
	);
END;
$$

-- Call the procedure aka execute
CALL update_loyalty_status();

-- Confirm that procedure worked
SELECT customer.customer_id, SUM(amount), loyalty_member
FROM payment
JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(amount) DESC;



-- Create a Procedure that will add actors to the actor table
SELECT * FROM actor;

-- Insert data into actor table
INSERT INTO actor(
	first_name,
	last_name,
	last_update
) VALUES (
	'Brian',
	'Stanton',
	NOW()
);


SELECT *
FROM actor
WHERE last_name = 'Stanton';


CREATE OR REPLACE PROCEDURE add_actor(
	_first_name VARCHAR(45),
	_last_name VARCHAR(45)
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES (_first_name, _last_name, NOW());
END;
$$;


-- Execute procedure
CALL add_actor('Jason', 'Sudeikis');

SELECT *
FROM actor
ORDER BY actor_id DESC;

SELECT *
FROM customer;