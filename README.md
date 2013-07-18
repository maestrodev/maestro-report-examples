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


