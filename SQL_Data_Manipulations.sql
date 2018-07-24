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
join address on staff.address_id = address.address_id

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select staff.first_name, staff.last_name, sum(payment.amount) as total_rung_up
from staff
join payment on payment.staff_id = staff.staff_id
group by payment.staff_id

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.title, count(film_actor.actor_id)
from film
inner join film_actor on film_actor.film_id = film.film_id
group by film_actor.film_id

--  6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(film.title) from film
where film.title = "Hunchback Impossible"
group by film.title

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount)
from customer
join payment on payment.customer_id = customer.customer_id
group by customer.customer_id
order by customer.last_name ASC

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

