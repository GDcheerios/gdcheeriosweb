--
-- PostgreSQL database dump
--

\restrict vgv3WUmyFDwSDk7NHl3yq4SKPg8fiz6fj7xa2CuBHFNLoM9VoQ6AJ1iieemmkus

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: account_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.account_status AS ENUM (
    'gqc_online',
    'gq_online',
    'offline',
    'restricted',
    'test'
);


--
-- Name: api_key_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.api_key_status AS ENUM (
    'active',
    'revoked',
    'expired'
);


--
-- Name: gq_statistic_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gq_statistic_type AS ENUM (
    'heal',
    'player_damage',
    'enemy_damage',
    'kill',
    'death',
    'money_gained',
    'money_spent',
    'effect_add',
    'hit_enemy',
    'hit_player',
    'item_add',
    'item_remove'
);


--
-- Name: item_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.item_type AS ENUM (
    'character',
    'artifact',
    'weapon'
);


--
-- Name: tag_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tag_type AS ENUM (
    'unique',
    'dev',
    'event',
    'gd',
    'rare'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_tags (
    id integer NOT NULL,
    account integer NOT NULL,
    title text NOT NULL,
    type public.tag_type
);


--
-- Name: account_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_tags_id_seq OWNED BY public.account_tags.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    username character varying(24) NOT NULL,
    password character varying(100) NOT NULL,
    email character varying(64) NOT NULL,
    about text,
    status public.account_status DEFAULT 'offline'::public.account_status NOT NULL,
    created timestamp without time zone DEFAULT now(),
    is_supporter boolean DEFAULT false NOT NULL,
    last_support timestamp with time zone,
    supporter_lasts timestamp with time zone,
    is_admin boolean DEFAULT false NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key_id text NOT NULL,
    secret_hash text NOT NULL,
    name text,
    scopes jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    expires_at timestamp with time zone,
    status public.api_key_status DEFAULT 'active'::public.api_key_status NOT NULL,
    created_by_ip inet,
    last_used_ip inet,
    metadata jsonb,
    user_id bigint,
    refresh_token_hash text,
    refresh_token_expires_at timestamp with time zone,
    last_refreshed_at timestamp with time zone,
    rotated_from_key_id text
);


--
-- Name: auth_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_identities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer,
    provider text NOT NULL,
    provider_subject text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: gq_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_items (
    id bigint NOT NULL,
    type public.item_type NOT NULL,
    metadata jsonb NOT NULL,
    rating integer DEFAULT 0 NOT NULL,
    owner integer,
    new boolean DEFAULT false,
    obtained timestamp without time zone DEFAULT now()
);


--
-- Name: gentrys_quest_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gentrys_quest_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gentrys_quest_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gentrys_quest_items_id_seq OWNED BY public.gq_items.id;


--
-- Name: gq_artifacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_artifacts (
    id smallint NOT NULL,
    name text NOT NULL
);


--
-- Name: gq_artifacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gq_artifacts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gq_artifacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gq_characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_characters (
    name text NOT NULL,
    id smallint NOT NULL
);


--
-- Name: gq_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gq_characters ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gq_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gq_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_data (
    id integer,
    money bigint
);


--
-- Name: gq_enemies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_enemies (
    id smallint NOT NULL,
    name text NOT NULL
);


--
-- Name: gq_enemies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gq_enemies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gq_enemies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gq_leaderboards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_leaderboards (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    online boolean NOT NULL
);


--
-- Name: gq_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_locations (
    id smallint NOT NULL,
    name text NOT NULL
);


--
-- Name: gq_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_metrics (
    id integer NOT NULL,
    user_id integer,
    recorded_at date DEFAULT now() NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    gp integer DEFAULT 0 NOT NULL
);


--
-- Name: gq_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gq_metrics ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gq_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gq_rankings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_rankings (
    id integer,
    weighted smallint DEFAULT 0 NOT NULL,
    unweighted integer DEFAULT 0 NOT NULL,
    rank character varying(16) DEFAULT 'unranked'::character varying NOT NULL,
    tier smallint DEFAULT 0 NOT NULL
);


--
-- Name: gq_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_scores (
    id bigint NOT NULL,
    name character varying(24) NOT NULL,
    score bigint NOT NULL,
    leaderboard integer NOT NULL,
    "user" integer,
    submitted_at timestamp with time zone DEFAULT now() NOT NULL,
    visitation uuid
);


--
-- Name: gq_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_statistics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "user" integer NOT NULL,
    type public.gq_statistic_type NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    enemy integer,
    "character" integer,
    weapon integer,
    location integer,
    happened timestamp with time zone DEFAULT now() NOT NULL,
    status_effect integer,
    visitation uuid,
    leaderboard integer,
    artifact integer
);


--
-- Name: gq_status_effects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_status_effects (
    id integer NOT NULL,
    name integer NOT NULL
);


