-- Grant all permissions on tables to anon and authenticated users
-- This is for development purposes only - in production, use more restrictive policies

-- Grant usage on schema
grant usage on schema public to anon, authenticated;

-- Grant all permissions on tables
grant all on table public.reservations to anon, authenticated;
grant all on table public.barbers to anon, authenticated;
grant all on table public.branches to anon, authenticated;
grant all on table public.services to anon, authenticated;
grant all on table public.offers to anon, authenticated;
grant all on table public.time_slots to anon, authenticated;
grant all on table public.haircut_images to anon, authenticated;

-- Grant all permissions on sequences (for auto-increment IDs)
grant all on sequence public.reservations_id_seq to anon, authenticated;
grant all on sequence public.barbers_id_seq to anon, authenticated;
grant all on sequence public.branches_id_seq to anon, authenticated;
grant all on sequence public.services_id_seq to anon, authenticated;
grant all on sequence public.offers_id_seq to anon, authenticated;
grant all on sequence public.time_slots_id_seq to anon, authenticated;
grant all on sequence public.haircut_images_id_seq to anon, authenticated;

-- Alternatively, if you prefer to use default privileges (for future tables)
alter default privileges in schema public grant all on tables to anon, authenticated;
alter default privileges in schema public grant all on sequences to anon, authenticated;