## some error 
 - PostgrestException(message: duplicate key value violates unique constraint "barbers_pkey", code: 23505, details: , hint: null)

- my taple is 
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

create index IF not exists idx_barbers_name on public.barbers using btree (name) TABLESPACE pg_default; 


- dont sent the id with your fun . 