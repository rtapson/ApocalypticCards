unit UserController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  Database.Session.Types,
  Spring.Container.Common;

type
  TUserInsertData = class
  private
    FName: string;
    FDeleted: boolean;
    FUserID: string;
    FIsCurrentUser: boolean;
    FGameID: string;
  public
    property Deleted: boolean       read FDeleted       write FDeleted;
    property IsCurrentUser: boolean read FIsCurrentUser write FIsCurrentUser;
    property UserID: string         read FUserID        write FUserID;
    property Name: string           read FName          write FName;
    property GameID: string         read FGameID        write FGameID; //<- Which game am I joined to?
  end;

  [MVCPath('/')]
  TUserController = class(TMVCController) 
  private
    [Inject]
    FDBSession: IDatabaseSession;
  public
    //Sample CRUD Actions for a "Customer" entity
    [MVCPath('/users')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUsers;

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUser(const id: string);

    [MVCPath('/users')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateUser;

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateUser(const id: string);

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteUser(const id: string);

  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  System.StrUtils,
  datamodel.userdata.standard,
  datamodel,
  REST.Json,
  apcardscontext;

//Sample CRUD Actions for a "Customer" entity
procedure TUserController.GetUsers;
begin
  Render<Ttbl_users>(FDBSession.objectManager.Find<Ttbl_users>().List);
end;

procedure TUserController.GetUser(const id: string);
begin
  Render(FDBSession.objectManager.Find<Ttbl_users>(Format('{%s}', [id])), False);
end;

procedure TUserController.CreateUser;
var
  UserData: Ttbl_users;
  NewPlayer: IUserData;
begin
//  NewPlayer := FContext.Request.BodyAs<TUserData>;
  NewPlayer := TJSON.JsonToObject<TUserData>(FContext.Request.Body);

  UserData := Ttbl_users.Create;
  UserData.Name := NewPlayer.Name;
  UserData.FKGameID := FDBSession.objectManager.Find<Ttbl_games>(NewPlayer.GameID);
  if not Assigned(UserData.FKGameID) then
      Exception.Create('Requested game not found.');

  FDBSession.objectManager.SaveOrUpdate(UserData);

//  Render(ObjectDict(False).Add('data', UserData,
  Render(NewPlayer);
//  Render(NewPlayer,
//    False, stProperties,
//    procedure(const User: TObject; const Links: IMVCLinks)
//    begin
//      Links
//       .AddRefLink
//       .Add(HATEOAS.HREF, '/users/' + NewPlayer.UserID)
//       .Add(HATEOAS.REL, 'self')
//       .Add(HATEOAS._TYPE, 'application/json')
//       .Add('title', 'Details for ' + NewPlayer.Name);
//      Links
//       .AddRefLink
//       .Add(HATEOAS.HREF, '/users')
//       .Add(HATEOAS.REL, 'users')
//       .Add(HATEOAS._TYPE, 'application/json');
//    end);
end;

procedure TUserController.UpdateUser(const id: string);
var
  UserData: Ttbl_users;
begin
  UserData := FContext.Request.BodyAs<Ttbl_users>;
  UserData.PKID := id;
  FDBSession.objectManager.SaveOrUpdate(UserData);
  Render(UserData, False);
end;

procedure TUserController.DeleteUser(const id: string);
var
  UserData: Ttbl_users;
begin
  UserData := FDBSession.objectManager.Find<Ttbl_users>(id);
  FdbSession.objectManager.Remove(UserData);
end;



end.
