unit GameDataController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  Database.Session.Types,
  Spring.Container.Common,
  apcardscontext;

type

  [MVCPath('/')]
  TGameDataController = class(TMVCController)
  private
    [Inject]
    FDBSession: IDAtabaseSession;
    procedure ValidateUserCount(const GameData: Ttbl_games);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    //Sample CRUD Actions for a "games" entity
    [MVCPath('/games')]
    [MVCHTTPMethod([httpGET])]
    procedure GetGames;

    [MVCPath('/games/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetGame(const id: string);

    [MVCPath('/games')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateGameData;

    [MVCPath('/games/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateGameData(const id: string);

    [MVCPath('/games/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteGameData(const id: string);

  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  System.StrUtils,
  ControllerConsts,
  datamodel.gamedata.standard,
  datamodel
  ,Spring.Collections
  ;

procedure TGameDataController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TGameDataController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

procedure TGameDataController.GetGames;
var
  GamesData: IList<IGameData>;
  GameData: IGameData;
  Games: TObjectList<Ttbl_games>;
  Game: Ttbl_games;
begin
  Games := FDBSession.objectManager.Find<Ttbl_games>().List;
  GamesData := TCollections.CreateInterfaceList<IGameData>;
  for Game in Games do
  begin
    GameData := TGameData.Create;
    GameData.LangID := Game.LangID;
    GameData.MaxUser := Game.MaxUser;
    GameData.MinUser := Game.MinUser;
    GameData.Running := Game.Running;
    GameData.SessionID := Game.PKID;
    GameData.SessionName := Game.SessionName;
    GameData.SessionPassword := Game.sessionPassword;
    GameData.UserCount := 0; // Game.UserCount
    GamesData.Add(GameData);
  end;

  Render(ToMVCList(GamesData.AsObject));
//  Render(ObjectDict(False).Add('', GamesData.AsObject));
end;

procedure TGameDataController.GetGame(const id: string);
begin
  Render(FDBSession.objectManager.Find<Ttbl_games>(id), False);
end;

procedure TGameDataController.CreateGameData;
var
  GameData: Ttbl_games;
  i: Integer;
begin
  GameData := FContext.Request.BodyAs<Ttbl_games>;

  if GameData.sessionPassword = cGeneratePasswordFlag then
  begin
    GameData.sessionPassword := cNullString;
    for i := 0 to pred(cPasswordLen) do
      GameData.SessionPassword := GameData.SessionPassword + chr( cStartPasswordChar+Random(cPasswordCharRange) );
  end;

  GameData.Running := False;

  ValidateUserCount(GameData);

  FDBSession.objectManager.SaveOrUpdate(GameData);
  Render(GameData, False);
end;

procedure TGameDataController.UpdateGameData(const id: string);
var
  GameData: Ttbl_games;
begin
  GameData := FContext.Request.BodyAs<Ttbl_games>;
  GameData.PKID := id;
  FDBSession.objectManager.SaveOrUpdate(GameData);
  Render(GameData, False);
end;

procedure TGameDataController.ValidateUserCount(const GameData: Ttbl_games);
begin
  if GameData.MaxUser<GameData.MinUser then begin
    GameData.MinUser := GameData.MaxUser;
  end;
  if GameData.MinUser>GameData.MaxUser then begin
    GameData.MaxUser := GameData.MinUser;
  end;
  if GameData.MinUser<cMinUserCount then begin
    raise
      Exception.Create('Minimum users required is '+IntToStr(cMinUserCount)+' or greater.');
  end;
  if GameData.MaxUser>cMaxUserCount then begin
    raise
      Exception.Create('The maximum number of users permitted in a game is '+IntToStr(cMaxUserCount)+'.');
  end;
end;

procedure TGameDataController.DeleteGameData(const id: string);
var
  GameData: Ttbl_games;
begin
  GameData := FDBSession.objectManager.Find<Ttbl_games>(id);
  FdbSession.objectManager.Remove(GameData);
end;



end.
