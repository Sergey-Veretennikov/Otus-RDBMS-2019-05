-- Реализовать по страничную выдачу каталога товаров

CREATE VIEW queue_view AS
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name                                                       AS window_name,
       s.service_name,
       CASE WHEN done IS FALSE THEN 'Не оказана' ELSE 'Оказана' END AS completed_or_not,
       s.average_lead_time,
       plan_date,
       ticket_number
FROM queue
         INNER JOIN service s ON s.service_id = queue.service_id
         INNER JOIN windows w ON w.window_id = queue.window_id
         INNER JOIN users u ON u.users_id = users_operator_id
         INNER JOIN user_info ui ON u.user_info_id = ui.user_info_id
GROUP BY queue_id, ui.name, ui.surname, s.average_lead_time, window_name, s.service_name, completed_or_not, plan_date,
         done, ticket_number;

SELECT queue_id, name, completed_or_not
FROM queue_view
GROUP BY queue_id, completed_or_not, name
LIMIT 10;

-- Перестроить демонстрацию иерархии категорий с помощью рекурсивного CTE

create table subcategory_services
(
    id        serial      not null
        constraint subcategory_services_pk
            primary key,
    parent_id integer,
    name      varchar(64) not null
);

alter table subcategory_services
    owner to postgres;

create unique index subcategory_services_id_uindex
    on subcategory_services (id);
	
INSERT INTO subcategory_services (parent_id, name)
VALUES (0, 'Прием документов от физических лиц'),
       (1, 'Регистрация документов'),
       (2, 'Покупка квартиры'),
       (2, 'Покупка машины'),
       (2, 'Покупка земельного участка');
	   
with recursive cte
                   as (
        select id, cast(name as varchar(512))
        from subcategory_services
        where parent_id = 0
        union all
        select ss.id, cast(cte.name || '/' || ss.name as varchar(512))
        from subcategory_services AS ss
                 join cte on parent_id = cte.id
    )
select *
from cte;
	   
