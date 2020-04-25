unit GameDBConnection;

interface

uses
  Aurelius.Drivers.Interfaces,
  Aurelius.Drivers.MSSQL, 
  System.SysUtils, System.Classes,
  Aurelius.Comp.Connection,
  Aurelius.Sql.MSSQL,
  Aurelius.Schema.MSSQL;

type
  TMSSQLConnection = class(TDataModule)
    JBConnection: TAureliusConnection;
  private
  public
    function CreateConnection: IDBConnection;
    function CreateFactory: IDBConnectionFactory;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  Aurelius.Sql.Register,
  Aurelius.Drivers.Base;

{$R *.dfm}

{ TMyConnectionModule }

function TMSSQLConnection.CreateConnection: IDBConnection;
begin
  (TSQLGeneratorRegister.GetInstance.GetGenerator('MSSQL') as TMSSQLSQLGenerator).UseBoolean := True;
  Result := JBConnection.CreateConnection;
end;

function TMSSQLConnection.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection;
    end
  );
end;

end.
