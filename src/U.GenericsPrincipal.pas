unit U.GenericsPrincipal;

interface

uses
  Data.DB,
  System.Generics.Collections;

type

  TGenericsPrincipalEntityBase<TChave> = class
  public
    function GetChave: TChave; virtual; abstract;
    procedure LoadFromDataSet(const ctDataSet: TDataSet); virtual; abstract;
  end;

  TGenericsPrincipalListaEntityBase<TChave;
  TEntity: TGenericsPrincipalEntityBase<TChave>, constructor> = class
    (TDictionary<TChave, TEntity>)
  public
    procedure LoadAll(const ctDataSet: TDataSet); overload; virtual;
    procedure LoadAll(const caNome: array of string); overload; virtual;
  end;

  TGenericsPrincipalEntityPessoa = class(TGenericsPrincipalEntityBase<string>)
  strict private
  private
    FNome: String;
  public
    function GetChave: string; override;
    procedure LoadFromDataSet(const ctDataSet: TDataSet); override;
    property Nome: String read FNome write FNome;
  end;

  TGenericsPrincipalListaEntityPessoa = class
    (TGenericsPrincipalListaEntityBase<string, TGenericsPrincipalEntityPessoa>)
  end;

implementation

uses
  System.SysUtils;

{ TGenericsPrincipalEntityPessoa }

function TGenericsPrincipalEntityPessoa.GetChave: string;
begin
  Result := Nome;
  if Result.Trim.IsEmpty then
    Result := Random(100).ToString

end;

procedure TGenericsPrincipalEntityPessoa.LoadFromDataSet(const ctDataSet
  : TDataSet);
begin
  inherited;
  FNome := ctDataSet.FieldByName('NOME').AsString;
end;

{ TGenericsPrincipalListaEntityBase<TChave, TEntity> }

procedure TGenericsPrincipalListaEntityBase<TChave, TEntity>.LoadAll
  (const ctDataSet: TDataSet);
var
  _Entity: TEntity;
  _Chave: TChave;
begin
  while not ctDataSet.Eof do
  begin
    _Entity := TEntity.Create;
    _Entity.LoadFromDataSet(ctDataSet);
    _Chave := _Entity.GetChave;
    Add(_Chave, _Entity);
    ctDataSet.Next;
  end;
end;

procedure TGenericsPrincipalListaEntityBase<TChave, TEntity>.LoadAll
  (const caNome: array of string);
var
  _Entity: TEntity;
  _Chave: TChave;
  _Nome: string;
begin
  for _Nome in caNome do
  begin
    _Entity := TEntity.Create;
    repeat
      _Chave := _Entity.GetChave;
    until not Self.ContainsKey(_Chave);
    Add(_Chave, _Entity);
  end;
end;

end.
