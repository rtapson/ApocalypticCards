unit Database.Session.Types;

interface

uses
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager;

type
  IDatabaseSession = interface
    ['{81CE4FD2-BF83-448F-918C-AF88738F33E1}']
    function databaseManager: TDatabaseManager;
    function objectManager: TObjectManager;
  end;

implementation

end.
