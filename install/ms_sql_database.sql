DROP TABLE IF EXISTS tbl_users;
DROP TABLE IF EXISTS tbl_games;
DROP TABLE IF EXISTS tbl_questions;
GO 

CREATE TABLE  tbl_games (
  PKID VARCHAR(40) NOT NULL,
  Running bit NOT NULL,
  SessionName varchar(45) NOT NULL,
  SessionPW varchar(45) NOT NULL,
  LangID varchar(2) NOT NULL,
  MinUser int NOT NULL,
  MaxUser int NOT NULL,
  CurrentUser VARCHAR(40),
  LastUpdate datetime NOT NULL CONSTRAINT DF_MyTable_CreateDate_GETDATE DEFAULT GETUTCDATE(),
  PRIMARY KEY (PKID)
);


CREATE TABLE tbl_users (
  PKID VARCHAR(40) NOT NULL,
  FKGameID VARCHAR(40) NOT NULL,
  Name VARCHAR(255) NULL,
  PRIMARY KEY (PKID),
  CONSTRAINT keyGames
    FOREIGN KEY (FKGameID)
    REFERENCES tbl_games (PKID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE tbl_questions (
  str_pkid VARCHAR(40) NOT NULL,
  str_question TEXT NOT NULL,
  PRIMARY KEY (str_pkid)
);