object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'FrmPrincipal'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BtnExecutarTeste: TBitBtn
    Left = 320
    Top = 16
    Width = 107
    Height = 25
    Caption = 'Executar Teste'
    TabOrder = 0
    OnClick = BtnExecutarTesteClick
  end
  object tbPessoa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 216
    Top = 104
    object tbPessoaNOME: TStringField
      FieldName = 'NOME'
      Size = 150
    end
    object tbPessoaDATA_NASCIMENTO: TDateField
      FieldName = 'DATA_NASCIMENTO'
    end
  end
end
