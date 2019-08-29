START TRANSACTION;

INSERT INTO role (role_name)
VALUES ('Operator_1'),
       ('Operator_2'),
       ('Operator_3'),
       ('Administrator');

INSERT INTO permission (permission_name)
VALUES ('Permission_to_receive_documents'),
       ('Permission_to_issue_documents'),
       ('Permission_to_work_with_legal_entities');

INSERT INTO role_permission (role_id, permission_id)
VALUES (1, 1),
       (2, 1),
       (2, 2),
       (3, 1),
       (3, 3),
       (4, 1),
       (4, 2),
       (4, 3);

INSERT INTO service (service_name, permission_id, average_lead_time)
VALUES ('Прием документов от физических лиц', 1, 60),
       ('Выдача документов для физических лиц', 2, 30),
       ('Работа с юридическими лицами', 3, 90);

INSERT INTO windows (name, work)
VALUES ('Windows_1', true),
       ('Windows_2', true),
       ('Windows_3', false);

INSERT INTO user_info(name, surname, dateof_birth, contact)
VALUES ('Sergey', 'Vasilev', '1980-06-23', '89124757545'),
       ('Ivan', 'Pupkin', '1985-08-13', '89184457545'),
       ('Vera', 'Ivanova', '1982-12-23', '89184767545'),
       ('Sveta', 'Pozdeeva', '1972-12-13', '89114767545');

INSERT INTO users(login, password, is_active, user_info_id)
VALUES ('Sergey', '123', true, (SELECT user_info_id FROM user_info WHERE name = 'Sergey' AND surname = 'Vasilev')),
       ('Ivan', '456', true, (SELECT user_info_id FROM user_info WHERE name = 'Ivan' AND surname = 'Pupkin')),
       ('Vera', '789', true, (SELECT user_info_id FROM user_info WHERE name = 'Vera' AND surname = 'Ivanova')),
       ('Sveta', '759', true, (SELECT user_info_id FROM user_info WHERE name = 'Sveta' AND surname = 'Pozdeeva'));

INSERT INTO users_role(users_id, role_id)
VALUES ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Sergey'
           AND surname = 'Vasilev'),
        (SELECT role_id FROM role WHERE role_name = 'Operator_1')),
       ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Ivan'
           AND surname = 'Pupkin'),
        (SELECT role_id FROM role WHERE role_name = 'Operator_2')),
       ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Vera'
           AND surname = 'Ivanova'),
        (SELECT role_id FROM role WHERE role_name = 'Operator_3')),
       ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Sveta'
           AND surname = 'Pozdeeva'),
        (SELECT role_id FROM role WHERE role_name = 'Administrator'));

INSERT INTO queue (users_operator_id, window_id, service_id, plan_date, start_time, end_time, done, ticket_number)
VALUES ((SELECT users_id
         FROM (users JOIN users_role USING (users_id))
                  JOIN role USING (role_id)
         WHERE users.is_active = TRUE
           AND role_name = 'Operator_1'), (SELECT window_id
                                           FROM windows
                                           WHERE name = 'Windows_1'), (SELECT service_id
                                                                       FROM service
                                                                       WHERE service_name = 'Прием документов от физических лиц'),
        TIMESTAMP '2019-06-23 9:15:00', TIMESTAMP '2019-06-23 9:20:00', TIMESTAMP '2019-06-23 9:40:00', TRUE, 1);

INSERT INTO queue (users_operator_id, window_id, service_id, plan_date, start_time, end_time, done, ticket_number)
VALUES ((SELECT users_id
         FROM (users JOIN users_role USING (users_id))
                  JOIN role USING (role_id)
         WHERE users.is_active = TRUE
           AND role_name = 'Operator_1'), (SELECT window_id
                                           FROM windows
                                           WHERE name = 'Windows_1'), (SELECT service_id
                                                                       FROM service
                                                                       WHERE service_name = 'Прием документов от физических лиц'),
        TIMESTAMP '2019-06-24 10:15:00', TIMESTAMP '2019-06-24 10:15:00', TIMESTAMP '2019-06-24 11:40:00', TRUE, 2);

INSERT INTO queue (users_operator_id, window_id, service_id, plan_date, start_time, end_time, done, ticket_number)
VALUES ((SELECT users_id
         FROM (users JOIN users_role USING (users_id))
                  JOIN role USING (role_id)
         WHERE users.is_active = TRUE
           AND role_name = 'Operator_2'), (SELECT window_id
                                           FROM windows
                                           WHERE name = 'Windows_2'), (SELECT service_id
                                                                       FROM service
                                                                       WHERE service_name = 'Выдача документов для физических лиц'),
        TIMESTAMP '2019-06-24 12:00:00', TIMESTAMP '2019-06-24 12:00:00', TIMESTAMP '2019-06-24 12:15:00', TRUE, 3);

INSERT INTO queue (users_operator_id, window_id, service_id, plan_date, start_time, ticket_number)
VALUES ((SELECT users_id
         FROM (users JOIN users_role USING (users_id))
                  JOIN role USING (role_id)
         WHERE users.is_active = TRUE
           AND role_name = 'Operator_3'), (SELECT window_id
                                           FROM windows
                                           WHERE name = 'Windows_2'), (SELECT service_id
                                                                       FROM service
                                                                       WHERE service_name = 'Работа с юридическими лицами'),
        TIMESTAMP '2019-06-24 13:00:00', TIMESTAMP '2019-06-24 13:10:00', 4);

COMMIT TRANSACTION;