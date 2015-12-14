--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: ziggurat_auth; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE ziggurat_auth WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE ziggurat_auth OWNER TO postgres;

\connect ziggurat_auth

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alembic_ziggurat_foundations_version; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE alembic_ziggurat_foundations_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_ziggurat_foundations_version OWNER TO zigg_auth;

--
-- Name: external_identities; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE external_identities (
    external_id character varying(255) NOT NULL,
    external_user_name character varying(255),
    local_user_name character varying(50) NOT NULL,
    provider_name character varying(50) NOT NULL,
    access_token character varying(255),
    alt_token character varying(255),
    token_secret character varying(255)
);


ALTER TABLE public.external_identities OWNER TO zigg_auth;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE groups (
    group_name character varying(128) NOT NULL,
    description text,
    member_count integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.groups OWNER TO zigg_auth;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: zigg_auth
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO zigg_auth;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zigg_auth
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: groups_permissions; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE groups_permissions (
    perm_name character varying(30) NOT NULL,
    group_id integer NOT NULL,
    CONSTRAINT ck_groups_permissions_perm_name CHECK (((perm_name)::text = lower((perm_name)::text)))
);


ALTER TABLE public.groups_permissions OWNER TO zigg_auth;

--
-- Name: groups_resources_permissions; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE groups_resources_permissions (
    resource_id integer NOT NULL,
    perm_name character varying(50) NOT NULL,
    group_id integer NOT NULL,
    CONSTRAINT ck_groups_resources_permissions_perm_name CHECK (((perm_name)::text = lower((perm_name)::text)))
);


ALTER TABLE public.groups_resources_permissions OWNER TO zigg_auth;

--
-- Name: resources; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE resources (
    resource_id integer NOT NULL,
    resource_name character varying(100) NOT NULL,
    resource_type character varying(30) NOT NULL,
    parent_id integer,
    ordering integer DEFAULT 0 NOT NULL,
    owner_user_id integer,
    owner_group_id integer
);


ALTER TABLE public.resources OWNER TO zigg_auth;

--
-- Name: resources_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: zigg_auth
--

CREATE SEQUENCE resources_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resources_resource_id_seq OWNER TO zigg_auth;

--
-- Name: resources_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zigg_auth
--

ALTER SEQUENCE resources_resource_id_seq OWNED BY resources.resource_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    user_name character varying(30),
    user_password character varying(256),
    email character varying(100) NOT NULL,
    status smallint NOT NULL,
    security_code character varying(256),
    last_login_date timestamp without time zone DEFAULT now(),
    registered_date timestamp without time zone DEFAULT now(),
    security_code_date timestamp without time zone DEFAULT '2000-01-01 01:01:00'::timestamp without time zone
);


ALTER TABLE public.users OWNER TO zigg_auth;

