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
    tbNota: TFDMemTable;
    tbNotaNUMERO: TIntegerField;
    tbNotaSERIE: TStringField;
    tbNotaCNPJ: TStringField;
    BtnTestarNota: TBitBtn;
    procedure BtnExecutarTesteClick(Sender: TObject);
    procedure BtnExecutarTesteRecordClick(Sender: TObject);
    procedure BtnTestarNotaClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDataSetPessoa;
    procedure InserirProduto(const csTipo: String; const ciCodigo: Integer; const csNome: String);
    procedure InserirNota(const csSerie: String; const ciNumero: Integer; const csCnpj: String);
    procedure InserirPessoa(const csNome: String; const ctDataNascimento: TDate);
    procedure MockDataSetNota;
    procedure MockDataSetProduto;
    procedure TestarRecord;
    procedure TestarNota;

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

procedure TFrmPrincipal.BtnTestarNotaClick(Sender: TObject);
begin
  TestarNota;
end;

procedure TFrmPrincipal.InserirNota(const csSerie: String;
  const ciNumero: Integer; const csCnpj: String);
begin
  if not tbNota.Active then
    tbNota.Open;
  tbNota.Insert;
  tbNota.FieldByName('SERIE').AsString := csSerie;
  tbNota.FieldByName('NUMERO').AsInteger := ciNumero;
  tbNota.FieldByName('CNPJ').AsString := csCnpj;
  tbNota.Post;
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

procedure TFrmPrincipal.InserirPessoa(const csNome: String; const ctDataNascimento: TDate);
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

  Self.InserirPessoa('João', StrToDate('15/05/2000'));
  Self.InserirPessoa('Maria', StrToDate('23/07/2010'));
  Self.InserirPessoa('José', StrToDate('30/06/2012'));
  Self.InserirPessoa('Antônio', StrToDate('27/08/2013'));
end;

procedure TFrmPrincipal.MockDataSetNota;
begin
  InserirNota('A',1,'1');
  InserirNota('B',2,'2');
  InserirNota('C',3,'3');
end;

procedure TFrmPrincipal.MockDataSetProduto;
begin
  if not tbProduto.Active then
    tbProduto.Open;
  tbProduto.EmptyDataSet;

  InserirProduto('Perecivel', 1, 'Arroz');
  InserirProduto('Perecivel', 2, 'Feijão');
end;

procedure TFrmPrincipal.TestarNota;
var
  _ChaveNota: TChaveNota;
  _ListaNota: TListaNota;
begin
  MockDataSetNota;
  _ListaNota := TListaNota.Create;
  _ListaNota.LoadAll(tbNota);
  _ChaveNota := TChaveNota.Create;
  _ChaveNota.Serie := 'B';
  _ChaveNota.Numero := 2;
  if _ListaNota.ContainsKey(_ChaveNota) then
    ShowMessage('Achei Nota')
  else
    ShowMessage('Não encontrei a nota!!!');
end;

procedure TFrmPrincipal.TestarRecord;
var
  _Produto: TEntityProduto;
  _ListaProduto: TListaEntityProduto;
  _ChaveProduto: TChaveProduto;
begin
  _Produto := nil;
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
