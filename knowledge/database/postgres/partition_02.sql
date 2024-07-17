-- https://www.cybertec-postgresql.com/en/automatic-partition-creation-in-postgresql/#:~:text=Automatic%20partition%20creation%20for%20time%2Dtriggered%20partitioning,-The%20lack%20of&text=You%20can%20use%20the%20operating,ATTACH%20PARTITION%20statements.

CREATE TABLE tab (
   id bigint GENERATED ALWAYS AS IDENTITY,
   ts timestamp NOT NULL,
   data text
) PARTITION BY LIST ((ts::date));
 
CREATE TABLE tab_def PARTITION OF tab DEFAULT;


CREATE FUNCTION part_trig() RETURNS trigger
   LANGUAGE plpgsql AS
$$BEGIN
   BEGIN
      /* try to create a table for the new partition */
      EXECUTE
         format(
            'CREATE TABLE %I (LIKE tab INCLUDING INDEXES)',
            'tab_' || to_char(NEW.ts, 'YYYY-MM-DD')
         );
 
      /*
       * tell listener to attach the partition
       * (only if a new table was created)
       */
      EXECUTE
         format(
            'NOTIFY tab, %L',
            to_char(NEW.ts, 'YYYY-MM-DD')
         );
   EXCEPTION
      WHEN duplicate_table THEN
         NULL;  -- ignore
   END;
 
   /* insert into the new partition */
   EXECUTE
      format(
         'INSERT INTO %I VALUES ($1.*)',
         'tab_' || to_char(NEW.ts, 'YYYY-MM-DD')
      )
      USING NEW;
 
   /* skip insert into the partitioned table */
   RETURN NULL;
END;$$;
 
CREATE TRIGGER part_trig
   BEFORE INSERT ON TAB FOR EACH ROW
   WHEN (pg_trigger_depth() < 1)
   EXECUTE FUNCTION part_trig();


INSERT INTO tab (ts, data)
  SELECT clock_timestamp(), 'something'
  FROM generate_series(1, 100000);
