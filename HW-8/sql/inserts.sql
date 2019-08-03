START TRANSACTION;

INSERT INTO role (role_name)
VALUES ('Role_1'),
       ('Role_2'),
       ('Role_3');

INSERT INTO permission (permission_name)
VALUES ('Permission_1'),
       ('Permission_2'),
       ('Permission_3');

INSERT INTO role_permission (role_id, permission_id)
VALUES (1, 1),
       (2, 1),
       (2, 2),
       (3, 1),
       (3, 2),
       (3, 3);

INSERT INTO service (service_name, permission_id, average_lead_time)
VALUES ('Service_1', 1, 30),
       ('Service_2', 2, 60),
       ('Service_3', 3, 90);

INSERT INTO windows (name, work)
VALUES ('Windows_1', true),
       ('Windows_2', true),
       ('Windows_2', false);

INSERT INTO user_info(name, surname, dateof_birth, contact)
VALUES ('Sergey', 'Vasilev', '1980-06-23', '89124757545'),
       ('Ivan', 'Pupkin', '1985-08-13', '89184457545'),
       ('Vera', 'Ivanova', '1982-12-23', '89184767545');

INSERT INTO users(login, password, is_active, user_info_id)
VALUES ('Sergey', '123', true, (SELECT user_info_id FROM user_info WHERE name = 'Sergey')),
       ('Ivan', '456', true, (SELECT user_info_id FROM user_info WHERE name = 'Ivan')),
       ('Vera', '789', true, (SELECT user_info_id FROM user_info WHERE name = 'Vera'));

INSERT INTO users_role(users_id, role_id)
VALUES ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Sergey'), (SELECT role_id FROM role WHERE role_name = 'Role_1')),
       ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Ivan'),
        (SELECT role_id FROM role WHERE role_name = 'Role_2')),
       ((SELECT users_id
         FROM users
                  JOIN user_info ui on users.user_info_id = ui.user_info_id
         WHERE name = 'Vera'),
        (SELECT role_id FROM role WHERE role_name = 'Role_3'));

INSERT INTO queue (users_operator_id, window_id, service_id, date_time, ticket_number)
VALUES ((SELECT users_id
         FROM (users JOIN users_role USING (users_id))
                  JOIN role USING (role_id)
         WHERE users.is_active = TRUE
           AND role_name = 'Role_1'), (SELECT window_id
                                          FROM windows
                                          WHERE name = 'Windows_1'), (SELECT service_id
                                                                      FROM service
                                                                      WHERE service_name = 'Service_1'),
        '2019-06-23 19:14:47.588000', 1);

UPDATE queue
SET done= true
WHERE ticket_number = '1';

COMMIT TRANSACTION;