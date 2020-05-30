-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

CREATE TABLE IF NOT EXISTS ?tbl_name (
                  LOGIN_TIMESTAMP   TIMESTAMP PRIMARY KEY NOT NULL,
                  USERNAME   CHAR(50) NOT NULL)
