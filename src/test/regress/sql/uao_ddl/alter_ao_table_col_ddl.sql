CREATE TABLE sto_alt_uao1(
          text_col text default 'remove it',
          bigint_col bigint,
          char_vary_col character varying(30),
          numeric_col numeric,
          int_col int4 NOT NULL,
          float_col float4,
          int_array_col int[],
          before_rename_col int4,
          change_datatype_col numeric,
          date_column date,
          col_set_default numeric) with(appendonly=true) DISTRIBUTED RANDOMLY;

insert into sto_alt_uao1 values ('0_zero', 0, '0_zero', 0, 0, 0, '{0}', 0, 0, '1-1-2000', 0);
insert into sto_alt_uao1 values ('1_zero', 1, '1_zero', 1, 1, 1, '{1}', 1, 1, '1-1-2001', 1);
insert into sto_alt_uao1 values ('2_zero', 2, '2_zero', 2, 2, 2, '{2}', 2, 2, '1-1-2002', 2);
select count(*) = 3 as passed from sto_alt_uao1;
-- Alter table add column
Alter Table sto_alt_uao1 ADD COLUMN added_col character varying(30) default 'default';
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is not NULL AND
 visimapidxid is not NULL AND relid=(SELECT oid FROM pg_class WHERE relname='sto_alt_uao1');
update sto_alt_uao1 set added_col = 'newly added col'  where text_col = '1_zero';
select * from sto_alt_uao1 order by bigint_col;
set gp_select_invisible = true;
select count(*) AS all_tuples from sto_alt_uao1;
set gp_select_invisible = false;
-- Drop column
Alter Table sto_alt_uao1 DROP COLUMN date_column;
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is not NULL AND
 visimapidxid is not NULL AND relid=(SELECT oid FROM pg_class WHERE relname='sto_alt_uao1');
insert into sto_alt_uao1 values ('3_zero', 3, '0_zero', 3, 3, 3, '{3}', 0, 0, 0);
insert into sto_alt_uao1 values ('4_zero', 4, '1_zero', 4, 4, 4, '{4}', 1, 1, 1);
update sto_alt_uao1 set bigint_col = -bigint_col  where text_col = '3_zero';
delete from sto_alt_uao1 where numeric_col = 2;
select * from sto_alt_uao1 order by bigint_col;
set gp_select_invisible = true;
select count(*) AS all_tuples from sto_alt_uao1;
set gp_select_invisible = false;
-- Alter column type and rename
Alter Table sto_alt_uao1 ALTER COLUMN numeric_col TYPE int4;
Alter Table sto_alt_uao1 RENAME COLUMN numeric_col TO int4_col;
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is not NULL AND
 visimapidxid is not NULL AND relid=(SELECT oid FROM pg_class WHERE relname='sto_alt_uao1');
insert into sto_alt_uao1 values ('5_zero', 5, '0_zero', 5, 5, 5, '{3}', 0, 0, 0);
update sto_alt_uao1 set int4_col = int4_col+100;
select count(int4_col) = 5 as passed from sto_alt_uao1;
set gp_select_invisible = true;
select count(int4_col) from sto_alt_uao1;
set gp_select_invisible = false;
