# Описание логики транзакций для модели данных:
Подразумевается, что уровень изоляции у нас стоит READ COMMITTED, база данных - PostgreSql.
## Задача:
Назначение специалиста на оказание услуги.
## Фазы:
1. Выбор услуги. 
2. Выбор свободного специалиста. 
3. Назначение заданного специалиста на заданную услугу на заданное время.

## Особенности: 
1. Назначения ведут один оператор и несколько специалистов.    
2. Исключить возможность того, что если специалист выбрал услугу, то оператор не сможет ему назначит ту же услугу.
3. Исключить возможность того что оператор на разные услуги назначит одного и того же специалиста на одно и то же время.

## SQL:  
```sql
Start transaction;

SELECT users_id FROM (users JOIN users_role USING (users_id)) JOIN role USING (role_id) WHERE users.is_active = TRUE AND role_name='Услуга 1' FOR UPDATE ;
SELECT queue_id FROM queue WHERE users_operator_id = 1 AND date_time = '2019-06-23 19:14:47.588000' FOR UPDATE ;
INSERT INTO queue (users_operator_id, window_id, service_id, date_time, ticket_number) VALUES (1, 1, 1, '2019-06-23 19:14:47.588000', 60);

Commit transaction;
```
 
