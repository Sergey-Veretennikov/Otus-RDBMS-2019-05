-- Группировки с ипользованием CASE
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name AS window_name,
       s.service_name,
       CASE WHEN done IS FALSE THEN 'Не оказана' ELSE 'Оказана' END AS completed_or_not,
       s.average_lead_time,
       plan_date,
       ticket_number
FROM queue
         LEFT JOIN service s ON s.service_id = queue.service_id
         LEFT JOIN windows w ON w.window_id = queue.window_id
         LEFT JOIN users u ON u.users_id = users_operator_id
         LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
GROUP BY s.average_lead_time, ui.name, ui.surname, window_name, s.service_name, completed_or_not, queue_id, plan_date,
         done, ticket_number;;

-- Группировки с ипользованием HAVING
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name AS window_name,
       s.service_name,
       s.average_lead_time,
       plan_date,
       extract(epoch from (end_time - start_time)) AS work_time,
       ticket_number
FROM queue
         LEFT JOIN service s ON s.service_id = queue.service_id
         LEFT JOIN windows w ON w.window_id = queue.window_id
         LEFT JOIN users u ON u.users_id = users_operator_id
         LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
GROUP BY s.average_lead_time, ui.name, ui.surname, window_name, s.service_name, queue_id, plan_date, done, work_time,
         ticket_number, start_time, end_time
HAVING extract(epoch from (end_time - start_time)) > 900;

-- Группировки с ипользованием ROLLUP
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name AS window_name,
       s.service_name,
       s.average_lead_time,
       plan_date,
       extract(epoch from (end_time - start_time)) AS work_time,
       ticket_number
FROM queue
         LEFT JOIN service s ON s.service_id = queue.service_id
         LEFT JOIN windows w ON w.window_id = queue.window_id
         LEFT JOIN users u ON u.users_id = users_operator_id
         LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
GROUP BY ROLLUP (s.average_lead_time, ui.name, ui.surname, window_name, s.service_name, queue_id, plan_date, done,
                 work_time, ticket_number, start_time, end_time);
				 
-- Группировки с ипользованием GROUPING SETS
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name AS window_name,
       s.service_name,
       s.average_lead_time,
       plan_date,
       extract(epoch from (end_time - start_time)) AS work_time,
       ticket_number
FROM queue
         LEFT JOIN service s ON s.service_id = queue.service_id
         LEFT JOIN windows w ON w.window_id = queue.window_id
         LEFT JOIN users u ON u.users_id = users_operator_id
         LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
GROUP BY GROUPING SETS (s.average_lead_time, ui.name, ui.surname, window_name, s.service_name, queue_id, plan_date,
                        done, work_time, ticket_number, start_time, end_time);
