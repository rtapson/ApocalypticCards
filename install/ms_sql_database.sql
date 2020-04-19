DROP TABLE IF EXISTS developer.userbase;
DROP TABLE IF EXISTS developer.deckbase;
DROP TABLE IF EXISTS developer.deckQbase;
DROP TABLE IF EXISTS developer.answerbase;
DROP TABLE IF EXISTS developer.questionbase;
DROP TABLE IF EXISTS tbl_gamebase;
DROP TABLE IF EXISTS tbl_questions;
DROP SCHEMA IF EXISTS developer
GO 

CREATE SCHEMA [developer]
GO


CREATE TABLE tbl_questions (
  str_pkid VARCHAR(40) NOT NULL,
  str_question TEXT NOT NULL,
  PRIMARY KEY (str_pkid)
);


/* API/
- Show list of active sessions!
// Button Start New Game
// Client ask for UserSessionName and perhaps PW (if closed group)
//        ask min and max user
API/startjson?SessionID="hGASjsd6"&SessionName="Franks Game"&SessionPW=""&MinUser=4&MaxUser=6
// Result is {SessionID:"hGASjsd6"}
// new Entry in Gamebase */


CREATE TABLE  tbl_gamebase (
  PKID VARCHAR(40) NOT NULL,
  Running bit NOT NULL,  
  SessionName varchar(45) NOT NULL,
  SessionPW varchar(45) NOT NULL,
  LangID varchar(2) NOT NULL,
  MinUser int NOT NULL,
  MaxUser int NOT NULL,
  Position_In_QDeck int NOT NULL,
  Position_In_ADeck int NOT NULL,
  Act_Master varchar(45) NOT NULL,
  Acc_QDeckID int NOT NULL,
  PRIMARY KEY (PKID)
);


/* 
API/Run?SessionID="hGASjsd6"
// Question and Answer DESK is created with SessionID shuffled
// Session set to Running
// Assign 10 Cards to All Users
// Result should be the First Quetion for Display. (Acc_QDeckID)
*/


CREATE TABLE  developer.questionbase (
  PKID VARCHAR(40) NOT NULL,
  URL bit NOT NULL,
  Question varchar(250) NOT NULL,
  LangID varchar(2) NOT NULL,
  MinAnswerCards int NOT NULL,
  PRIMARY KEY (PKID)
);


CREATE TABLE  developer.answerbase (
  PKID VARCHAR(40) NOT NULL,
  URL bit NOT NULL,
  Answer varchar(250) NOT NULL,
  LangID varchar(2) NOT NULL,
  PRIMARY KEY (PKID)
);


CREATE TABLE  developer.deckbase (
  PKID VARCHAR(40) NOT NULL,
  SessionID varchar(8) NOT NULL,
  Quertion int NOT NULL, -- // Pointer to QuetionBaseID
  PRIMARY KEY (PKID)
);

/*
API/JoinGame?SessionID="hGASjsd6"&SessionName="Glenn"&SessionPW=""
// Result UserToken
API/ClickCard?SessionID="hGASjsd6"&UserToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"&CardNr=2
API/ClickCard?SessionID="hGASjsd6"&UserToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"&CardNr=4
API/ClickCard?SessionID="hGASjsd6"&UserToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"&CardNr=2
API/ClickCard?SessionID="hGASjsd6"&UserToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"&CardNr=6
// Result Selected_1=2
// Result Selected_2=4                            {EAC84404-8A36-4839-ADE0-BE9B14278315}
// Result Selected_1=-1
// Result Selected_1=6

API/Pullanswers?SessionID="hGASjsd6"&MasterToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"
// Result Not Ready | Selection Result from all Users
API/FinalPull?SessionID="hGASjsd6"&MasterToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"
// Selection Result from all Users that have done the selection in time

// Show results to Master

API/SelectResult?SessionID="hGASjsd6"&MasterToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"&UserToken="{EAC84404-8A36-4839-ADE0-BE9B14278315}"
// Collect Points
// Redraw from deck
// Select next Master

*/
CREATE TABLE  developer.userbase (
  PKID VARCHAR(40) NOT NULL,
  SessionID varchar(8) NOT NULL,
  UserToken varchar(42) DEFAULT NULL,
  Name varchar(64) DEFAULT NULL,
  Points int NOT NULL,
  Card_0 int NOT NULL,
  Card_1 int NOT NULL,
  Card_2 int NOT NULL,
  Card_3 int NOT NULL,
  Card_4 int NOT NULL,
  Card_5 int NOT NULL,
  Card_6 int NOT NULL,
  Card_7 int NOT NULL,
  Selected_1 int NOT NULL,
  Selected_2 int NOT NULL,
  PRIMARY KEY (PKID) 
);
