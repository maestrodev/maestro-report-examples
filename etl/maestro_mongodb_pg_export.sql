drop table if exists runs; 
create table runs (
      run_id int,
      composition_id int,
      composition_name varchar(64),
      project_name varchar(64),
      success boolean,
      success_int int,
      failure_int int,
      start_time timestamp,
      end_time timestamp,
      json text,
      kettle_key BIGSERIAL,
      hashcode BIGINT,
      primary key (run_id)
);

DROP INDEX IF EXISTS "idx_runs_composition_id";
CREATE INDEX "idx_runs_composition_id" ON runs ( "composition_id" );

DROP INDEX IF EXISTS "idx_runs_end_time";
CREATE INDEX "idx_runs_end_time" ON runs ( "end_time" );

DROP INDEX IF EXISTS "idx_runs_pk";
CREATE UNIQUE INDEX "idx_runs_pk" ON runs ( "kettle_key" );

DROP INDEX IF EXISTS "idx_runs_lookup";
CREATE INDEX "idx_runs_lookup" ON runs ( "hashcode" );

DROP SEQUENCE IF EXISTS "public"."kettle_key_seq";
CREATE SEQUENCE "public"."kettle_key_seq" START WITH 1 INCREMENT BY 1;
