unit wmGameData;

interface

uses System.SysUtils,
     System.Classes,
     Web.HTTPApp,
     MVCFramework,
     Spring.Container;

type
  TGameDataWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
    FContainer: TContainer;
    procedure BuildContainer;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TGameDataWebModule;

implementation

{$R *.dfm}

uses
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.Middleware.Compression,
  MVCFramework.Serializer.JsonDataObjects.CustomTypes,
  Aurelius.Drivers.Interfaces,
  Database.Session.Types,
  Database.Session,
  GameDBConnection,
  GameDataController,
  UserController;

procedure TGameDataWebModule.BuildContainer;
begin
  FContainer := TContainer.Create;

  FContainer.RegisterType<IDatabaseSession, TDatabaseSession>
    .DelegateTo(function: TDatabaseSession
                var
                  conn: TMSSQLConnection;
                begin
                  conn := TMSSQLConnection.Create(nil);
                  try
                    Result := TDatabaseSession.Create(conn.CreateConnection);
                  finally
                    conn.Free;
                  end;
                end);

  //Add container registrations here....
  FContainer.RegisterType<TGameDataController>;
  FMVC.AddController(TGameDataController,
                    function: TMVCController
                    begin
                      Result := FContainer.Resolve<TGameDataController>;
                    end);

  FContainer.RegisterType<TUserController>;
  FMVC.AddController(TUserController,
                    function: TMVCController
                    begin
                      Result := FContainer.Resolve<TUserController>;
                    end);

  // Build the container
  FContainer.Build;
end;

procedure TGameDataWebModule.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      //enable static files
      Config[TMVCConfigKey.DocumentRoot] := TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www');
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      //view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Define a default URL for requests that don't map to a route or a file (useful for client side web app)
      Config[TMVCConfigKey.FallbackResource] := 'index.html';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
    end);

    BuildContainer;

  // To enable compression (deflate, gzip) just add this middleware as the last one 
  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);
end;

procedure TGameDataWebModule.WebModuleDestroy(Sender: TObject);
begin
  FContainer.Free;
  FMVC.Free;
end;

end.