--
-- Name: gq_visitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_visitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer,
    location integer,
    arrived timestamp with time zone DEFAULT now() NOT NULL,
    departed timestamp with time zone
);


--
-- Name: gq_weapons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gq_weapons (
    id smallint NOT NULL,
    name text NOT NULL
);


--
-- Name: gq_weapons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gq_weapons ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gq_weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: leaderboard_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leaderboard_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leaderboard_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leaderboard_scores_id_seq OWNED BY public.gq_scores.id;


--
-- Name: leaderboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leaderboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leaderboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leaderboards_id_seq OWNED BY public.gq_leaderboards.id;


--
-- Name: osu_match_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.osu_match_users (
    match integer,
    "user" bigint,
    starting_score bigint DEFAULT 0 NOT NULL,
    starting_playcount bigint DEFAULT 0 NOT NULL,
    nickname character varying(32),
    ending_score bigint,
    ending_playcount bigint,
    team text
);


--
-- Name: osu_matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.osu_matches (
    id integer NOT NULL,
    name character varying(32),
    open boolean DEFAULT true NOT NULL,
    pinned boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    started timestamp with time zone DEFAULT now() NOT NULL,
    opener integer NOT NULL
);


--
-- Name: osu_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.osu_matches ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.osu_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: osu_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.osu_users (
    id bigint,
    username character varying(16),
    score bigint DEFAULT 0 NOT NULL,
    playcount integer DEFAULT 0 NOT NULL,
    accuracy numeric(5,2) DEFAULT 0 NOT NULL,
    performance integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    last_refresh timestamp with time zone DEFAULT now() NOT NULL,
    avatar text DEFAULT 'https://a.ppy.sh/1'::text NOT NULL,
    background text DEFAULT 'https://c4.wallpaperflare.com/wallpaper/39/35/772/osu-games-art-digital-art-hd-wallpaper-preview.jpg'::text NOT NULL
);


--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_resets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "user" bigint NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '01:00:00'::interval) NOT NULL
);


--
-- Name: pending_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pending_accounts (
    username character varying(24) NOT NULL,
    email text NOT NULL,
    about text,
    password character varying(100) NOT NULL,
    sent timestamp with time zone DEFAULT now() NOT NULL,
    expires timestamp with time zone DEFAULT (now() + '24:00:00'::interval) NOT NULL,
    token text NOT NULL,
    id bigint NOT NULL
);


--
-- Name: pending_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pending_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pending_accounts_id_seq OWNED BY public.pending_accounts.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    endpoint text NOT NULL,
    "user" integer,
    ip inet,
    sent timestamp with time zone DEFAULT now() NOT NULL,
    duration numeric DEFAULT 0 NOT NULL,
    successful boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN requests.duration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.requests.duration IS 'how long the request took to finish';


