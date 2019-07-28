# Описание самых популярных select запросов:

## Пользователь

## Выборка названий всех услуг, оказанные на дату:
```sql
SELECT
s.service_name
FROM queue
LEFT JOIN service s ON s.service_id=queue.service_id
WHERE date_time >= (date {'date'}) AND date_time < (date {'date+1'})
```

## Выборка имен операторов, которые оказывали данную услугу: 
```sql
SELECT
ui.surname
FROM queue
LEFT JOIN users u ON u.users_id=users_operator_id
LEFT JOIN user_info ui on u.user_info_id = ui.user_info_id
WHERE service_id = {'service_id'}
```
 
 ## Выборка оказанных услуг оператором: 
```sql
SELECT
s.service_name
FROM queue
LEFT JOIN service s on queue.service_id = s.service_id
WHERE users_operator_id = {'users_operator_id'}
```
