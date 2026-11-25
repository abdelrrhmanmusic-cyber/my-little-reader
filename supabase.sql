
create table settings(id int primary key default 1 check(id=1), site_name text default 'My Little Reader', phone text default '201156617653', facebook text default 'https://facebook.com/');
insert into settings(id) values(1);

create table products(id bigint generated always as identity primary key, sort int default 0, legacy int, name text not null, price int not null default 165, description text default '', cover_url text, gallery text[] default '{}');
insert into products(sort,legacy,name,price) values (1,1,'المستوى الأول – Short Vowels',165),(2,2,'المستوى الثاني – Long Vowels',165),(3,3,'المستوى الثالث',165);

create table shipping(id int primary key, name_ar text, name_en text, price int not null default 0);
insert into shipping values
(1,'القاهرة','Cairo',65),
(2,'الجيزة','Giza',65),
(3,'القليوبية','Qalyubia',65),
(4,'الإسكندرية','Alexandria',70),
(5,'بورسعيد','Port Said',80),
(6,'السويس','Suez',80),
(7,'الإسماعيلية','Ismailia',80),
(8,'دمياط','Damietta',80),
(9,'الدقهلية','Dakahlia',75),
(10,'الشرقية','Sharqia',75),
(11,'الغربية','Gharbia',75),
(12,'كفر الشيخ','Kafr El Sheikh',75),
(13,'المنوفية','Monufia',75),
(14,'البحيرة','Beheira',75),
(15,'الفيوم','Fayoum',80),
(16,'بني سويف','Beni Suef',80),
(17,'المنيا','Minya',85),
(18,'أسيوط','Asyut',90),
(19,'سوهاج','Sohag',90),
(20,'قنا','Qena',95),
(21,'الأقصر','Luxor',95),
(22,'أسوان','Aswan',100),
(23,'البحر الأحمر','Red Sea',100),
(24,'الوادي الجديد','New Valley',120),
(25,'مطروح','Matrouh',100),
(26,'شمال سيناء','North Sinai',120),
(27,'جنوب سيناء','South Sinai',110);

create table orders(id bigint generated always as identity primary key, created_at timestamptz not null default now(), customer_name text, phone text, address text, governorate text, items jsonb, subtotal int, shipping int, total int, message text);

create function is_admin() returns boolean language sql stable as $$ select coalesce(auth.jwt()->>'email','')='CHANGE_ME@example.com' $$;

alter table settings enable row level security;
alter table products enable row level security;
alter table shipping enable row level security;
alter table orders enable row level security;

create policy "read" on settings for select using (true);
create policy "read" on products for select using (true);
create policy "read" on shipping for select using (true);
create policy "admin" on settings for all using (is_admin()) with check (is_admin());
create policy "admin" on products for all using (is_admin()) with check (is_admin());
create policy "admin" on shipping for all using (is_admin()) with check (is_admin());
create policy "customers insert" on orders for insert to anon, authenticated with check (true);
create policy "admin read" on orders for select using (is_admin());
create policy "admin delete" on orders for delete using (is_admin());

insert into storage.buckets(id,name,public) values('images','images',true);
create policy "img read" on storage.objects for select using (bucket_id='images');
create policy "img admin" on storage.objects for all using (bucket_id='images' and is_admin()) with check (bucket_id='images' and is_admin());
