unit U.GenericsPrincipal;

interface

uses
  Vcl.Dialogs,
  Data.DB,
  System.Generics.Collections;

type

  TGenericsPrincipalEntityBase<TChave> = class
  strict protected
    procedure HydrateObject(const ctDataSet: TDataSet);
  public
    function GetChave: TChave; virtual; abstract;
    procedure LoadFromDataSet(const ctDataSet: TDataSet); virtual;

  end;

  TGenericsPrincipalListaEntityBase<TChave; TEntity: TGenericsPrincipalEntityBase<TChave>, constructor> = class(TDictionary<TChave, TEntity>)
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
    // procedure LoadFromDataSet(const ctDataSet: TDataSet); override;
    property Nome: String read FNome write FNome;
  end;

  TGenericsPrincipalListaEntityPessoa = class(TGenericsPrincipalListaEntityBase<string, TGenericsPrincipalEntityPessoa>)
  end;

implementation

uses
  System.Rtti,
  System.SysUtils;

{ TGenericsPrincipalEntityPessoa }

function TGenericsPrincipalEntityPessoa.GetChave: string;
begin
  Result := FNome;
  if Result.Trim.IsEmpty then
    Result := Random(100).ToString

end;

// procedure TGenericsPrincipalEntityPessoa.LoadFromDataSet(const ctDataSet: TDataSet);
// begin
// inherited;
/// /  FNome := ctDataSet.FieldByName('NOME').AsString;
// end;

{ TGenericsPrincipalListaEntityBase<TChave, TEntity> }

procedure TGenericsPrincipalListaEntityBase<TChave, TEntity>.LoadAll(const ctDataSet: TDataSet);
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

procedure TGenericsPrincipalListaEntityBase<TChave, TEntity>.LoadAll(const caNome: array of string);
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

{ TGenericsPrincipalEntityBase<TChave> }

procedure TGenericsPrincipalEntityBase<TChave>.HydrateObject(const ctDataSet: TDataSet);
var
  _Contexto: TRttiContext;
  _Tipo: TRttiType;
  _Propriedade: TRttiProperty;
begin
  _Contexto := TRttiContext.Create;
  _Tipo := _Contexto.GetType(Self.ClassType);
  for _Propriedade in _Tipo.GetProperties do
  begin
    if not _Propriedade.IsWritable then
      continue;
    if ctDataSet.FindField(_Propriedade.Name) = nil then
      continue;
    _Propriedade.SetValue(Self, TValue.FromVariant(ctDataSet.FieldByName(_Propriedade.Name).Value));
  end;
end;

procedure TGenericsPrincipalEntityBase<TChave>.LoadFromDataSet(const ctDataSet: TDataSet);
begin
  Self.HydrateObject(ctDataSet);
end;

end.
