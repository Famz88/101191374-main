-- write a SQL query to list the titles and release years of all Harry Potter movies, in chronological order.

SELECT movies.title, movies.year FROM movies WHERE title LIKE "Harry Potter%" ORDER BY year;