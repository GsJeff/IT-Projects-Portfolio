# LRCH Hospital Database Project

This project contains the database design and supporting documentation for the LRCH hospital database.

## Project Files

- `LRCH_DDL_FINAL.sql` — SQL Server database and schema script.
- `3nfERD (1).vsdx` — entity-relationship diagram.
- `DataDictionary_LRCH_Final_Final.docx` — data dictionary.
- `Queries_LRCH.docx` — project queries and supporting documentation.

## Important

Review the DDL script before running it. It switches to the `master` database, changes the `LRCH` database to single-user mode, and drops `LRCH` if it exists. It also contains machine-specific SQL Server file paths. Do not run it against a database or server containing data you need to keep; adapt it for an isolated development environment first.