--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE users_groups (
    group_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.users_groups OWNER TO zigg_auth;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: zigg_auth
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO zigg_auth;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zigg_auth
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_permissions; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE users_permissions (
    perm_name character varying(30) NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT ck_user_permissions_perm_name CHECK (((perm_name)::text = lower((perm_name)::text)))
);


ALTER TABLE public.users_permissions OWNER TO zigg_auth;

--
-- Name: users_resources_permissions; Type: TABLE; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE TABLE users_resources_permissions (
    resource_id integer NOT NULL,
    perm_name character varying(50) NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT ck_users_resources_permissions_perm_name CHECK (((perm_name)::text = lower((perm_name)::text)))
);


ALTER TABLE public.users_resources_permissions OWNER TO zigg_auth;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: resource_id; Type: DEFAULT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY resources ALTER COLUMN resource_id SET DEFAULT nextval('resources_resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: alembic_ziggurat_foundations_version; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY alembic_ziggurat_foundations_version (version_num) FROM stdin;
13391c68750
\.


--
-- Data for Name: external_identities; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY external_identities (external_id, external_user_name, local_user_name, provider_name, access_token, alt_token, token_secret) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY groups (group_name, description, member_count, id) FROM stdin;
admins	\N	0	1
\.


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zigg_auth
--

SELECT pg_catalog.setval('groups_id_seq', 1, true);


--
-- Data for Name: groups_permissions; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY groups_permissions (perm_name, group_id) FROM stdin;
edit	1
\.


--
-- Data for Name: groups_resources_permissions; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY groups_resources_permissions (resource_id, perm_name, group_id) FROM stdin;
\.


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY resources (resource_id, resource_name, resource_type, parent_id, ordering, owner_user_id, owner_group_id) FROM stdin;
\.


--
-- Name: resources_resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zigg_auth
--

SELECT pg_catalog.setval('resources_resource_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY users (id, user_name, user_password, email, status, security_code, last_login_date, registered_date, security_code_date) FROM stdin;
2	joe	$2a$12$HUjYtTsAk8MZDcDbA6yUL.hiBxY4ixe3agdDfvta86dtcF3pXbGy.	756@345.com	1	SrmhfS1FJL3oDjtzoOpscq6CHRleQLTNyb0UPYCdw5VP78GklvHWpmIkrZXIhWqn	2015-12-12 19:56:58.186008	2015-12-12 19:56:58.185999	2000-01-01 00:00:00
4	editor	$2a$12$nDAD8dVUVjgykiHdBHOl0ufAZ3444xuVH8T14ohfbhKCA3Bytkhrq	234@sdfg	1	dFEgkttowvOImeVrybh3DlCxSOsuAnQFUfS8q7wqp4WIipikZQYys0cJeWGnRjXT	2015-12-13 17:48:49.701915	2015-12-13 17:48:49.701903	2000-01-01 00:00:00
\.


--
-- Data for Name: users_groups; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY users_groups (group_id, user_id) FROM stdin;
1	2
1	4
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zigg_auth
--

SELECT pg_catalog.setval('users_id_seq', 4, true);


--
-- Data for Name: users_permissions; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY users_permissions (perm_name, user_id) FROM stdin;
delete	4
\.


--
-- Data for Name: users_resources_permissions; Type: TABLE DATA; Schema: public; Owner: zigg_auth
--

COPY users_resources_permissions (resource_id, perm_name, user_id) FROM stdin;
\.


--
-- Name: pk_external_identities; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY external_identities
    ADD CONSTRAINT pk_external_identities PRIMARY KEY (external_id, local_user_name, provider_name);


--
-- Name: pk_groups; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT pk_groups PRIMARY KEY (id);


--
-- Name: pk_groups_permissions; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY groups_permissions
    ADD CONSTRAINT pk_groups_permissions PRIMARY KEY (group_id, perm_name);


--
-- Name: pk_groups_resources_permissions; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY groups_resources_permissions
    ADD CONSTRAINT pk_groups_resources_permissions PRIMARY KEY (group_id, resource_id, perm_name);


--
-- Name: pk_resources; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT pk_resources PRIMARY KEY (resource_id);


--
-- Name: pk_users; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: pk_users_groups; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT pk_users_groups PRIMARY KEY (user_id, group_id);


--
-- Name: pk_users_permissions; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users_permissions
    ADD CONSTRAINT pk_users_permissions PRIMARY KEY (user_id, perm_name);


--
-- Name: pk_users_resources_permissions; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users_resources_permissions
    ADD CONSTRAINT pk_users_resources_permissions PRIMARY KEY (user_id, resource_id, perm_name);


--
-- Name: uq_groups_group_name; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT uq_groups_group_name UNIQUE (group_name);


--
-- Name: uq_users_email; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: uq_users_user_name; Type: CONSTRAINT; Schema: public; Owner: zigg_auth; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT uq_users_user_name UNIQUE (user_name);


--
-- Name: ix_groups_uq_group_name_key; Type: INDEX; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE UNIQUE INDEX ix_groups_uq_group_name_key ON groups USING btree (lower((group_name)::text));


--
-- Name: ix_users_uq_lower_email; Type: INDEX; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE UNIQUE INDEX ix_users_uq_lower_email ON users USING btree (lower((email)::text));


--
-- Name: ix_users_ux_lower_username; Type: INDEX; Schema: public; Owner: zigg_auth; Tablespace: 
--

CREATE INDEX ix_users_ux_lower_username ON users USING btree (lower((user_name)::text));


--
-- Name: fk_external_identities_local_user_name_users; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY external_identities
    ADD CONSTRAINT fk_external_identities_local_user_name_users FOREIGN KEY (local_user_name) REFERENCES users(user_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_groups_permissions_group_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY groups_permissions
    ADD CONSTRAINT fk_groups_permissions_group_id_groups FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_groups_resources_permissions_group_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY groups_resources_permissions
    ADD CONSTRAINT fk_groups_resources_permissions_group_id_groups FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_groups_resources_permissions_resource_id_resources; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY groups_resources_permissions
    ADD CONSTRAINT fk_groups_resources_permissions_resource_id_resources FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_owner_group_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_resources_owner_group_id_groups FOREIGN KEY (owner_group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_resources_owner_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_resources_owner_user_id_users FOREIGN KEY (owner_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_resources_parent_id_resources; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_resources_parent_id_resources FOREIGN KEY (parent_id) REFERENCES resources(resource_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_users_groups_group_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT fk_users_groups_group_id_groups FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_groups_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT fk_users_groups_user_id_users FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_permissions_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users_permissions
    ADD CONSTRAINT fk_users_permissions_user_id_users FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_resources_permissions_resource_id_resources; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users_resources_permissions
    ADD CONSTRAINT fk_users_resources_permissions_resource_id_resources FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_resources_permissions_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: zigg_auth
--

ALTER TABLE ONLY users_resources_permissions
    ADD CONSTRAINT fk_users_resources_permissions_user_id_users FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

