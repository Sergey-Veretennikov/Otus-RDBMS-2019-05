--Пример использования полнотекстового индекса при поиске  (to_tsvector(' russian ', service_name) @@ to_tsquery('russian', %search_phrase%)):
SELECT queue_id,
       ui.name,
       ui.surname,
       w.name,
       s.service_name,
       s.average_lead_time_min,
       plan_date,
       done,
       ticket_number
FROM queue
         LEFT JOIN service s ON s.service_id = queue.service_id
         LEFT JOIN windows w ON w.window_id = queue.window_id
         LEFT JOIN users u ON u.users_id = users_operator_id
         LEFT JOIN user_info ui ON u.user_info_id = ui.user_info_id
WHERE s.service_name @@ to_tsquery('документов')
ORDER BY queue_id;