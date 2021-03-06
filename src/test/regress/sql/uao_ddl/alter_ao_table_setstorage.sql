BEGIN;
CREATE TABLE sto_alt_uao1_setstorage(
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
          col_set_default numeric) with(appendonly=true) DISTRIBUTED BY (text_col);

insert into sto_alt_uao1_setstorage values ('0_zero', 0, '0_zero', 0, 0, 0, '{0}', 0, 0, '1-1-2000',0);
insert into sto_alt_uao1_setstorage values ('1_zero', 1, '1_zero', 1, 1, 1, '{1}', 1, 1, '1-1-2001',1);
insert into sto_alt_uao1_setstorage values ('2_zero', 2, '2_zero', 2, 2, 2, '{2}', 2, 2, '1-1-2002',2);

-- Alter table SET STORAGE
Alter Table sto_alt_uao1_setstorage ALTER char_vary_col SET STORAGE PLAIN;
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is
not NULL AND visimapidxid is not NULL AND relid=(SELECT oid FROM
pg_class WHERE relname='sto_alt_uao1_setstorage');
insert into sto_alt_uao1_setstorage values ('2_zero', 2, '2_zero', 2, 2, 2, '{2}', 2, 2, '1-1-2002',2);
update sto_alt_uao1_setstorage set date_column = '2013-08-16' where text_col = '1_zero';
select * from sto_alt_uao1_setstorage order by bigint_col;
set gp_select_invisible = true;
select count(*)  AS invisi_and_visi_tups from sto_alt_uao1_setstorage;
set gp_select_invisible = false;

delete from  sto_alt_uao1_setstorage where text_col = '1_zero';
select * from sto_alt_uao1_setstorage order by bigint_col;
set gp_select_invisible = true;
select count(*)  AS invisi_and_visi_tups from sto_alt_uao1_setstorage;
set gp_select_invisible = false;

-- Alter table set reorganize
Alter Table sto_alt_uao1_setstorage set with (reorganize='true')
 distributed by (bigint_col);
update sto_alt_uao1_setstorage set numeric_col = -bigint_col;
select * from sto_alt_uao1_setstorage;
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is
not NULL AND visimapidxid is not NULL AND relid=(SELECT oid FROM
pg_class WHERE relname='sto_alt_uao1_setstorage');

set gp_setwith_alter_storage = true;
Alter Table sto_alt_uao1_setstorage set with (appendonly=false);
select count(*) from sto_alt_uao1_setstorage;
Alter Table sto_alt_uao1_setstorage
 set with (appendonly=true, compresslevel=3);
set gp_setwith_alter_storage = false;
update sto_alt_uao1_setstorage set numeric_col = -numeric_col;
delete from sto_alt_uao1_setstorage where numeric_col = 0;
select * from sto_alt_uao1_setstorage;
set gp_select_invisible=true;
select count(*) from sto_alt_uao1_setstorage;
set gp_select_invisible=false;
SELECT 1 AS VisimapPresent FROM pg_appendonly WHERE visimapidxid is
not NULL AND visimapidxid is not NULL AND relid=(SELECT oid FROM
pg_class WHERE relname='sto_alt_uao1_setstorage');
COMMIT;
