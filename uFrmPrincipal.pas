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
    procedure BtnExecutarTesteClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDataSetPessoa;
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
    ShowMessage(_Pessoa.Nome);
end;

procedure TFrmPrincipal.LoadDataSetPessoa;
begin
  if not tbPessoa.Active then
    tbPessoa.Open;
  tbPessoa.Insert;
  tbPessoa.FieldByName('NOME').AsString := 'João';
  tbPessoa.Post;

  tbPessoa.Insert;
  tbPessoa.FieldByName('NOME').AsString := 'Maria';
  tbPessoa.Post;

  tbPessoa.Insert;
  tbPessoa.FieldByName('NOME').AsString := 'José';
  tbPessoa.Post;

  tbPessoa.Insert;
  tbPessoa.FieldByName('NOME').AsString := 'Antonio';
  tbPessoa.Post;
end;

end.
