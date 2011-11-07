--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: blacklist_country_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE blacklist_country_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.blacklist_country_id OWNER TO phi;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: blacklist_country; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE blacklist_country (
    id integer DEFAULT nextval('blacklist_country_id'::regclass) NOT NULL,
    country character varying(2) NOT NULL,
    hits integer DEFAULT 0 NOT NULL,
    settings_id integer
);


ALTER TABLE public.blacklist_country OWNER TO phi;

--
-- Name: blacklist_ip_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE blacklist_ip_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.blacklist_ip_id OWNER TO phi;

--
-- Name: blacklist_ip; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE blacklist_ip (
    id integer DEFAULT nextval('blacklist_ip_id'::regclass) NOT NULL,
    ip inet NOT NULL,
    hits integer DEFAULT 0 NOT NULL,
    settings_id integer
);


ALTER TABLE public.blacklist_ip OWNER TO phi;

--
-- Name: blacklist_word_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE blacklist_word_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.blacklist_word_id OWNER TO phi;

--
-- Name: blacklist_word; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE blacklist_word (
    id integer DEFAULT nextval('blacklist_word_id'::regclass) NOT NULL,
    word character varying(250) NOT NULL,
    hits integer DEFAULT 0 NOT NULL,
    settings_id integer
);


ALTER TABLE public.blacklist_word OWNER TO phi;

--
-- Name: nopaste_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE nopaste_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nopaste_id OWNER TO phi;

--
-- Name: nopaste; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE nopaste (
    id integer DEFAULT nextval('nopaste_id'::regclass) NOT NULL,
    id_hashed character varying(45),
    settings_id integer,
    author character varying(80),
    description text,
    code text NOT NULL,
    date_added timestamp with time zone DEFAULT now() NOT NULL,
    expires interval NOT NULL,
    "language" character varying(64) NOT NULL,
    ip inet NOT NULL
);


ALTER TABLE public.nopaste OWNER TO phi;

--
-- Name: settings_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE settings_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.settings_id OWNER TO phi;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE settings (
    id integer DEFAULT nextval('settings_id'::regclass) NOT NULL,
    system_url character varying(200),
    system_cleanup boolean DEFAULT false NOT NULL,
    default_expires interval,
    default_language character varying(2) DEFAULT 'en'::character varying NOT NULL,
    web_style character varying(20) DEFAULT 'default'::character varying NOT NULL,
    web_title character varying(150) DEFAULT 'Perl NoPaste Service'::character varying NOT NULL,
    web_hashed_ids boolean DEFAULT false NOT NULL
);


ALTER TABLE public.settings OWNER TO phi;

--
-- Name: users_id; Type: SEQUENCE; Schema: public; Owner: phi
--

CREATE SEQUENCE users_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id OWNER TO phi;

--
-- Name: users; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_id'::regclass) NOT NULL,
    username character varying(25) NOT NULL,
    "password" character varying(64) NOT NULL,
    "session" character varying(45),
    email character varying(100) NOT NULL,
    forename character varying(45),
    surname character varying(45),
    o_email_notification boolean NOT NULL,
    superadmin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO phi;

--
-- Name: users_has_settings; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE users_has_settings (
    users_id integer NOT NULL,
    settings_id integer NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    "admin" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users_has_settings OWNER TO phi;

--
-- Name: version; Type: TABLE; Schema: public; Owner: phi; Tablespace: 
--

CREATE TABLE version (
    db_version integer DEFAULT 2 NOT NULL
);


ALTER TABLE public.version OWNER TO phi;

--
-- Name: blacklist_country_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY blacklist_country
    ADD CONSTRAINT blacklist_country_pkey PRIMARY KEY (id);


--
-- Name: blacklist_ip_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY blacklist_ip
    ADD CONSTRAINT blacklist_ip_pkey PRIMARY KEY (id);


--
-- Name: blacklist_word_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY blacklist_word
    ADD CONSTRAINT blacklist_word_pkey PRIMARY KEY (id);


--
-- Name: nopaste_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY nopaste
    ADD CONSTRAINT nopaste_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users_has_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY users_has_settings
    ADD CONSTRAINT users_has_settings_pkey PRIMARY KEY (users_id, settings_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: phi; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: blacklist_country_country; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX blacklist_country_country ON blacklist_country USING btree (country);


--
-- Name: blacklist_ip_ip; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX blacklist_ip_ip ON blacklist_ip USING btree (ip);


--
-- Name: blacklist_word_word; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX blacklist_word_word ON blacklist_word USING btree (word);


--
-- Name: nopaste_date_added; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX nopaste_date_added ON nopaste USING btree (date_added);


--
-- Name: nopaste_expires; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX nopaste_expires ON nopaste USING btree (expires);


--
-- Name: nopaste_id_hashed; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX nopaste_id_hashed ON nopaste USING btree (id_hashed);


--
-- Name: users_o_email_notification; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX users_o_email_notification ON users USING btree (o_email_notification);


--
-- Name: users_session; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX users_session ON users USING btree ("session");


--
-- Name: users_username; Type: INDEX; Schema: public; Owner: phi; Tablespace: 
--

CREATE INDEX users_username ON users USING btree (username);


--
-- Name: blacklist_country_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY blacklist_country
    ADD CONSTRAINT blacklist_country_settings_id_fkey FOREIGN KEY (settings_id) REFERENCES settings(id);


--
-- Name: blacklist_ip_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY blacklist_ip
    ADD CONSTRAINT blacklist_ip_settings_id_fkey FOREIGN KEY (settings_id) REFERENCES settings(id);


--
-- Name: blacklist_word_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY blacklist_word
    ADD CONSTRAINT blacklist_word_settings_id_fkey FOREIGN KEY (settings_id) REFERENCES settings(id);


--
-- Name: nopaste_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY nopaste
    ADD CONSTRAINT nopaste_settings_id_fkey FOREIGN KEY (settings_id) REFERENCES settings(id);


--
-- Name: users_has_settings_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY users_has_settings
    ADD CONSTRAINT users_has_settings_settings_id_fkey FOREIGN KEY (settings_id) REFERENCES settings(id);


--
-- Name: users_has_settings_users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: phi
--

ALTER TABLE ONLY users_has_settings
    ADD CONSTRAINT users_has_settings_users_id_fkey FOREIGN KEY (users_id) REFERENCES users(id);


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

