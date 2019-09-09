CREATE EXTENSION pgcrypto;

CREATE TABLE public.permission (
	permission_id        serial  NOT NULL ,
	permission_name      varchar(64)  NOT NULL ,
	CONSTRAINT permission_pkey PRIMARY KEY ( permission_id )
 );
 
CREATE TABLE public.queue (
	queue_id             serial  NOT NULL ,
	users_operator_id    integer  NOT NULL ,
	window_id            integer  NOT NULL ,
	service_id           integer  NOT NULL ,
	plan_date            timestamp  NOT NULL ,
	start_time           timestamp  NOT NULL,
    end_time             timestamp,
	done                 bool DEFAULT false NOT NULL ,
	ticket_number        serial  NOT NULL ,
	CONSTRAINT queue_pkey PRIMARY KEY ( queue_id ),
	CONSTRAINT queue_ticket_number_key UNIQUE ( ticket_number )
 );
 
CREATE TABLE public.role (
	role_id              serial  NOT NULL ,
	role_name            varchar(32)  NOT NULL ,
	CONSTRAINT role_pkey PRIMARY KEY ( role_id )
 );
 
CREATE TABLE public.role_permission (
	role_id              integer  NOT NULL ,
	permission_id        integer  NOT NULL
 );
 create index role_permission_permission_id_index
    on role_permission (permission_id);
 create index role_permission_role_id_index
    on role_permission (role_id);
 
CREATE TABLE public.service (
	service_id           serial  NOT NULL ,
	service_name         varchar(96)  NOT NULL ,
	permission_id        integer  NOT NULL ,
	average_lead_time_min    smallint  NOT NULL ,
	CONSTRAINT service_pkey PRIMARY KEY ( service_id )
 );
 create index service_service_name_index
    on service (to_tsvector('russian'::regconfig, service_name::text));
 
CREATE TABLE public.user_info (
	user_info_id         serial  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	surname              varchar(100)  NOT NULL ,
	dateof_birth         date  NOT NULL ,
	contact              varchar(100)  NOT NULL ,
	CONSTRAINT user_info_pkey PRIMARY KEY ( user_info_id )
 );
 create index user_info_surname_name_index
    on user_info (surname, name);
 
CREATE TABLE public.users (
	users_id             serial  NOT NULL ,
	login                varchar(32)  NOT NULL ,
	"password"           varchar(64)   ,
	is_active            bool DEFAULT true NOT NULL ,
	user_info_id         integer  NOT NULL ,
	CONSTRAINT users_pkey PRIMARY KEY ( users_id ),
	CONSTRAINT users_login_key UNIQUE ( login ) ,
	CONSTRAINT users_user_info_id_key UNIQUE ( user_info_id )
 );
 
CREATE TABLE public.users_role (
	users_id             integer  NOT NULL ,
	role_id              integer  NOT NULL
 );
 create index users_role_role_id_index
    on users_role (role_id);
 create index users_role_users_id_index
    on users_role (users_id);
	
CREATE TABLE public.windows (
	window_id            serial  NOT NULL ,
	name                 varchar(32)  NOT NULL ,
	work                 bool DEFAULT false NOT NULL ,
	CONSTRAINT window_pkey PRIMARY KEY ( window_id )
 );


COMMENT ON CONSTRAINT permission_pkey ON public.permission IS 'Так как поиск значений разрешений осуществляется по permission_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.permission IS 'Таблица содержит значения разрешений.';

COMMENT ON COLUMN public.permission.permission_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.permission.permission_name IS 'Поле содержит текстовое значение названия разрешений, тип данных – Символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';


COMMENT ON CONSTRAINT queue_pkey ON public.queue IS 'Так как поиск по Table queue осуществляется по queue_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT queue_ticket_number_key ON public.queue IS 'Дополнительно существует возможность поиска по ticket_number, а, следовательно, имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.queue IS 'Таблица содержит значения внешних ключей на таблицы: users, window, service, а также значения даты, времени и булевское значения оказания услуги.';

