unit GameDataController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  Database.Session.Types,
  Spring.Container.Common;

type

  [MVCPath('/')]
  TGameDataController = class(TMVCController)
  private
    [Inject]
    FDBSession: IDAtabaseSession;
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
    procedure GetGame(id: string);

    [MVCPath('/games')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateGameData;

    [MVCPath('/games/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateGameData(id: string);

    [MVCPath('/games/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteGameData(id: string);

  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  System.StrUtils,
  apcardscontext,
  datamodel.gamedata.standard,
  datamodel;

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
begin
//  Render(ObjectDict(False).Add('data', FDBSession.objectManager.Find<Ttbl_games>().List));
  Render<Ttbl_games>(FDBSession.objectManager.Find<Ttbl_games>().List, False);
end;

procedure TGameDataController.GetGame(id: string);
begin
  Render(FDBSession.objectManager.Find<Ttbl_games>(id), False);
end;

procedure TGameDataController.CreateGameData;
var
  GameData: Ttbl_games;
begin
  GameData := FContext.Request.BodyAs<Ttbl_games>;
  FDBSession.objectManager.Save(GameData);
  Render(GameData, False);
end;

procedure TGameDataController.UpdateGameData(id: string);
var
  GameData: Ttbl_games;
begin
  GameData := FContext.Request.BodyAs<Ttbl_games>;
  GameData.PKID := id;
  FDBSession.objectManager.SaveOrUpdate(GameData);
  Render(GameData, False);
end;

procedure TGameDataController.DeleteGameData(id: string);
var
  GameData: Ttbl_games;
begin
  GameData := FDBSession.objectManager.Find<Ttbl_games>(id);
  FdbSession.objectManager.Remove(GameData);
end;



end.
