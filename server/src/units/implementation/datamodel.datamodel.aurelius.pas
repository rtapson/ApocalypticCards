unit datamodel.datamodel.aurelius;

interface

uses
  cwCollections,
  datamodel;

type
  TAureliusDataModel = class( TInterfacedObject, IDataModel )
  strict private
    function CreateGame(const GameData: IGameData): Boolean;
    procedure CreateUser(const NewUser: IUserData);
    function FindGameByID(const GameID: string): IGameData;
    function FindGameByPassword(const Password: string): IGameData;
    function getGames: cwCollections.IList<datamodel.IGameData>;
    function getUsersByGameIDOrUserID(const Key: string): cwCollections.IList<datamodel.IUserData>;
    function getUsers(const AuthToken: string): cwCollections.IList<datamodel.IUserData>;
    procedure CleanUp;
    procedure UpdateUserPing(const UserID: string);

  public
    constructor Create; reintroduce;
  end;

implementation

uses
  apcardscontext;

{ TAureliusDataModel }

procedure TAureliusDataModel.CleanUp;
begin

end;

constructor TAureliusDataModel.Create;
begin
  inherited Create;

end;

function TAureliusDataModel.CreateGame(const GameData: IGameData): Boolean;
begin
  Result := False;
end;

procedure TAureliusDataModel.CreateUser(const NewUser: IUserData);
begin

end;

function TAureliusDataModel.FindGameByID(const GameID: string): IGameData;
begin

end;

function TAureliusDataModel.FindGameByPassword(const Password: string): IGameData;
begin

end;

function TAureliusDataModel.getGames: cwCollections.IList<datamodel.IGameData>;
begin

end;

function TAureliusDataModel.getUsers(const AuthToken: string): cwCollections.IList<datamodel.IUserData>;
begin

end;

function TAureliusDataModel.getUsersByGameIDOrUserID(const Key: string): cwCollections.IList<datamodel.IUserData>;
begin

end;

procedure TAureliusDataModel.UpdateUserPing(const UserID: string);
begin

end;

end.
