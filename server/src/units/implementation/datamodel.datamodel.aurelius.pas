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
  public
    constructor Create; reintroduce;

  end;

implementation

uses
  apcardscontext;

{ TAureliusDataModel }

constructor TAureliusDataModel.Create;
begin
  inherited Create;

end;

function TAureliusDataModel.CreateGame(const GameData: IGameData): Boolean;
begin

end;

procedure TAureliusDataModel.CreateUser(const NewUser: IUserData);
begin

end;

function TAureliusDataModel.FindGameByID(const GameID: string): IGameData;
begin

end;

function TAureliusDataModel.FindGameByPassword(
  const Password: string): IGameData;
begin

end;

function TAureliusDataModel.getGames: cwCollections.IList<datamodel.IGameData>;
begin

end;

function TAureliusDataModel.getUsersByGameIDOrUserID(
  const Key: string): cwCollections.IList<datamodel.IUserData>;
begin

end;

end.
