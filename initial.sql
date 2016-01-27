CREATE TABLE account_types (
	id SERIAL UNIQUE PRIMARY KEY NOT NULL,
	type text NOT NULL
);

CREATE TABLE comics (
	id SERIAL UNIQUE PRIMARY KEY NOT NULL, -- for the database
	-- external_id integer UNIQUE NOT NULL, -- used in URLs and the like!
	date date NOT NULL,
	image_url text NOT NULL,
	image_link text,
	hover_text text,
	title text NOT NULL,
	num_panels integer
);

CREATE TABLE panels (
	id SERIAL UNIQUE PRIMARY KEY NOT NULL,
	comic_id integer references comics(id) NOT NULL,
	sequence_no integer NOT NULL,
	x integer NOT NULL,
	y integer NOT NULL,
	width integer NOT NULL,
	height integer NOT NULL
);

CREATE INDEX comic_id_index ON panels(comic_id);

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;

CREATE TABLE users (
	id SERIAL UNIQUE PRIMARY KEY NOT NULL,
	displayname text NOT NULL,
	primary_email citext,
	all_email citext[],
	password text NOT NULL,
	old_passwords text[],
	account_id integer references account_types(id)
);

CREATE TABLE versions (
	id SERIAL UNIQUE PRIMARY KEY NOT NULL,
	major_release_number character varying(2) NOT NULL,
	minor_release_number character varying(2) NOT NULL,
	point_release_number character varying(4) NOT NULL,
	script_name character varying(40) NOT NULL,
	date_applied date DEFAULT now() NOT NULL
);

insert into versions values (1, '01', '00', '0000', 'install');

-- add in the admin account
insert into account_types values (1, 'admin');


-- GRANT ALL PRIVILEGES ON TABLE categories TO "DailyMath";
-- GRANT ALL PRIVILEGES ON TABLE problems TO "DailyMath";
-- GRANT SELECT ON TABLE users TO "DailyMath";
-- GRANT SELECT ON TABLE versions TO "DailyMath";
-- GRANT SELECT ON TABLE solution_methods TO "DailyMath";
-- GRANT SELECT ON TABLE account_types TO "DailyMath";
-- GRANT USAGE, SELECT ON SEQUENCE problems_id_seq TO "DailyMath";
-- GRANT USAGE, SELECT ON SEQUENCE categories_id_seq TO "DailyMath";
-- -- ALTER USER "DailyMath" PASSWORD '[CREATE A SECURE PASSWORD]';
