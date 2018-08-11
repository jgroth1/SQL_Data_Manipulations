use sakila

-- 1a. Display the first and last names of all actors from the table `actor`.
select last_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name'
SELECT concat(first_name, ' ',  last_name) 
AS "Actor Name"
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- Find all actors whose last name contain the letters `GEN`:
select first_name, last_name
from actor
where last_name like "%gen%";

-- Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select first_name, last_name
from actor
where last_name like "%li%"
order by last_name, first_name asc;

-- Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
Select country_id, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
alter table actor
add column middle_name varchar(45) after first_name;

select * from actor;

-- You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
alter table actor
modify column middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
alter table actor
drop column middle_name;

select * from actor;

-- 4a List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
from actor
group by last_name;

-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select multi_last_name.*
from (
			select last_name, count(Last_name) as count
			from actor
            group by last_name
		) multi_last_name
where multi_last_name.count  > 1;

--  Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
select first_name, last_name
from actor
where first_name = "GROUCHO" and Last_name = "WILLIAMS";

update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and Last_name = "WILLIAMS";


select first_name, last_name
from actor
where first_name = "GROUCHO" and Last_name = "WILLIAMS";


select first_name, last_name
from actor
where first_name = "HARPO" and Last_name = "WILLIAMS";

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address
from staff
join address on staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select staff.first_name, staff.last_name, sum(payment.amount) as total_rung_up
from staff
join payment on payment.staff_id = staff.staff_id
group by payment.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.title, count(film_actor.actor_id)
from film
inner join film_actor on film_actor.film_id = film.film_id
group by film_actor.film_id;

--  6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(film.title) from film
where film.title = "Hunchback Impossible"
group by film.title;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount)
from customer
join payment on payment.customer_id = customer.customer_id
group by customer.customer_id
order by customer.last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select film.title
from film
join language on language.language_id = film.language_id
where film.title like "k%" or "Q%" and language.name = "English";

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name
from actor
join film_actor on film_actor.actor_id = actor.actor_id
join film on film.film_id = film_actor.film_id
where film.title = "Alone Trip";

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email
from customer
join address on address.address_id = customer.address_id
join city on city.city_id = address.city_id
join country on city.country_id = country.country_id
where country.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select film.title
from film
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Family";

-- 7e. Display the most frequently rented movies in descending order.
select sub.title
from(
	select film.title, sum(film.film_id) total_rental
    from film
    join inventory on inventory.film_id = film.film_id
    join rental on rental.inventory_id = inventory.inventory_id
    group by film.film_id
    order by total_rental desc
    ) sub;
    
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select staff.store_id, sum(payment.amount) total_buisness
from payment
join staff on staff.staff_id = payment.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store
join address on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on country.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
select sub.name
from(
		select category.name, sum(payment.amount) total
        from category
        join film_category on category.category_id = film_category.category_id
        join inventory on film_category.film_id = inventory.film_id
        join rental on inventory.inventory_id = rental.inventory_id
        join payment on rental.rental_id = payment.rental_id
        group by category.name
        order by total desc
        limit 5
        ) sub;

-- 8a. Create view of 7h
create view Top_Five_Genres as
select sub.name
from(
		select category.name, sum(payment.amount) total
        from category
        join film_category on category.category_id = film_category.category_id
        join inventory on film_category.film_id = inventory.film_id
        join rental on inventory.inventory_id = rental.inventory_id
        join payment on rental.rental_id = payment.rental_id
        group by category.name
        order by total desc
        limit 5
        ) sub;    
        
-- 8b. Display view
select * from Top_Five_Genres; 

-- 8c.  Delete view
drop view Top_Five_Genres;       