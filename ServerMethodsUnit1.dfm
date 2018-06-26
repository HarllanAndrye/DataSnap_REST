object api: Tapi
  OldCreateOrder = False
  Height = 140
  Width = 250
  object MySQLConnection: TSQLConnection
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'Password='
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'HostName=192.168.15.13'
      'Database=storeonline'
      'User_Name=root'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile=')
    Connected = True
    Left = 48
    Top = 16
  end
  object dsUser: TSQLDataSet
    Active = True
    CommandText = 'SELECT * FROM users'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = MySQLConnection
    Left = 48
    Top = 64
    object dsUserID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object dsUserNAME: TStringField
      FieldName = 'NAME'
      Required = True
      Size = 100
    end
    object dsUserPASS: TStringField
      FieldName = 'PASS'
      Required = True
      Size = 100
    end
    object dsUserEMAIL: TStringField
      FieldName = 'EMAIL'
      Required = True
      Size = 100
    end
    object dsUserCPF_CNPJ: TStringField
      FieldName = 'CPF_CNPJ'
      Required = True
      Size = 100
    end
    object dsUserRG_IE: TStringField
      FieldName = 'RG_IE'
      Size = 50
    end
    object dsUserPHONE1: TStringField
      FieldName = 'PHONE1'
      Size = 100
    end
    object dsUserPHONE2: TStringField
      FieldName = 'PHONE2'
      Size = 100
    end
    object dsUserADDRESS: TStringField
      FieldName = 'ADDRESS'
      Size = 250
    end
    object dsUserNUMBER: TIntegerField
      FieldName = 'NUMBER'
    end
    object dsUserNEIGHBORHOOD: TStringField
      FieldName = 'NEIGHBORHOOD'
      Size = 250
    end
    object dsUserCITY: TStringField
      FieldName = 'CITY'
      Size = 250
    end
    object dsUserSTATE: TStringField
      FieldName = 'STATE'
      Size = 150
    end
    object dsUserCOUNTRY: TStringField
      FieldName = 'COUNTRY'
      Size = 150
    end
    object dsUserCEP: TStringField
      FieldName = 'CEP'
      Size = 100
    end
  end
  object SQLQuery: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = MySQLConnection
    Left = 160
    Top = 16
  end
  object IdHTTPPesquisaCep: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 160
    Top = 64
  end
end
