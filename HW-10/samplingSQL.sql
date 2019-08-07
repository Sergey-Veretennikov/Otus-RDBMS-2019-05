-- Отрисовка списка параметров электронной очереди с указанием всех уровней категории в JSON по условию 
-- равному номеру талона клиента.

WITH all_json_key_value AS (
    SELECT queue_id,
           ui.name,
           ui.surname,
           w.name,
           s.service_name,
           date_time,
           done,
           ticket_number
    FROM queue
             LEFT JOIN service s ON s.service_id = queue.service_id
             LEFT JOIN windows w ON w.window_id = queue.window_id
             LEFT JOIN users u ON u.users_id = users_operator_id
             LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
    WHERE ticket_number = 1
    UNION
    SELECT queue_id,
           ui.name,
           ui.surname,
           w.name,
           s.service_name,
           date_time,
           done,
           ticket_number
    FROM queue
             LEFT JOIN service s ON s.service_id = queue.service_id
             LEFT JOIN windows w ON w.window_id = queue.window_id
             LEFT JOIN users u ON u.users_id = users_operator_id
             LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
    WHERE ticket_number = 2
    UNION
    SELECT queue_id,
           ui.name,
           ui.surname,
           w.name,
           s.service_name,
           date_time,
           done,
           ticket_number
    FROM queue
             LEFT JOIN service s ON s.service_id = queue.service_id
             LEFT JOIN windows w ON w.window_id = queue.window_id
             LEFT JOIN users u ON u.users_id = users_operator_id
             LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
    WHERE ticket_number = 3
)
SELECT json_object_agg(queue_id, all_json_key_value)
FROM all_json_key_value;