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
    FFKGameID: string;
  public
    property Name: string read FName write FName;
    property FKGameID: string read FFKGameID write FFKGameID;
  end;

  [MVCPath('/api')]
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
    procedure GetUser(id: string);

    [MVCPath('/users')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateUser;

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateUser(id: string);

    [MVCPath('/users/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteUser(id: string);

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

//Sample CRUD Actions for a "Customer" entity
procedure TUserController.GetUsers;
begin
  Render<Ttbl_users>(FDBSession.objectManager.Find<Ttbl_users>().List);
end;

procedure TUserController.GetUser(id: string);
begin
  Render(FDBSession.objectManager.Find<Ttbl_users>(Format('{%s}', [id])), False);
end;

procedure TUserController.CreateUser;
var
  UserInsertData: TUserInsertData;
  UserData: Ttbl_users;
begin
  UserInsertData := FContext.Request.BodyAs<TUserInsertData>;
  UserData := Ttbl_users.Create;
  UserData.Name := UserInsertData.Name;
  UserData.FKGameID := FDBSession.objectManager.Find<Ttbl_games>(UserInsertData.FKGameID);
  FDBSession.objectManager.SaveOrUpdate(UserData);

//  Render(ObjectDict(False).Add('data', UserData,

  Render(UserData, False, stProperties,
    procedure(const User: TObject; const Links: IMVCLinks)
    begin
      Links
       .AddRefLink
       .Add(HATEOAS.HREF, '/users/' + Ttbl_users(User).PKID)
       .Add(HATEOAS.REL, 'self')
       .Add(HATEOAS._TYPE, 'application/json')
       .Add('title', 'Details for ' + Ttbl_users(User).Name);
      Links
       .AddRefLink
       .Add(HATEOAS.HREF, '/users')
       .Add(HATEOAS.REL, 'users')
       .Add(HATEOAS._TYPE, 'application/json');
    end);
end;

procedure TUserController.UpdateUser(id: string);
var
  UserData: Ttbl_users;
begin
  UserData := FContext.Request.BodyAs<Ttbl_users>;
  UserData.PKID := id;
  FDBSession.objectManager.SaveOrUpdate(UserData);
  Render(UserData, False);
end;

procedure TUserController.DeleteUser(id: string);
var
  UserData: Ttbl_users;
begin
  UserData := FDBSession.objectManager.Find<Ttbl_users>(id);
  FdbSession.objectManager.Remove(UserData);
end;



end.
