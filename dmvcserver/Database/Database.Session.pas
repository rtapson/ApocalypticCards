unit Database.Session;

interface

uses
  Database.Session.Types,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.ObjectManager;

type
  TDatabaseSession = class(TInterfacedObject, IDatabaseSession)
  private
    FConnection: IDBConnection;
    FDatabaseManager: TDatabaseManager;
    FObjectManager: TObjectManager;
  public
    constructor Create(const aConnection: IDBConnection);
    destructor Destroy; override;

    function databaseManager: TDatabaseManager;
    function objectManager: TObjectManager;
  end;

implementation

{ TDatabaseSession }

constructor TDatabaseSession.Create(const aConnection: IDBConnection);
begin
  Assert(aConnection <> nil);
  inherited Create;
  FConnection := aConnection;
end;

function TDatabaseSession.databaseManager: TDatabaseManager;
begin
  if not Assigned(FDatabaseManager) then
    FDatabaseManager := TDatabaseManager.Create(FConnection);
  Result := FDatabaseManager;
end;

destructor TDatabaseSession.Destroy;
begin
  FDatabaseManager.Free;
  FObjectManager.Free;
  inherited;
end;

function TDatabaseSession.objectManager: TObjectManager;
begin
  if not Assigned(FObjectManager) then
    FObjectManager := TObjectManager.Create(FConnection);
  Result := FObjectManager;
end;

end.
