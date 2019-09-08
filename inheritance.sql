-- drop table customer cascade;
-- drop table person cascade;
-- drop table company cascade;

create table customer (
  customer_id integer not null,
  discr character not null,
  person_id integer,
  company_id integer,
  constraint customer_pkey  primary key (customer_id),
  constraint customer_exclusive_arc_check check (
    (discr = 'P' and person_id is not null and company_id is null) or
    (discr = 'C' and person_id is null and company_id is not null)),
  constraint customer_discriminator_uniq 
    unique (customer_id, discr));  

create table person (
  person_id integer primary key,
  discr character not null,
  constraint customer_discriminator_check 
    check (discr = 'P'),
  constraint person_references_customer_fkey 
    foreign key (person_id, discr)
    references customer (customer_id, discr) 
    deferrable initially deferred);

alter table customer
  add constraint customer_references_person_fkey foreign key (person_id)
      references person (person_id)
      deferrable initially deferred;

create index customer_references_person_fkey_covering_idx
on customer (person_id) where person_id is not null;    

create table company (
  company_id integer primary key,
  discr character not null,
  constraint customer_discriminator_check 
    check (discr = 'C'),
  constraint company_references_customer_fkey 
    foreign key (company_id, discr)
    references customer (customer_id, discr) 
    deferrable initially deferred);

alter table customer
  add constraint customer_references_company_fkey foreign key (company_id)
      references company (company_id)
      deferrable initially deferred;

create index customer_references_company_fkey_covering_idx
on customer (company_id) where company_id is not null;    

-- begin transaction

insert into customer (customer_id, discr, person_id, company_id)
values (1, 'P', 1, null),
       (2, 'C', null, 2); 

insert into person (person_id, discr)
values (1, 'P');

insert into company (company_id, discr)
values (2, 'C');

-- end transaction
