## barber add 
 - PostgrestException(message: Could not find the 'branch_id' column of 'barbers' in the schema cache, code: PGRST204, details: , hint: null)


 - the table 
 create table public.barbers (
  id serial not null,
  branchid integer not null,
  name character varying(255) not null,
  phone character varying(20) null,
  email character varying(255) null,
  specializations jsonb null,
  isactive boolean not null default true,
  createdat timestamp without time zone not null default CURRENT_TIMESTAMP,
  updatedat timestamp without time zone not null default CURRENT_TIMESTAMP,
  constraint barbers_pkey primary key (id),
  constraint barbers_branchid_fk foreign KEY (branchid) references branches (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_barbers_branchid on public.barbers using btree (branchid) TABLESPACE pg_default;

create index IF not exists idx_barbers_active on public.barbers using btree (isactive) TABLESPACE pg_default;

create index IF not exists idx_barbers_name on public.barbers using btree (name) TABLESPACE pg_default;



## sec isuue 
 PostgrestException(message: Could not find the 'is_active' column of 'barbers' in the schema cache, code: PGRST204, details: , hint: null)
  
  - create table public.barbers (
  id serial not null,
  branchid integer not null,
  name character varying(255) not null,
  phone character varying(20) null,
  email character varying(255) null,
  specializations jsonb null,
  isactive boolean not null default true,
  createdat timestamp without time zone not null default CURRENT_TIMESTAMP,
  updatedat timestamp without time zone not null default CURRENT_TIMESTAMP,
  constraint barbers_pkey primary key (id),
  constraint barbers_branchid_fk foreign KEY (branchid) references branches (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_barbers_branchid on public.barbers using btree (branchid) TABLESPACE pg_default;

create index IF not exists idx_barbers_active on public.barbers using btree (isactive) TABLESPACE pg_default;

create index IF not exists idx_barbers_name on public.barbers using btree (name) TABLESPACE pg_default;   this is the barbers table in the database