COMMENT ON COLUMN public.queue.queue_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.queue.users_operator_id IS 'Поле содержит значение внешнего ключа на таблицу users, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.window_id IS 'Поле содержит значение внешнего ключана на таблицу windows, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.service_id IS 'Поле содержит значение внешнего ключа на таблицу service, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.queue.plan_date IS 'Поле содержит значение дату и время, тип данных – дата и время (без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.queue.start_time is 'Поле содержит значение даты и времени начала приема, тип данных – дата и время (без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.queue.end_time is 'Поле содержит значение даты и времени окончания приема, тип данных – дата и время (без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.queue.done IS 'Поле содержит логическое значение (true - услуга оказана, false - услуга не оказана), тип данных – Boolean, поле не может быть null и значение по умолчанию false.';

COMMENT ON COLUMN public.queue.ticket_number IS 'Поле содержит уникальное значение номера клиента, тип данных – целые числа, поле не может быть null и автоинкрементация.';

ALTER TABLE public.queue ADD CONSTRAINT fk_queue_service FOREIGN KEY ( service_id ) REFERENCES public.service( service_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_queue_service ON public.queue IS 'Осуществляется проверка на связь с Table service по service_id.';

ALTER TABLE public.queue ADD CONSTRAINT fk_queue_users FOREIGN KEY ( users_operator_id ) REFERENCES public.users( users_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_queue_users ON public.queue IS 'Осуществляется проверка на связь с Table users по users_id.';

ALTER TABLE public.queue ADD CONSTRAINT fk_queue_window FOREIGN KEY ( window_id ) REFERENCES public.windows( window_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_queue_window ON public.queue IS 'Осуществляется проверка на связь с Table windows по window_id.';


COMMENT ON CONSTRAINT role_pkey ON public.role IS 'Так как поиск по Table role осуществляется по role_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.role IS 'Таблица содержит значения ролей';

COMMENT ON COLUMN public.role.role_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.role.role_name IS 'Поле содержит текстовое значение названия ролей, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';


COMMENT ON TABLE public.role_permission IS 'Таблица содержит значения отношений между таблицей разрешений и таблицей ролей.';

COMMENT ON COLUMN public.role_permission.role_id IS 'Поле содержит первичный ключ таблицы ролей, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.role_permission.permission_id IS 'Поле содержит первичный ключ таблицы разрешений, тип данных – целые числа, поле не может быть null.';

ALTER TABLE public.role_permission ADD CONSTRAINT fk_role_permission_permission FOREIGN KEY ( permission_id ) REFERENCES public.permission( permission_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_role_permission_permission ON public.role_permission IS 'Осуществляется проверка на связь с Table permission по permission_id.';

ALTER TABLE public.role_permission ADD CONSTRAINT fk_role_permission_role FOREIGN KEY ( role_id ) REFERENCES public.role( role_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_role_permission_role ON public.role_permission IS 'Осуществляется проверка на связь с Table role по role_id.';


COMMENT ON CONSTRAINT service_pkey ON public.service IS 'Так как поиск по Table service осуществляется по service_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.service IS 'Таблица содержит значения сервисов.';

COMMENT ON COLUMN public.service.service_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.service.service_name IS 'Поле содержит текстовое значение названия сервисов, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.service.permission_id IS 'Поле содержит значение внешнего ключа на таблицу permission, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.service.average_lead_time_min IS 'Поле содержит числовое значение времени, отведенного на оказание данной услуги в минутах, тип данных – целые числа малого диапазона, поле не может быть null.';

ALTER TABLE public.service ADD CONSTRAINT fk_service_permission FOREIGN KEY ( permission_id ) REFERENCES public.permission( permission_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_service_permission ON public.service IS 'Осуществляется проверка на связь с Table permission по permission_id.';


COMMENT ON CONSTRAINT user_info_pkey ON public.user_info IS 'Так как поиск по Table user_info осуществляется по user_info_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.user_info IS 'Таблица содержит значения, описывающие пользователя.';

COMMENT ON COLUMN public.user_info.user_info_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.user_info.name IS 'Поле содержит текстовое значение имени пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';

COMMENT ON COLUMN public.user_info.surname IS 'Поле содержит текстовое значение фамилии пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';

COMMENT ON COLUMN public.user_info.dateof_birth IS 'Поле содержит значение даты рождения пользователя, тип данных – дата(без часового пояса), поле не может быть null.';

COMMENT ON COLUMN public.user_info.contact IS 'Поле содержит текстовое значение контактных данных пользователя, тип данных – символьные типы переменной длины с ограничением в 100 символа, поле не может быть null.';


COMMENT ON CONSTRAINT users_pkey ON public.users IS 'Так как поиск по Table users осуществляется по users_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT users_login_key ON public.users IS 'Дополнительно осуществляется поиск по users_login_key, а, следовательно, имеет смысл наложить Indexes на данное поле.';

COMMENT ON CONSTRAINT users_user_info_id_key ON public.users IS 'Дополнительно осуществляется поиск по users_user_info_id_key , а, следовательно, имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.users IS 'Таблица содержит значения пользователей.';

COMMENT ON COLUMN public.users.users_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.users.login IS 'Поле содержит уникальное текстовое значение логина пользователя, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.users."password" IS 'Поле содержит уникальное текстовое значение пароля пользователя, тип данных – символьные типы переменной длины с ограничением в 64 символа, поле не может быть null.';

COMMENT ON COLUMN public.users.is_active IS 'Поле содержит логическое значение, тип данных – Boolean, поле не может быть null и значение по умолчанию true';

COMMENT ON COLUMN public.users.user_info_id IS 'Поле содержит уникальный первичный ключ таблицы user_info, тип данных – целые числа, поле не может быть null.';

ALTER TABLE public.users ADD CONSTRAINT fk_users_user_info FOREIGN KEY ( user_info_id ) REFERENCES public.user_info( user_info_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_users_user_info ON public.users IS 'Осуществляется проверка на связь с Table user_info по user_info_id.';


COMMENT ON TABLE public.users_role IS 'Таблица содержит значения отношений между таблицей пользователей и таблицей ролей.';

COMMENT ON COLUMN public.users_role.users_id IS 'Поле содержит первичный ключ таблицы пользователей, тип данных – целые числа, поле не может быть null.';

COMMENT ON COLUMN public.users_role.role_id IS 'Поле содержит первичный ключ таблицы ролей, тип данных – целые числа, поле не может быть null.';

ALTER TABLE public.users_role ADD CONSTRAINT fk_users_role_role FOREIGN KEY ( role_id ) REFERENCES public.role( role_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_users_role_role ON public.users_role IS 'Осуществляется проверка на связь с Table role по role_id.';

ALTER TABLE public.users_role ADD CONSTRAINT fk_users_role_users FOREIGN KEY ( users_id ) REFERENCES public.users( users_id ) ON DELETE CASCADE ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT fk_users_role_users ON public.users_role IS 'Осуществляется проверка на связь с Table users по users_id.';


COMMENT ON CONSTRAINT window_pkey ON public.windows IS 'Так как поиск по Table windows осуществляется по window_id то имеет смысл наложить Indexes на данное поле.';

COMMENT ON TABLE public.windows IS 'Таблица содержит значения имен окон.';

COMMENT ON COLUMN public.windows.window_id IS 'Поле содержит уникальное значение первичного ключа, тип данных – целые числа, поле не может быть null и автоинкрементация.';

COMMENT ON COLUMN public.windows.name IS 'Поле содержит текстовое значение имени окна, тип данных – символьные типы переменной длины с ограничением в 32 символа, поле не может быть null.';

COMMENT ON COLUMN public.windows.work IS 'Поле содержит логическое значение (true - работает, false - не работает), тип данных – Boolean, поле не может быть null и значение по умолчанию false';
