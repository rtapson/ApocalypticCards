unit UserController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  Database.Session.Types,
  Spring.Container.Common;

type
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
  //todo: render the customer by id
end;

procedure TUserController.CreateUser;

begin
  //todo: create a new customer
end;

procedure TUserController.UpdateUser(id: string);
begin
  //todo: update customer by id
end;

procedure TUserController.DeleteUser(id: string);
begin
  //todo: delete customer by id
end;



end.
