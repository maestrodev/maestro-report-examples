Maestro Report Examples
=======================

This package contains examples that show how to export data from a Maestro
Stats MongoDB instance into PostgreSQL and provide some reporting on top of
that data.

Structure
=========

    ├── README.md
    ├── etl
    │   ├── maestro_mongodb_pg_export.ktr         # kettle transformation script for exporting Maestro mongodb to PostgreSQL
    │   ├── maestro_mongodb_pg_export.sql         # sql script to generate maestro_stats db for reporting
    │   └── maestro_mongodb_pg_export.kjb         # kettle job script that executes the transformation
    ├── jndi
    │   ├── default.properties                    # jndi example to be located in ~/.pentaho/simple-jndi/default.properties
    │   └── jdbc.properties                       # jndi exmaple to be located in <data-integration-dir>/simple-jndi/jdbc.properties
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

1. Maestro 4.16+
2. Oracle JDK 1.6+
3. Pentaho Data Integration (http://sourceforge.net/projects/pentaho/files/Data%20Integration/4.4.0-stable/)
4. Pentaho Report Designer (http://sourceforge.net/projects/jfreereport/files/04.%20Report%20Designer/3.9.1-stable/) - *_Optional_*

Running
=======

Exporting data from Maestro Stats database (MongoDB) into PostgreSQL for reporting:

    1. Fetch and unbundle this package onto your Maestro server
    2. Configure ENV variables
       * \_PENTAHO\_JAVA\_HOME=<path\_to\_oracle\_jdk>     # e.g. export _PENTAHO_JAVA_HOME=~/jdk1.7.0_25
       * \KETTLE\_HOME=<path\_to\_data\_integration\_dir>  # e.g. export KETTLE_HOME=~/data-integration
    3. Create a new PostgreSQL database
       * createdb -U maestro -h localhost -W maestro\_stats # *-or-* as admin
       * createdb -O maestro maestro_stats
    4. Execute the etl/maestro\_mongodb\_pg\_export.sql SQL script on this database
       * psql -U maestro -h localhost -W -f etl/maestro\_mongodb\_pg\_export.sql maestro\_stats)
    5. Edit the simple-jndi/\*.properties files to match the PostgreSQL database & credentials to be used.
    6. $KETTLE\_HOME/kitchen.sh -file etl/maestro\_mongodb\_pg\_export.kjb -param:db\_database=<dbname> \-param:db\_password=<password>

This should run without errors and look something like this:



