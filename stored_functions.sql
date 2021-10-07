-- Create Stored Function
CREATE OR REPLACE FUNCTION count_actors_with_letter_name(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count int;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name LIKE CONCAT(letter, '%');
	
	RETURN actor_count;
END;
$$

SELECT count_actors_with_letter_name('A');

SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'B%'



CREATE OR REPLACE FUNCTION employee_with_most_transactions() 
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
	DECLARE employee varchar;
BEGIN 
	SELECT CONCAT(first_name, ' ', last_name) INTO employee
	FROM staff
	WHERE staff_id = (
		SELECT staff_id
		FROM payment
		GROUP BY staff_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);
	
	RETURN employee;
END;
$$


SELECT employee_with_most_transactions();


CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE(
	id_of_customer INT,
	name_first VARCHAR,
	name_last VARCHAR,
	email_address VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT customer_id, first_name, last_name, email
	FROM customer
	WHERE address_id IN (
		SELECT address_id
		FROM address
		WHERE city_id IN (
			SELECT city_id
			FROM city
			WHERE country_id IN (
				SELECT country_id
				FROM country
				WHERE country = country_name
			)
		)
	);
END;
$$

DROP FUNCTION customers_in_country

SELECT * 
FROM customers_in_country('United States')
WHERE name_last LIKE 'B%';