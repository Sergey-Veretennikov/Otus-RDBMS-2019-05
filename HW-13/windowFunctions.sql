-- 1. Введение в функции
-- Посчитайте по таблице фильмов, в вывод также должен попасть ид фильма, название, описание и год выпуска
-- пронумеруйте записи по названию фильма, так чтобы при изменении буквы алфавита нумерация начиналась заново
-- посчитайте общее количество фильмов и выведете полем в этом же запросе
-- посчитайте общее количество фильмов в зависимости от буквы начала называния фильма
-- следующий ид фильма на следующей строки и включите в выборку 
-- предыдущий ид фильма 
-- названия фильма 2 строки назад

SELECT film_id,
       title,
       description,
       release_year,
       row_number() OVER firstLetterFilmsInfo,
       count(*) OVER ()                   AS total_films_count,
       count(*) OVER firstLetterFilmsInfo AS first_letter_films_count,
       lead(film_id, 1) over ()           AS next_film_id,
       lag(film_id, 1) over ()            AS previous_film_id,
       lag(title,2) over() AS film_two_lines_ago
FROM film WINDOW firstLetterFilmsInfo AS (PARTITION BY "left"(title, 1) ORDER BY "left"(title, 1))
ORDER BY "left"(title, 1);

-- 2. Вахтер Василий очень любит кино и свою работу, а тут у него оказался под рукой ваш прокат (ну представим что действие разворачивается лет 15-20 назад)
-- Василий хочет посмотреть у вас все все фильмы при этом он хочет начать с самых коротких и потом уже смотреть более длинные
-- сделайте группы фильмов для Василия чтобы в каждой группе были разные жанры и фильмы сначала короткие, а потом более длинные
-- В результатах должен быть номер группы, ид фильма, название, и ид категории (жанра), продолжительность фильма.

SELECT ntile(3) over (ORDER BY length),
       film_id,
       title,
       (SELECT fc.category_id
        FROM film_category AS fc
        WHERE fc.film_id = film.film_id) AS category,
       length
FROM film
ORDER BY length;

-- 3.По каждому работнику проката выведете последнего клиента, которому сотрудник сдал что-то в прокат
-- В результатах должны быть ид и фамилия сотрудника, ид и фамилия клиента, дата аренды
-- Для этого задания нужно написать 2 варианта получения таких данных - с аналитической функцией и без нее. 

-- с аналитической функцией

SELECT staff_id, staff_last_name, customer_id, customer_last_name, rental_date
FROM (SELECT *, rank() OVER (PARTITION BY staff_id ORDER BY rental_date DESC ) AS rnk
      FROM (SELECT r.staff_id,
                   s.last_name AS staff_last_name,
                   r.customer_id,
                   c.last_name AS customer_last_name,
                   rental_date
            FROM rental AS r
                     LEFT JOIN customer c
                               on c.customer_id = r.customer_id
                     LEFT JOIN staff s on s.staff_id = r.staff_id) AS rent) AS last_customer_employee
WHERE rnk = 1;

-- без аналитической функцией

SELECT last_customer_employee.staff_id,
       last_customer_employee.staff_last_name,
       last_customer_employee.customer_id,
       last_customer_employee.customer_last_name,
       last_customer_employee.rental_date
FROM (SELECT r.staff_id, s.last_name AS staff_last_name, r.customer_id, c.last_name AS customer_last_name, r.rental_date
      FROM rental AS r
               LEFT JOIN customer c on r.customer_id = c.customer_id
               LEFT JOIN staff s on r.staff_id = s.staff_id
      ORDER BY r.staff_id, r.rental_date) AS last_customer_employee
WHERE last_customer_employee.rental_date = (SELECT rental_date
                                            FROM rental
                                            WHERE staff_id = last_customer_employee.staff_id
                                            ORDER BY rental_date DESC
                                            LIMIT 1);

-- 4.Нужно выбрать последний просмотренный фильм по каждому актеру
-- В результатах должно быть ид актера, его имя и фамилия, ид фильма, название и дата последней аренды.
-- Для этого задания нужно написать 2 варианта получения таких данных - с аналитической функцией и без нее. 
-- Данные в обоих запросах (с оконными функциями и без) должны совпадать.

-- с аналитической функцией

SELECT actor_info.actor_id,
       actor_info.first_name,
       actor_info.last_name,
       actor_info.film_id,
       actor_info.title,
       actor_info.rental_date
FROM (SELECT *, rank() OVER (PARTITION BY actor_id ORDER BY rental_date DESC ) AS rnk
      FROM (SELECT fa.actor_id, a.first_name, a.last_name, i.film_id, f.title, r.rental_date
            FROM rental AS r
                     LEFT JOIN inventory i on r.inventory_id = i.inventory_id
                     LEFT JOIN film_actor fa on i.film_id = fa.film_id
                     LEFT JOIN actor a on fa.actor_id = a.actor_id
                     LEFT JOIN film f on fa.film_id = f.film_id) AS ren) AS actor_info
WHERE rnk = 1;

-- без аналитической функцией

SELECT actor_info.actor_id,
       actor_info.first_name,
       actor_info.last_name,
       actor_info.film_id,
       actor_info.title,
       actor_info.inventory_id,
       actor_info.rental_date
FROM (SELECT fa.actor_id, a.first_name, a.last_name, i.film_id, f.title, r.inventory_id, r.rental_date
      FROM rental AS r
               LEFT JOIN inventory i on r.inventory_id = i.inventory_id
               LEFT JOIN film_actor fa on i.film_id = fa.film_id
               LEFT JOIN actor a on fa.actor_id = a.actor_id
               LEFT JOIN film f on fa.film_id = f.film_id
      ORDER BY fa.actor_id, r.rental_date) AS actor_info
WHERE actor_info.rental_date = (SELECT rental_date
                                FROM rental AS ren
                                WHERE ren.inventory_id = inventory_id
                                ORDER BY ren.rental_date DESC
                                LIMIT 1);

