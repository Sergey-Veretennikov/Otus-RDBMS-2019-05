-- Реализовать функцию в своей БД.

CREATE TYPE t_queue AS (
    id INTEGER,
    name VARCHAR,
    surname VARCHAR,
    windows_name VARCHAR,
    service_name VARCHAR,
    plan_date TIMESTAMP
    );

-- Первый вариант:

CREATE OR REPLACE FUNCTION return_t_queue_info() RETURNS SETOF t_queue AS
$$
DECLARE
    result t_queue;
BEGIN
    FOR result.id,
        result.name,
        result.surname,
        result.windows_name,
        result.service_name,
        result.plan_date IN SELECT queue_id,
                                   ui.name,
                                   ui.surname,
                                   w.name,
                                   s.service_name,
                                   queue.plan_date
                            FROM queue
                                     INNER JOIN users u on queue.users_operator_id = u.users_id
                                     INNER JOIN user_info ui on u.user_info_id = ui.user_info_id
                                     INNER JOIN windows w on queue.window_id = w.window_id
                                     INNER JOIN service s on queue.service_id = s.service_id
        LOOP
            RETURN NEXT result;
        END LOOP;
    RETURN;
END
$$ LANGUAGE plpgsql;

SELECT *
FROM return_t_queue_info();

-- Второй вариант:

CREATE OR REPLACE FUNCTION return_t_queue_info2() RETURNS SETOF t_queue AS
$$
DECLARE
    result           t_queue;
    service_queue_id INTEGER;
    user_queue_id    INTEGER;
    windows_queue_id INTEGER;
BEGIN
    FOR result.id,
        service_queue_id,
        user_queue_id,
        windows_queue_id,
        result.plan_date IN SELECT queue_id,
                                   service_id,
                                   users_operator_id,
                                   window_id,
                                   queue.plan_date
                            FROM queue
        LOOP
            SELECT service_name FROM service WHERE service_id = service_queue_id INTO result.service_name;
            SELECT ui.name, ui.surname
            FROM users
                     INNER JOIN user_info ui on users.user_info_id = ui.user_info_id
            WHERE users_id = user_queue_id
            INTO result.name, result.surname;
            SELECT name FROM windows WHERE window_id = windows_queue_id INTO result.windows_name;
            RETURN NEXT result;
        END LOOP;
    RETURN;
END
$$ LANGUAGE plpgsql;

SELECT *
FROM return_t_queue_info2();