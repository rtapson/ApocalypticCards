unit apcardscontext;

interface

uses
  SysUtils, 
  Generics.Collections, 
  Aurelius.Mapping.Attributes, 
  Aurelius.Types.Blob, 
  Aurelius.Types.DynamicProperties, 
  Aurelius.Types.Nullable, 
  Aurelius.Types.Proxy, 
  Aurelius.Criteria.Dictionary;

type
  Ttbl_games = class;
  Ttbl_questions = class;
  Ttbl_users = class;
  Ttbl_gamesTableDictionary = class;
  Ttbl_questionsTableDictionary = class;
  Ttbl_usersTableDictionary = class;
  
  [Entity]
  [Table('tbl_games')]
  [Id('FPKID', TIdGenerator.Uuid38)]
  Ttbl_games = class
  private
    [Column('PKID', [TColumnProp.Required], 40)]
    FPKID: string;
    
    [Column('Running', [TColumnProp.Required])]
    FRunning: Boolean;
    
    [Column('SessionName', [TColumnProp.Required], 45)]
    FSessionName: string;
    
    [Column('SessionPW', [TColumnProp.Required], 45)]
    FSessionPW: string;
    
    [Column('LangID', [TColumnProp.Required], 2)]
    FLangID: string;
    
    [Column('MinUser', [TColumnProp.Required])]
    FMinUser: Integer;
    
    [Column('MaxUser', [TColumnProp.Required])]
    FMaxUser: Integer;
    
    [Column('CurrentUser', [], 40)]
    FCurrentUser: string;
    
    [Column('LastUpdate', [TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FLastUpdate: TDateTime;
  public
    property PKID: string read FPKID write FPKID;
    property Running: Boolean read FRunning write FRunning;
    property SessionName: string read FSessionName write FSessionName;
    property SessionPW: string read FSessionPW write FSessionPW;
    property LangID: string read FLangID write FLangID;
    property MinUser: Integer read FMinUser write FMinUser;
    property MaxUser: Integer read FMaxUser write FMaxUser;
    property CurrentUser: string read FCurrentUser write FCurrentUser;
    property LastUpdate: TDateTime read FLastUpdate write FLastUpdate;
  end;
  
  [Entity]
  [Table('tbl_questions')]
  [Id('Fstr_pkid', TIdGenerator.Uuid38)]
  Ttbl_questions = class
  private
    [Column('str_pkid', [TColumnProp.Required], 40)]
    Fstr_pkid: string;
    
    [Column('str_question', [TColumnProp.Required, TColumnProp.Lazy])]
    [DBTypeMemo]
    Fstr_question: TBlob;
  public
    property str_pkid: string read Fstr_pkid write Fstr_pkid;
    property str_question: TBlob read Fstr_question write Fstr_question;
  end;
  
  [Entity]
  [Table('tbl_users')]
  [Id('FPKID', TIdGenerator.Uuid38)]
  Ttbl_users = class
  private
    [Column('PKID', [TColumnProp.Required], 40)]
    FPKID: string;
    
    [Column('Name', [], 255)]
    FName: string;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('FKGameID', [TColumnProp.Required], 'PKID')]
    FFKGameID: Proxy<Ttbl_games>;
    function GetFKGameID: Ttbl_games;
    procedure SetFKGameID(const Value: Ttbl_games);
  public
    property PKID: string read FPKID write FPKID;
    property Name: string read FName write FName;
    property FKGameID: Ttbl_games read GetFKGameID write SetFKGameID;
  end;
  
  TDicDictionary = class
  private
    Ftbl_games: Ttbl_gamesTableDictionary;
    Ftbl_questions: Ttbl_questionsTableDictionary;
    Ftbl_users: Ttbl_usersTableDictionary;
    function Gettbl_games: Ttbl_gamesTableDictionary;
    function Gettbl_questions: Ttbl_questionsTableDictionary;
    function Gettbl_users: Ttbl_usersTableDictionary;
  public
    destructor Destroy; override;
    property tbl_games: Ttbl_gamesTableDictionary read Gettbl_games;
    property tbl_questions: Ttbl_questionsTableDictionary read Gettbl_questions;
    property tbl_users: Ttbl_usersTableDictionary read Gettbl_users;
  end;
  
  Ttbl_gamesTableDictionary = class
  private
    FPKID: TDictionaryAttribute;
    FRunning: TDictionaryAttribute;
    FSessionName: TDictionaryAttribute;
    FSessionPW: TDictionaryAttribute;
    FLangID: TDictionaryAttribute;
    FMinUser: TDictionaryAttribute;
    FMaxUser: TDictionaryAttribute;
    FCurrentUser: TDictionaryAttribute;
    FLastUpdate: TDictionaryAttribute;
  public
    constructor Create;
    property PKID: TDictionaryAttribute read FPKID;
    property Running: TDictionaryAttribute read FRunning;
    property SessionName: TDictionaryAttribute read FSessionName;
    property SessionPW: TDictionaryAttribute read FSessionPW;
    property LangID: TDictionaryAttribute read FLangID;
    property MinUser: TDictionaryAttribute read FMinUser;
    property MaxUser: TDictionaryAttribute read FMaxUser;
    property CurrentUser: TDictionaryAttribute read FCurrentUser;
    property LastUpdate: TDictionaryAttribute read FLastUpdate;
  end;
  
  Ttbl_questionsTableDictionary = class
  private
    Fstr_pkid: TDictionaryAttribute;
    Fstr_question: TDictionaryAttribute;
  public
    constructor Create;
    property str_pkid: TDictionaryAttribute read Fstr_pkid;
    property str_question: TDictionaryAttribute read Fstr_question;
  end;
  
  Ttbl_usersTableDictionary = class
  private
    FPKID: TDictionaryAttribute;
    FName: TDictionaryAttribute;
    FFKGameID: TDictionaryAssociation;
  public
    constructor Create;
    property PKID: TDictionaryAttribute read FPKID;
    property Name: TDictionaryAttribute read FName;
    property FKGameID: TDictionaryAssociation read FFKGameID;
  end;
  
function Dic: TDicDictionary;

implementation

var
  __Dic: TDicDictionary;

function Dic: TDicDictionary;
begin
  if __Dic = nil then __Dic := TDicDictionary.Create;
  result := __Dic
end;

{ Ttbl_users }

function Ttbl_users.GetFKGameID: Ttbl_games;
begin
  result := FFKGameID.Value;
end;

procedure Ttbl_users.SetFKGameID(const Value: Ttbl_games);
begin
  FFKGameID.Value := Value;
end;

{ TDicDictionary }

destructor TDicDictionary.Destroy;
begin
  if Ftbl_users <> nil then Ftbl_users.Free;
  if Ftbl_questions <> nil then Ftbl_questions.Free;
  if Ftbl_games <> nil then Ftbl_games.Free;
  inherited;
end;

function TDicDictionary.Gettbl_games: Ttbl_gamesTableDictionary;
begin
  if Ftbl_games = nil then Ftbl_games := Ttbl_gamesTableDictionary.Create;
  result := Ftbl_games;
end;

function TDicDictionary.Gettbl_questions: Ttbl_questionsTableDictionary;
begin
  if Ftbl_questions = nil then Ftbl_questions := Ttbl_questionsTableDictionary.Create;
  result := Ftbl_questions;
end;

function TDicDictionary.Gettbl_users: Ttbl_usersTableDictionary;
begin
  if Ftbl_users = nil then Ftbl_users := Ttbl_usersTableDictionary.Create;
  result := Ftbl_users;
end;

{ Ttbl_gamesTableDictionary }

constructor Ttbl_gamesTableDictionary.Create;
begin
  inherited;
  FPKID := TDictionaryAttribute.Create('PKID');
  FRunning := TDictionaryAttribute.Create('Running');
  FSessionName := TDictionaryAttribute.Create('SessionName');
  FSessionPW := TDictionaryAttribute.Create('SessionPW');
  FLangID := TDictionaryAttribute.Create('LangID');
  FMinUser := TDictionaryAttribute.Create('MinUser');
  FMaxUser := TDictionaryAttribute.Create('MaxUser');
  FCurrentUser := TDictionaryAttribute.Create('CurrentUser');
  FLastUpdate := TDictionaryAttribute.Create('LastUpdate');
end;

{ Ttbl_questionsTableDictionary }

constructor Ttbl_questionsTableDictionary.Create;
begin
  inherited;
  Fstr_pkid := TDictionaryAttribute.Create('str_pkid');
  Fstr_question := TDictionaryAttribute.Create('str_question');
end;

{ Ttbl_usersTableDictionary }

constructor Ttbl_usersTableDictionary.Create;
begin
  inherited;
  FPKID := TDictionaryAttribute.Create('PKID');
  FName := TDictionaryAttribute.Create('Name');
  FFKGameID := TDictionaryAssociation.Create('FKGameID');
end;

initialization
  RegisterEntity(Ttbl_games);
  RegisterEntity(Ttbl_questions);
  RegisterEntity(Ttbl_users);

finalization
  if __Dic <> nil then __Dic.Free

end.
