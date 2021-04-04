unit U.GenericsPrincipal;

interface

uses
  Vcl.Dialogs,
  Data.DB,
  System.Character,
  System.Generics.Collections, System.Generics.Defaults;

type

  TChaveProduto = record
    Tipo: string;
    Codigo: Integer;
    class operator Equal(A: TChaveProduto; B: TChaveProduto): Boolean;
  end;

  TGenericsPrincipalEntityBase<TChave> = class
  strict protected
    procedure HydrateObject(const ctDataSet: TDataSet);
    function TemMaiusCula(const csTexto: String): Boolean;
    function TrataCamelCase(const csTexto: String): String;
    function TrataNomePropriedade(const csTexto: String): String;
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
    FDataNascimento: TDate;
  public
    function GetChave: string; override;
    // procedure LoadFromDataSet(const ctDataSet: TDataSet); override;
    property Nome: String read FNome write FNome;
    property DataNascimento: TDate read FDataNascimento write FDataNascimento;
  end;

  TGenericsPrincipalListaEntityPessoa = class(TGenericsPrincipalListaEntityBase<string, TGenericsPrincipalEntityPessoa>)
  end;

  TEntityProduto = class(TGenericsPrincipalEntityBase<TChaveProduto>)
  strict private
    FTipo: String;
    FCodigo: Integer;
    FNome: String;
  private
  public
    function GetChave: TChaveProduto; override;
    property Tipo: String read FTipo write FTipo;
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: String read FNome write FNome;
  end;

  TListaEntityProduto = class(TGenericsPrincipalListaEntityBase<TChaveProduto, TEntityProduto>)
  public
    constructor Create(const AComparer: IEqualityComparer<TChaveProduto> = nil);
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
  _NomeField: string;
begin
  _Contexto := TRttiContext.Create;
  _Tipo := _Contexto.GetType(Self.ClassType);
  for _Propriedade in _Tipo.GetProperties do
  begin
    if not _Propriedade.IsWritable then
      continue;
    _NomeField := TrataNomePropriedade(_Propriedade.Name);
    if ctDataSet.FindField(_NomeField) = nil then
      continue;
    _Propriedade.SetValue(Self, TValue.FromVariant(ctDataSet.FieldByName(_NomeField).Value));
  end;
end;

procedure TGenericsPrincipalEntityBase<TChave>.LoadFromDataSet(const ctDataSet: TDataSet);
begin
  Self.HydrateObject(ctDataSet);
end;

function TGenericsPrincipalEntityBase<TChave>.TemMaiusCula(const csTexto: String): Boolean;
var
  _Char: Char;
  _Idx: Integer;
begin
  _Idx := -1;
  Result := False;
  for _Char in csTexto do
  begin
    Inc(_Idx);
    if _Idx = 0 then
      continue;

    if _Char.IsUpper then
      Exit(True)
  end;
end;

function TGenericsPrincipalEntityBase<TChave>.TrataCamelCase(const csTexto: String): String;
var
  _Char: Char;
  _Idx: Integer;
begin
  _Idx := -1;
  Result := '';
  if csTexto.Trim.Length > 0 then
    Result := csTexto[1];
  for _Char in csTexto do
  begin
    Inc(_Idx);
    if _Idx = 0 then
      continue;

    if _Char.IsUpper then
    begin
      Result := Result + '_';
      // ShowMessage('Maiuscula!' + _Char);
    end;
    Result := Result + _Char;
  end;
end;

function TGenericsPrincipalEntityBase<TChave>.TrataNomePropriedade(const csTexto: String): String;
begin
  Result := csTexto.Trim.ToUpper;
  if Self.TemMaiusCula(csTexto) then
    Result := TrataCamelCase(csTexto).Trim.ToUpper;
end;

{ TGenericsPrincipalEntityProduto }

function TEntityProduto.GetChave: TChaveProduto;
begin
  Result.Tipo := Tipo;
  Result.Codigo := Codigo;
end;

{ TChaveProduto }

{ TChaveProduto }

class operator TChaveProduto.Equal(A, B: TChaveProduto): Boolean;
begin
  Result := A.Codigo = B.Codigo
end;

{ TListaEntityProduto }

constructor TListaEntityProduto.Create( const AComparer: IEqualityComparer<TChaveProduto>);
var
  _Comparer: IEqualityComparer<TChaveProduto>;
begin
  _Comparer := AComparer;
  if(_Comparer = nil)then
  begin
    _Comparer := TDelegatedEqualityComparer<TChaveProduto>.Create(
      function(const Left, Right: TChaveProduto): Boolean
      begin
        Result := Left = Right;
      end,
      function(const Value: TChaveProduto): Integer
      begin
        Result := Value.Codigo
      end
    );
  end;

  inherited Create(_Comparer);

end;

end.
