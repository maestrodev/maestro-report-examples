Maestro Report Examples
=======================

This package contains scripts that provide a way to export data from a Maestro
Stats MongoDB instance into a PostgreSQL database for reporting.  There are also 
example reports that use the resulting exported data.

Structure
=========

    ├── README.md
    ├── etl
    │   ├── maestro_mongodb_pg_export.ktr         # kettle transformation script for exporting Maestro mongodb to PostgreSQL
    │   ├── maestro_mongodb_pg_export.sql         # sql script to generate maestro_stats db for reporting
    │   └── maestro_mongodb_pg_export.kjb         # kettle job script that executes the transformation
    ├── jndi
    │   └── jdbc.properties                       # jndi connection info that should be modified to match your maestro_stats DB
    └── reports
        ├── generate_pdf_report.kjb               # generic report running job script that targets the PDF transformation
        ├── generate_pdf_report.ktr               # generic report transformation script that outputs a PDF
        ├── maestro_build_stability_report.kjb    # example build stability report job
        ├── maestro_build_stability_report.ktr    # example build stability report transformation
        ├── maestro_build_stability_report.prpt   # example build stability report
        ├── maestro_recent_build_report.kjb       # example recent build report job
        ├── maestro_recent_build_report.ktr       # example recent build report transformation
        └── maestro_recent_build_report.prpt      # example recent build report

Requirements
============

* Maestro 4.16+
* Oracle JDK 1.6+
* Pentaho Data Integration (http://sourceforge.net/projects/pentaho/files/Data%20Integration/4.4.0-stable/)
* Pentaho Report Designer (http://sourceforge.net/projects/jfreereport/files/04.%20Report%20Designer/3.9.1-stable/) - _Optional_

Running
=======

**Exporting data from Maestro Stats database (MongoDB) into PostgreSQL**


Fetch and unbundle this package onto your Maestro server

    git clone https://github.com/maestrodev/maestro-report-examples.git  # git

Configure ENV variables

    PENTAHO_JAVA_HOME=<path_to_oracle_jdk>     # e.g. export PENTAHO_JAVA_HOME=~/jdk1.7.0_25
    KETTLE_HOME=<path_to_data_integration_dir>  # e.g. export KETTLE_HOME=~/data-integration
    
Create a new PostgreSQL database

    createdb -U maestro -h localhost -W maestro_stats # OR as postgres admin...
    createdb -O maestro maestro_stats


Change to the maestro-report-examples directory

    cd maestro-report-examples
    
Execute the etl/maestro_mongodb_pg_export.sql SQL script on this database

    psql -U maestro -h localhost -W -f etl/maestro_mongodb_pg_export.sql maestro_stats)
    
Edit the simple-jndi/*.properties files to reflect your Maestro Stats PostgreSQL database & credentials.

    maestro_stats/type=javax.sql.DataSource
    maestro_stats/driver=org.postgresql.Driver
    maestro_stats/user=maestro
    maestro_stats/password=<password>
    maestro_stats/url=dbc:postgresql://localhost:5432/maestro_stats

Execute the database ETL script, which pushed data from MongoDB into PostgreSQL.  The maestro_mongodb_pg_export job can take
several database connection parameters as needed: db_hostname, db_port, db_database, db_username, db_password.

    $KETTLE_HOME/kitchen.sh -file etl/maestro_mongodb_pg_export.kjb -param:db_database=<dbname> -param:db_password=<password>

This final step should have run without errors and look something like the following:

    [user@maestro maestro-report-examples]$ $KETTLE_HOME/kitchen.sh -file etl/maestro_mongodb_pg_export.kjb -param:db_database=maestro_stats -param:db_password=maestro
    WARN  18-07 18:15:44,246 - Unable to load Hadoop Configuration from "file:///home/user/data-integration/plugins/pentaho-big-data-plugin/hadoop-configurations/mapr". For more information enable debug logging.
    INFO  18-07 18:15:44,340 - Kitchen - Start of run.
    INFO  18-07 18:15:44,435 - maestro_mongodb_pg_export - Start of job execution
    INFO  18-07 18:15:44,441 - maestro_mongodb_pg_export - Starting entry [Maestro MongoDB PG Export Transformation]
    INFO  18-07 18:15:44,449 - Maestro MongoDB PG Export Transformation - Loading transformation from XML file [file:///home/user/maestro-report-examples/etl/maestro_mongodb_pg_export.ktr]
    INFO  18-07 18:15:44,722 - maestro_mongodb_pg_export - Dispatching started for transformation [maestro_mongodb_pg_export]
    INFO  18-07 18:16:24,817 - MongoDb Input - Finished processing (I=0, O=0, R=0, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,868 - Json Input - Finished processing (I=19610, O=0, R=19610, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,870 - Create success_int - Finished processing (I=0, O=0, R=19610, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,872 - Create failure_int - Finished processing (I=0, O=0, R=19610, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,874 - Select values - Finished processing (I=0, O=0, R=19610, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,905 - postgresql export - Finished processing (I=19610, O=0, R=19610, W=19610, U=0, E=0)
    INFO  18-07 18:16:49,911 - maestro_mongodb_pg_export - Starting entry [Success]
    INFO  18-07 18:16:49,913 - maestro_mongodb_pg_export - Finished job entry [Success] (result=[true])
    INFO  18-07 18:16:49,914 - maestro_mongodb_pg_export - Finished job entry [Maestro MongoDB PG Export Transformation] (result=[true])
    INFO  18-07 18:16:49,914 - maestro_mongodb_pg_export - Job execution finished
    INFO  18-07 18:16:49,915 - Kitchen - Finished!
    INFO  18-07 18:16:49,916 - Kitchen - Start=2013/07/18 18:15:44.342, Stop=2013/07/18 18:16:49.915
    INFO  18-07 18:16:49,916 - Kitchen - Processing ended after 1 minutes and 5 seconds (65 seconds total).


And the _postgresql export_ output step should show the number of records successfully exported (e.g. W=19610).


**Generating example reports**

Change to the maestro-report-examples directory

    cd maestro-report-examples
    
Execute a report job with the desired input report and output filename.  For example:

    # Recent Builds Report
    $KETTLE_HOME/kitchen.sh -file reports/generate_pdf_report.kjb -param:report_input_file=reports/maestro_recent_build_report.prpt -param:report_output_file=out/maestro_recent_build_report.pdf
    
    # Build Stability Report
    $KETTLE_HOME/kitchen.sh -file reports/generate_pdf_report.kjb -param:report_input_file=reports/maestro_build_stability_report.prpt -param:report_output_file=out/maestro_build_stability_report.pdf

The above reports will be written to the _out_ directory with maestro-report-examples as PDFs.


Notes
=====

**More Tools**

Other freely available tools also exist for creating reports from MongoDB, including but not limited to:

* [BIRT](http://www.eclipse.org/birt/)
* [Jaspersoft iReport Designer](http://community.jaspersoft.com/project/ireport-designer)


**MongoDB Tweaks**

Some MongoDB-related tools will require that your MongoDB instance be configured to 
allow queries through its restful interface.  This can be accomplished in a couple different ways:

    # execute monogod with the --rest flag
    ./mongod --rest
    
    # modify the mongod configuration file (/etc/mongod.conf) to include the flag
    rest=true

