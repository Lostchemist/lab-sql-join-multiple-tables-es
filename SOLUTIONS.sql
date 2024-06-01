USE SAKILA;
-- 1. Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.

SELECT 
    s.store_id AS "STORE ID",
    c.city AS "CITY",
    co.country AS "COUNTRY"
FROM 
    store s
JOIN 
    address a ON s.address_id = a.address_id
JOIN 
    city c ON a.city_id = c.city_id
JOIN 
    country co ON c.country_id = co.country_id;

-- To check the outcome of the firrst query i want to check number of unique ids in the store table
SELECT COUNT(DISTINCT store_id) AS unique_store_ids
FROM store;

-- 2. Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.

SELECT 
    s.store_id AS "STORE ID",
    SUM(p.amount) AS "TOTAL BUSINESS, $"
FROM 
    store s
JOIN 
    staff st ON s.store_id = st.store_id
JOIN 
    rental r ON st.staff_id = r.staff_id
JOIN 
    payment p ON r.rental_id = p.rental_id
GROUP BY 
    s.store_id;
    
    -- 3. ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?
    
SELECT 
	c.name AS "CATEGORY",
	AVG(f.length) AS "AVERAGE RUNTIME"
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    film f ON fc.film_id = f.film_id
GROUP BY 
    c.name
ORDER BY 
    c.name;
    
-- 4. ¿Qué categorías de películas son las más largas?

SELECT 
    c.name AS "CATEGORY",
    AVG(f.length) AS AVERAGE_RUNTIME
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    film f ON fc.film_id = f.film_id
GROUP BY 
    c.name
ORDER BY 
    AVERAGE_RUNTIME DESC
LIMIT 10;

-- 5. Muestra las películas más alquiladas en orden descendente.

SELECT 
    f.title AS "TITLE",
    COUNT(r.rental_id) AS RENTAL_COUNT
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
GROUP BY 
    f.title
ORDER BY 
    RENTAL_COUNT DESC
    LIMIT 10;
    
    
    -- Highest average rrental count per user (curiocity)
    
    
 SELECT 
    f.title AS "TITLE",
    AVG(rental_count) AS AVERAGE_RENTALS
FROM (
    SELECT 
        r.customer_id,
        i.film_id,
        COUNT(r.rental_id) AS rental_count
    FROM 
        rental r
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    GROUP BY 
        r.customer_id, i.film_id
) customer_rentals
JOIN 
    film f ON customer_rentals.film_id = f.film_id
GROUP BY 
    f.title
HAVING 
    AVG(rental_count) > 1
ORDER BY 
    AVERAGE_RENTALS DESC
LIMIT 10;

-- 6. Enumera los cinco principales géneros en ingresos brutos en orden descendente.

SELECT 
    c.name AS "GENRE",
    SUM(p.amount) AS INGRESOS
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.name
ORDER BY 
    INGRESOS DESC
LIMIT 5;

-- 7. ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?

SELECT 
    f.title AS "TITLE",
    s.store_id AS STORE_ID,
    IFNULL(COUNT(i.inventory_id), 0) AS AVAILABLE_COPIES
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
JOIN 
    store s ON i.store_id = s.store_id
WHERE 
    f.title = 'Academy Dinosaur'
    AND s.store_id = 1
GROUP BY 
    f.title, s.store_id
HAVING 
    AVAILABLE_COPIES > 0;

    

