CREATE EXTENSION pgcrypto;

CREATE TABLE public.permission
(
    permission_id integer NOT NULL DEFAULT nextval('permission_permission_id_seq'::regclass),
    permission_name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT permission_pkey PRIMARY KEY (permission_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permission
    OWNER to "baseWatcher";
COMMENT ON TABLE public.permission
    IS 'Таблица содержит значения разрешений.';

COMMENT ON COLUMN public.permission.permission_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.permission.permission_name
    IS 'Поле содержит текстовое значение названия разрешений, тип данных – Символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';
COMMENT ON CONSTRAINT permission_pkey ON public.permission
    IS 'Так как поиск значений разрешений осуществляется по permission_id то имеет смысл наложить Indexes на данное поле.';
	
	CREATE TABLE public.queue
(
    queue_id integer NOT NULL DEFAULT nextval('queue_queue_id_seq'::regclass),
    users_operator_id integer NOT NULL,
    window_id integer NOT NULL,
    service_id integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    done boolean NOT NULL DEFAULT false,
    ticket_number integer NOT NULL DEFAULT nextval('queue_ticket_number_seq'::regclass),
    CONSTRAINT queue_pkey PRIMARY KEY (queue_id),
    CONSTRAINT queue_ticket_number_key UNIQUE (ticket_number)
,
    CONSTRAINT fk_queue_service FOREIGN KEY (service_id)
        REFERENCES public.service (service_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_queue_users FOREIGN KEY (users_operator_id)
        REFERENCES public.users (users_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_queue_window FOREIGN KEY (window_id)
        REFERENCES public.windows (window_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.queue
    OWNER to "baseWatcher";
COMMENT ON TABLE public.queue
    IS 'Таблица содержит значения внешних ключей на таблицы: users, window, service, а также значения даты, времени и булевское значения оказания услуги.';

COMMENT ON COLUMN public.queue.queue_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.queue.users_operator_id
    IS 'Поле содержит значение внешнего ключа на таблицу users, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.window_id
    IS 'Поле содержит значение внешнего ключана на таблицу windows, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.service_id
    IS 'Поле содержит значение внешнего ключа на таблицу service, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.date_time
    IS 'Поле содержит значение дату и время, тип данных – дата и время (без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.queue.done
    IS 'Поле содержит логическое значение (true - услуга оказана, false - услуга не оказана), тип данных – Boolean, поле не может быть null и значение по умолчанию false.';

COMMENT ON COLUMN public.queue.ticket_number
    IS 'Поле содержит уникальное значение номера клиента, тип данных – целые числа, поле не может быть null и автоинкрементация.';
COMMENT ON CONSTRAINT queue_pkey ON public.queue
    IS 'Так как поиск по Table queue осуществляется по queue_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT queue_ticket_number_key ON public.queue
    IS 'Дополнительно существует возможность поиска по ticket_number, а, следовательно, имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT fk_queue_service ON public.queue
    IS 'Осуществляется проверка на связь с Table service по service_id.';
COMMENT ON CONSTRAINT fk_queue_users ON public.queue
    IS 'Осуществляется проверка на связь с Table users по users_id.';
COMMENT ON CONSTRAINT fk_queue_window ON public.queue
    IS 'Осуществляется проверка на связь с Table windows по window_id.';
	
	CREATE TABLE public.role
(
    role_id integer NOT NULL DEFAULT nextval('role_role_id_seq'::regclass),
    role_name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT role_pkey PRIMARY KEY (role_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.role
    OWNER to "baseWatcher";
COMMENT ON TABLE public.role
    IS 'Таблица содержит значения ролей';

COMMENT ON COLUMN public.role.role_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.role.role_name
    IS 'Поле содержит текстовое значение названия ролей, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';
COMMENT ON CONSTRAINT role_pkey ON public.role
    IS 'Так как поиск по Table role осуществляется по role_id то имеет смысл наложить Indexes на данное поле.';
	
	CREATE TABLE public.role_permission
(
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id)
        REFERENCES public.permission (permission_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id)
        REFERENCES public.role (role_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.role_permission
    OWNER to "baseWatcher";
COMMENT ON TABLE public.role_permission
    IS 'Таблица содержит значения отношений между таблицей разрешений и таблицей ролей.';

COMMENT ON COLUMN public.role_permission.role_id
    IS 'Поле содержит первичный ключ таблицы ролей, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.role_permission.permission_id
    IS 'Поле содержит первичный ключ таблицы разрешений, тип данных – целые числа, поле не может быть null.';

COMMENT ON CONSTRAINT fk_role_permission_permission ON public.role_permission
    IS 'Осуществляется проверка на связь с Table permission по permission_id.';
COMMENT ON CONSTRAINT fk_role_permission_role ON public.role_permission
    IS 'Осуществляется проверка на связь с Table role по role_id.';
	
	CREATE TABLE public.service
(
    service_id integer NOT NULL DEFAULT nextval('service_service_id_seq'::regclass),
    service_name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    permission_id integer NOT NULL,
    average_lead_time smallint NOT NULL,
    CONSTRAINT service_pkey PRIMARY KEY (service_id),
    CONSTRAINT fk_service_permission FOREIGN KEY (permission_id)
        REFERENCES public.permission (permission_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.service
    OWNER to "baseWatcher";
COMMENT ON TABLE public.service
    IS 'Таблица содержит значения сервисов.';

COMMENT ON COLUMN public.service.service_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.service.service_name
    IS 'Поле содержит текстовое значение названия сервисов, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.service.permission_id
    IS 'Поле содержит значение внешнего ключа на таблицу permission, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.service.average_lead_time
    IS 'Поле содержит числовое значение времени, отведенного на оказание данной услуги, тип данных – целые числа малого диапазона, поле не может быть null.';
COMMENT ON CONSTRAINT service_pkey ON public.service
    IS 'Так как поиск по Table service осуществляется по service_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT fk_service_permission ON public.service
    IS 'Осуществляется проверка на связь с Table permission по permission_id.';
	
	CREATE TABLE public.user_info
(
    user_info_id integer NOT NULL DEFAULT nextval('user_info_user_info_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    surname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    dateof_birth date NOT NULL,
    contact character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT user_info_pkey PRIMARY KEY (user_info_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.user_info
    OWNER to "baseWatcher";
COMMENT ON TABLE public.user_info
    IS 'Таблица содержит значения, описывающие пользователя.';

COMMENT ON COLUMN public.user_info.user_info_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.user_info.name
    IS 'Поле содержит текстовое значение имени пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';

COMMENT ON COLUMN public.user_info.surname
    IS 'Поле содержит текстовое значение фамилии пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';

COMMENT ON COLUMN public.user_info.dateof_birth
    IS 'Поле содержит значение даты рождения пользователя, тип данных – дата(без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.user_info.contact
    IS 'Поле содержит текстовое значение контактных данных пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';
COMMENT ON CONSTRAINT user_info_pkey ON public.user_info
    IS 'Так как поиск по Table user_info осуществляется по user_info_id то имеет смысл наложить Indexes на данное поле.';
	
	CREATE TABLE public.users
(
    users_id integer NOT NULL DEFAULT nextval('users_users_id_seq'::regclass),
    login character varying(32) COLLATE pg_catalog."default" NOT NULL,
    password character varying(64) COLLATE pg_catalog."default" NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    user_info_id integer NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (users_id),
    CONSTRAINT users_login_key UNIQUE (login)
,
    CONSTRAINT users_user_info_id_key UNIQUE (user_info_id)
,
    CONSTRAINT fk_users_user_info FOREIGN KEY (user_info_id)
        REFERENCES public.user_info (user_info_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to "baseWatcher";
COMMENT ON TABLE public.users
    IS 'Таблица содержит значения пользователей.';

COMMENT ON COLUMN public.users.users_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.users.login
    IS 'Поле содержит уникальное текстовое значение логина пользователя, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.users.password
    IS 'Поле содержит уникальное текстовое значение пароля пользователя, тип данных – символьные типы переменной длины с ограничением в 64 символа, поле не может быть null.';

COMMENT ON COLUMN public.users.is_active
    IS 'Поле содержит логическое значение, тип данных – Boolean, поле не может быть null и значение по умолчанию true';

COMMENT ON COLUMN public.users.user_info_id
    IS 'Поле содержит уникальный первичный ключ таблицы user_info, тип данных – целые числа, поле не может быть null.';
COMMENT ON CONSTRAINT users_pkey ON public.users
    IS 'Так как поиск по Table users осуществляется по users_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT users_login_key ON public.users
    IS 'Дополнительно осуществляется поиск по users_login_key, а, следовательно, имеет смысл наложить Indexes на данное поле.';
COMMENT ON CONSTRAINT users_user_info_id_key ON public.users
    IS 'Дополнительно осуществляется поиск по users_user_info_id_key , а, следовательно, имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT fk_users_user_info ON public.users
    IS 'Осуществляется проверка на связь с Table user_info по user_info_id.';
	
	CREATE TABLE public.users_role
(
    users_id integer NOT NULL,
    role_id integer NOT NULL,
    CONSTRAINT fk_users_role_role FOREIGN KEY (role_id)
        REFERENCES public.role (role_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_users_role_users FOREIGN KEY (users_id)
        REFERENCES public.users (users_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users_role
    OWNER to "baseWatcher";
COMMENT ON TABLE public.users_role
    IS 'Таблица содержит значения отношений между таблицей пользователей и таблицей ролей.';

COMMENT ON COLUMN public.users_role.users_id
    IS 'Поле содержит первичный ключ таблицы пользователей, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.users_role.role_id
    IS 'Поле содержит первичный ключ таблицы ролей, тип данных – целые числа, поле не может быть null.';

COMMENT ON CONSTRAINT fk_users_role_role ON public.users_role
    IS 'Осуществляется проверка на связь с Table role по role_id.';
COMMENT ON CONSTRAINT fk_users_role_users ON public.users_role
    IS 'Осуществляется проверка на связь с Table users по users_id.';
	
	CREATE TABLE public.windows
(
    window_id integer NOT NULL DEFAULT nextval('windows_window_id_seq'::regclass),
    name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    work boolean NOT NULL DEFAULT false,
    CONSTRAINT window_pkey PRIMARY KEY (window_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.windows
    OWNER to "baseWatcher";
COMMENT ON TABLE public.windows
    IS 'Таблица содержит значения имен окон.';

COMMENT ON COLUMN public.windows.window_id
    IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.windows.name
    IS 'Поле содержит текстовое значение имени окна, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.windows.work
    IS 'Поле содержит логическое значение (true - работает, false - не работает), тип данных – Boolean, поле не может быть null и значение по умолчанию false';
COMMENT ON CONSTRAINT window_pkey ON public.windows
    IS 'Так как поиск по Table windows осуществляется по window_id то имеет смысл наложить Indexes на данное поле.';