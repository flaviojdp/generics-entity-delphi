unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  U.GenericsPrincipal, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrmPrincipal = class(TForm)
    BtnExecutarTeste: TBitBtn;
    tbPessoa: TFDMemTable;
    tbPessoaNOME: TStringField;
    tbPessoaDATA_NASCIMENTO: TDateField;
    BtnExecutarTesteRecord: TBitBtn;
    tbProduto: TFDMemTable;
    tbProdutoTipo: TStringField;
    tbProdutoCodigo: TIntegerField;
    tbProdutoNome: TStringField;
    procedure BtnExecutarTesteClick(Sender: TObject);
    procedure BtnExecutarTesteRecordClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDataSetPessoa;
    procedure MockDataSetProduto;
    procedure InserPessoa(const csNome: String; const ctDataNascimento: TDate);
    procedure InserirProduto(const csTipo: String; const ciCodigo: Integer; const csNome: String);
    procedure TestarRecord;

  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.BtnExecutarTesteClick(Sender: TObject);
var
  _ListaPessoa: TGenericsPrincipalListaEntityPessoa;
  _Pessoa: TGenericsPrincipalEntityPessoa;
begin
  _ListaPessoa := TGenericsPrincipalListaEntityPessoa.Create();
  ShowMessage(_ListaPessoa.Count.ToString);

  // _ListaPessoa.LoadAll(['A','B','C']);
  LoadDataSetPessoa;

  _ListaPessoa.LoadAll(tbPessoa);

  ShowMessage(_ListaPessoa.Count.ToString);

  for _Pessoa in _ListaPessoa.Values do
    ShowMessage(Format('Nome: %s Data Nascimento: %s', [_Pessoa.Nome, DateToStr(_Pessoa.DataNascimento)]));
end;

procedure TFrmPrincipal.BtnExecutarTesteRecordClick(Sender: TObject);
begin
  TestarRecord;
end;

procedure TFrmPrincipal.InserirProduto(const csTipo: String; const ciCodigo: Integer; const csNome: String);
begin
  if not tbProduto.Active then
    tbProduto.Open;
  tbProduto.Insert;
  tbProduto.FieldByName('Tipo').AsString := csTipo;
  tbProduto.FieldByName('Codigo').AsInteger := ciCodigo;
  tbProduto.FieldByName('NOME').AsString := csNome;
  tbProduto.Post;
end;

procedure TFrmPrincipal.InserPessoa(const csNome: String; const ctDataNascimento: TDate);
begin
  if not tbPessoa.Active then
    tbPessoa.Open;
  tbPessoa.Insert;
  tbPessoa.FieldByName('NOME').AsString := csNome;
  tbPessoa.FieldByName('DATA_NASCIMENTO').AsDateTime := ctDataNascimento;
  tbPessoa.Post;
end;

procedure TFrmPrincipal.LoadDataSetPessoa;
begin
  if not tbPessoa.Active then
    tbPessoa.Open;
  tbPessoa.EmptyDataSet;

  Self.InserPessoa('João', StrToDate('15/05/2000'));
  Self.InserPessoa('Maria', StrToDate('23/07/2010'));
  Self.InserPessoa('José', StrToDate('30/06/2012'));
  Self.InserPessoa('Antônio', StrToDate('27/08/2013'));
end;

procedure TFrmPrincipal.MockDataSetProduto;
begin
  if not tbProduto.Active then
    tbProduto.Open;
  tbProduto.EmptyDataSet;

  InserirProduto('Perecivel', 1, 'Arroz');
  InserirProduto('Perecivel', 2, 'Feijão');
end;

procedure TFrmPrincipal.TestarRecord;
var
  _Produto: TEntityProduto;
  _ListaProduto: TListaEntityProduto;
  _ChaveProduto: TChaveProduto;
begin
  MockDataSetProduto;
  _ListaProduto := TListaEntityProduto.Create(nil);
  try
    _ListaProduto.LoadAll(tbProduto);
    for _Produto in _ListaProduto.Values do
      ShowMessage(_Produto.Nome);

    _ChaveProduto.Tipo := 'Perecivel';
    _ChaveProduto.Codigo := 2;

    if _ListaProduto.ContainsKey(_ChaveProduto) then
      ShowMessage('Achou!!')
    else
      ShowMessage('Não achou!');

    if _Produto.GetChave = _ChaveProduto then
      ShowMessage('Igual');
  finally
    FreeAndNil(_ListaProduto);
  end;
end;

end.
