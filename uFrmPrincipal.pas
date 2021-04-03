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
    BitBtn1: TBitBtn;
    tbPessoa: TFDMemTable;
    tbPessoaNOME: TStringField;
    tbPessoaDATA_NASCIMENTO: TDateField;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDataSetPessoa;
    procedure InserPessoa(const csNome: String; const ctDataNascimento: TDate);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.BitBtn1Click(Sender: TObject);
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
    ShowMessage(Format('Nome: %s Data Nascimento: %s',[_Pessoa.Nome, DateToStr(_Pessoa.DataNascimento)]));
end;

procedure TFrmPrincipal.InserPessoa(const csNome: String;
  const ctDataNascimento: TDate);
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

end.