--
-- Name: server; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.server (
    key character varying(24) NOT NULL,
    value character varying(1000) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "user" integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: supports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "user" bigint,
    weeks integer DEFAULT 1 NOT NULL,
    supported_on timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: account_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_tags ALTER COLUMN id SET DEFAULT nextval('public.account_tags_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: gq_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_items ALTER COLUMN id SET DEFAULT nextval('public.gentrys_quest_items_id_seq'::regclass);


--
-- Name: gq_leaderboards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_leaderboards ALTER COLUMN id SET DEFAULT nextval('public.leaderboards_id_seq'::regclass);


--
-- Name: gq_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_scores ALTER COLUMN id SET DEFAULT nextval('public.leaderboard_scores_id_seq'::regclass);


--
-- Name: pending_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_accounts ALTER COLUMN id SET DEFAULT nextval('public.pending_accounts_id_seq'::regclass);


--
-- Name: account_tags account_tags_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_tags
    ADD CONSTRAINT account_tags_pk PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_key_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_id_key UNIQUE (key_id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: gq_items gentrys_quest_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_items
    ADD CONSTRAINT gentrys_quest_items_pkey PRIMARY KEY (id);


--
-- Name: gq_artifacts gq_artifacts_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_artifacts
    ADD CONSTRAINT gq_artifacts_pk PRIMARY KEY (id);


--
-- Name: gq_characters gq_characters_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_characters
    ADD CONSTRAINT gq_characters_pk PRIMARY KEY (id);


--
-- Name: gq_enemies gq_enemies_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_enemies
    ADD CONSTRAINT gq_enemies_pk PRIMARY KEY (id);


--
-- Name: gq_locations gq_locations_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_locations
    ADD CONSTRAINT gq_locations_pk PRIMARY KEY (id);


--
-- Name: gq_metrics gq_metrics_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_metrics
    ADD CONSTRAINT gq_metrics_pk PRIMARY KEY (id);


--
-- Name: gq_status_effects gq_status_effects_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_status_effects
    ADD CONSTRAINT gq_status_effects_pk PRIMARY KEY (id);


--
-- Name: gq_visitations gq_visitations_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_visitations
    ADD CONSTRAINT gq_visitations_pk PRIMARY KEY (id);


--
-- Name: gq_weapons gq_weapons_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_weapons
    ADD CONSTRAINT gq_weapons_pk PRIMARY KEY (id);


--
-- Name: gq_scores leaderboard_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_scores
    ADD CONSTRAINT leaderboard_scores_pkey PRIMARY KEY (id);


--
-- Name: gq_leaderboards leaderboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_leaderboards
    ADD CONSTRAINT leaderboards_pkey PRIMARY KEY (id);


--
-- Name: osu_matches osu_matches_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.osu_matches
    ADD CONSTRAINT osu_matches_pk PRIMARY KEY (id);


--
-- Name: pending_accounts pending_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pending_accounts_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pk PRIMARY KEY (id);


--
-- Name: gq_data unique_data_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_data
    ADD CONSTRAINT unique_data_id UNIQUE (id);


--
-- Name: gq_rankings unique_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_rankings
    ADD CONSTRAINT unique_id UNIQUE (id);


--
-- Name: idx_api_keys_last_used_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_last_used_at ON public.api_keys USING btree (last_used_at);


--
-- Name: idx_api_keys_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_status ON public.api_keys USING btree (status);


--
-- Name: account_tags account_tags_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_tags
    ADD CONSTRAINT account_tags_accounts_id_fk FOREIGN KEY (account) REFERENCES public.accounts(id);


--
-- Name: api_keys api_keys_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.accounts(id);


--
-- Name: auth_identities auth_identities_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_identities
    ADD CONSTRAINT auth_identities_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.accounts(id);


--
-- Name: gq_data fk_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_data
    ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: gq_rankings fk_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_rankings
    ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: gq_scores fk_leaderboards; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_scores
    ADD CONSTRAINT fk_leaderboards FOREIGN KEY (leaderboard) REFERENCES public.gq_leaderboards(id) ON DELETE CASCADE;


--
-- Name: gq_items fk_owner; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_items
    ADD CONSTRAINT fk_owner FOREIGN KEY (owner) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: gq_scores fk_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_scores
    ADD CONSTRAINT fk_user FOREIGN KEY ("user") REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: gq_scores gq_scores_gq_visitations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_scores
    ADD CONSTRAINT gq_scores_gq_visitations_id_fk FOREIGN KEY (visitation) REFERENCES public.gq_visitations(id);


--
-- Name: gq_statistics gq_statistics_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_accounts_id_fk FOREIGN KEY ("user") REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: gq_statistics gq_statistics_gq_artifacts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_artifacts_id_fk FOREIGN KEY (artifact) REFERENCES public.gq_artifacts(id);


--
-- Name: gq_statistics gq_statistics_gq_characters_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_characters_id_fk FOREIGN KEY ("character") REFERENCES public.gq_characters(id) ON DELETE CASCADE;


--
-- Name: gq_statistics gq_statistics_gq_enemies_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_enemies_id_fk FOREIGN KEY (enemy) REFERENCES public.gq_enemies(id) ON DELETE CASCADE;


--
-- Name: gq_statistics gq_statistics_gq_leaderboards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_leaderboards_id_fk FOREIGN KEY (leaderboard) REFERENCES public.gq_leaderboards(id);


--
-- Name: gq_statistics gq_statistics_gq_locations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_locations_id_fk FOREIGN KEY (location) REFERENCES public.gq_locations(id) ON DELETE CASCADE;


--
-- Name: gq_statistics gq_statistics_gq_status_effects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_status_effects_id_fk FOREIGN KEY (status_effect) REFERENCES public.gq_status_effects(id);


--
-- Name: gq_statistics gq_statistics_gq_weapons_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_statistics
    ADD CONSTRAINT gq_statistics_gq_weapons_id_fk FOREIGN KEY (weapon) REFERENCES public.gq_weapons(id);


--
-- Name: gq_visitations gq_visitations_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_visitations
    ADD CONSTRAINT gq_visitations_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.accounts(id);


--
-- Name: gq_visitations gq_visitations_gq_locations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gq_visitations
    ADD CONSTRAINT gq_visitations_gq_locations_id_fk FOREIGN KEY (location) REFERENCES public.gq_locations(id);


--
-- Name: osu_matches osu_matches_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.osu_matches
    ADD CONSTRAINT osu_matches_accounts_id_fk FOREIGN KEY (opener) REFERENCES public.accounts(id);


--
-- Name: requests requests_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_accounts_id_fk FOREIGN KEY ("user") REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: supports supports_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supports
    ADD CONSTRAINT supports_accounts_id_fk FOREIGN KEY ("user") REFERENCES public.accounts(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vgv3WUmyFDwSDk7NHl3yq4SKPg8fiz6fj7xa2CuBHFNLoM9VoQ6AJ1iieemmkus

