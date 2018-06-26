unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, Data.DBXMySQL, Data.DB, Data.SqlExpr,
  Data.FMTBcd, web.httpApp, Datasnap.DBClient, SimpleDS, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
{$METHODINFO ON}
  Tapi = class(TDataModule)
    MySQLConnection: TSQLConnection;
    dsUser: TSQLDataSet;
    dsUserID: TIntegerField;
    dsUserNAME: TStringField;
    dsUserPASS: TStringField;
    dsUserEMAIL: TStringField;
    dsUserCPF_CNPJ: TStringField;
    dsUserRG_IE: TStringField;
    dsUserPHONE1: TStringField;
    dsUserPHONE2: TStringField;
    dsUserADDRESS: TStringField;
    dsUserNUMBER: TIntegerField;
    dsUserNEIGHBORHOOD: TStringField;
    dsUserCITY: TStringField;
    dsUserSTATE: TStringField;
    dsUserCOUNTRY: TStringField;
    dsUserCEP: TStringField;
    SQLQuery: TSQLQuery;
    IdHTTPPesquisaCep: TIdHTTP;
  private
    { Private declarations }
  public
    { Public declarations }
    // GET
    function User(id: Integer) : TJSONObject;
    function Getaddress(zipcode: string): TJSONObject;
    // POST
    function updateLogin() : TJSONObject;
    function updateLogout() : TJSONObject;
    // DELETE
    function cancelRemove_wishlist() : TJSONObject;
  end;
{$METHODINFO OFF}

threadvar
  vRequest: TWebRequest;

implementation


{$R *.dfm}


uses System.StrUtils, Data.DBXPlatform, uLkJSON, JWToken;

function Tapi.User(id: Integer) : TJSONObject;
var
  object_json, object_json_ : TJSONObject;
  authorization, token : string;
  tmp: Integer;
begin
  authorization := vRequest.GetFieldByName('Authorization');

  token := '';
  if Pos('Bearer', authorization) <> 0 then
  begin
    tmp := Pos('Bearer', authorization);
    token := Trim(Copy(authorization , tmp + 6, Length(authorization)));
  end;

  if verifiedToken(IntToStr(id), token) then
  begin
    dsUser.Close;
    dsUser.CommandText := 'SELECT * FROM users WHERE id = ' + QuotedStr(IntToStr(id));
    dsUser.Open;

    if not dsUser.IsEmpty then
    begin
      object_json := TJSONObject.Create;
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('id'), TJSONString.Create(dsUserID.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('name'), TJSONString.Create(dsUserNAME.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('email'), TJSONString.Create(dsUserEMAIL.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('cpf_cnpj'), TJSONString.Create(dsUserCPF_CNPJ.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('rg_ie'), TJSONString.Create(dsUserRG_IE.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('phone1'), TJSONString.Create(dsUserPHONE1.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('phone1'), TJSONString.Create(dsUserPHONE2.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('address'), TJSONString.Create(dsUserADDRESS.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('number'), TJSONString.Create(dsUserNUMBER.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('neighborhood'), TJSONString.Create(dsUserNEIGHBORHOOD.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('city'), TJSONString.Create(dsUserCITY.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('state'), TJSONString.Create(dsUserSTATE.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('country'), TJSONString.Create(dsUserCOUNTRY.AsString)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('zipcode'), TJSONString.Create(dsUserCEP.AsString)));

      object_json_ := TJSONObject.Create;
      object_json_.AddPair('user', object_json);

      Result := object_json_;

      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
    end
    else
    begin
      object_json := TJSONObject.Create;
      object_json.AddPair('error', 'Usuário não encontrado!');
      Result := object_json;
      GetInvocationMetadata().ResponseCode := 401;
      GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
    end;
  end
  else
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('error', 'Você não está autorizado!');
    Result := object_json;
    GetInvocationMetadata().ResponseCode := 401;
    GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
  end;
end;

function Tapi.Getaddress(zipcode: string): TJSONObject;
var
  object_json, object_json_ : TJSONObject;
  address, neighborhood, city, state : string;
  JsonStream: TStringStream;
  vJsonObj2: TlkJSONlist;
  vJsonObj3: TlkJSONobject;
  zipcodeNotFound : Boolean;
  tmp : Integer;
begin
  if (Trim(zipcode).Length = 8) and (TryStrToInt(zipcode, tmp)) then
  begin
    zipcodeNotFound := False;
    try
      JsonStream := TStringStream.Create('');
      IdHTTPPesquisaCep.Get(Trim('http://viacep.com.br/ws/' + Trim(zipcode) + '/json'), JsonStream);

      if IdHTTPPesquisaCep.ResponseCode = 200 then
      begin
        vJsonObj3 := TlkJSON.ParseText(JsonStream.DataString) as TlkJSONobject;

        if vJsonObj3.FieldByIndex[0].SelfTypeName = 'jsBoolean' then
          zipcodeNotFound := True
        else
        begin
          address := vJsonObj3.Field['logradouro'].Value;
          neighborhood := vJsonObj3.Field['bairro'].Value;
          city := vJsonObj3.Field['localidade'].Value;
          state := UpperCase(vJsonObj3.Field['uf'].Value);
          zipcodeNotFound := False;
        end;
      end
      else
        zipcodeNotFound := True;
    finally
      FreeAndNil(JsonStream);
      FreeAndNil(vJsonObj2);
    end;

    if not zipcodeNotFound then
    begin
      object_json := TJSONObject.Create;
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('zipcode'), TJSONString.Create(zipcode)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('address'), TJSONString.Create(address)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('neighborhood'), TJSONString.Create(neighborhood)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('city'), TJSONString.Create(city)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('state'), TJSONString.Create(state)));
      object_json.AddPair(TJSONPair.Create(TJSONString.Create('country'), TJSONString.Create('Brasil')));

      object_json_ := TJSONObject.Create;
      object_json_.AddPair('success', 'Endereço encontrado');
      object_json_.AddPair('address', object_json);
      Result := object_json_;
      GetInvocationMetadata().ResponseCode := 200;
    end
    else
    begin
      object_json := TJSONObject.Create;
      object_json.AddPair('error', 'Endereço não encontrado.');
      Result := object_json;
      GetInvocationMetadata().ResponseCode := 401;
    end;
  end
  else
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('error', 'Endereço não encontrado.');
    Result := object_json;
    GetInvocationMetadata().ResponseCode := 401;
  end;

  GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
end;

function Tapi.updateLogin() : TJSONObject;
var
  object_json, object_json_, vContendFields: TJSONObject;
  email, password, token : string;
  MyJSONEnumerator : TJSONPairEnumerator;
begin
  email := vRequest.ContentFields.Values['email'];
  password := vRequest.ContentFields.Values['password'];

  if (email = '') and (password = '') then
  begin
    vContendFields := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vRequest.Content), 0) as TJSONObject;

    MyJSONEnumerator := vContendFields.GetEnumerator;
    while MyJSONEnumerator.MoveNext do
    begin
      if MyJSONEnumerator.Current.JsonString.Value = 'email' then
        email := MyJSONEnumerator.Current.JsonValue.Value;
      if MyJSONEnumerator.Current.JsonString.Value = 'password' then
        password := MyJSONEnumerator.Current.JsonValue.Value;
    end;
  end;

  dsUser.Close;
  dsUser.CommandText := 'SELECT * FROM users WHERE email LIKE ' + QuotedStr(email) +
      ' AND pass = ' + QuotedStr(password);
  dsUser.Open;

  if not dsUser.IsEmpty then
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair(TJSONPair.Create(TJSONString.Create('id'), TJSONString.Create(dsUserID.AsString)));
    object_json.AddPair(TJSONPair.Create(TJSONString.Create('name'), TJSONString.Create(dsUserNAME.AsString)));
    object_json.AddPair(TJSONPair.Create(TJSONString.Create('email'), TJSONString.Create(dsUserEMAIL.AsString)));

    object_json_ := TJSONObject.Create;
    object_json_.AddPair('user', object_json);
    token := generateToken(dsUserID.AsString);
    object_json_.AddPair('token', token);

    Result := object_json_;

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
  end
  else
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('error', 'E-mail e/ou Senha inválido(s).');

    Result := object_json;

    GetInvocationMetadata().ResponseCode := 401;
    GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
  end;
end;

function Tapi.updateLogout() : TJSONObject;
var
  object_json, vContendFields : TJSONObject;
  userid, authorization, token : string;
  tmp: Integer;
  MyJSONEnumerator : TJSONPairEnumerator;
begin
  userid := vRequest.ContentFields.Values['userid'];
  authorization := vRequest.GetFieldByName('Authorization');

  if (userid = '') then
  begin
    vContendFields := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(vRequest.Content), 0) as TJSONObject;

    MyJSONEnumerator := vContendFields.GetEnumerator;
    while MyJSONEnumerator.MoveNext do
    begin
      if MyJSONEnumerator.Current.JsonString.Value = 'userid' then
        userid := MyJSONEnumerator.Current.JsonValue.Value;
    end;
  end;

  token := '';
  if Pos('Bearer', authorization) <> 0 then
  begin
    tmp := Pos('Bearer', authorization);
    token := Trim(Copy(authorization , tmp + 6, Length(authorization)));
  end;

  if verifiedToken(userid, token) then
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('success', 'Você saiu. Volte sempre.');
    Result := object_json;

    GetInvocationMetadata().ResponseCode := 200;
  end
  else
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('error', 'Algum erro ocorreu. Tente novamente.');
    Result := object_json;

    GetInvocationMetadata().ResponseCode := 401;
  end;

  GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
end;

function Tapi.cancelRemove_wishlist() : TJSONObject;
var
  object_json : TJSONObject;
  userid, itemid, authorization, token : string;
  tmp : Integer;
begin
  userid := vRequest.QueryFields.Values['userid'];
  itemid := vRequest.QueryFields.Values['itemid'];

  authorization := vRequest.GetFieldByName('Authorization');

  token := '';
  if Pos('Bearer', authorization) <> 0 then
  begin
    tmp := Pos('Bearer', authorization);
    token := Trim(Copy(authorization , tmp + 6, Length(authorization)));
  end;

  if verifiedToken(userid, token) then
  begin
    if (userid <> '') and (itemid <> '')then
    begin
      try
        SQLQuery.SQL.Clear;
        SQLQuery.SQL.Text := 'DELETE FROM wishlist WHERE user_id = ' + QuotedStr(userid) +
                             ' AND product_id = ' + QuotedStr(itemid);
        SQLQuery.ExecSQL;

        object_json := TJSONObject.Create;
        object_json.AddPair('success', 'Produto excluído com sucesso.');
        Result := object_json;
        GetInvocationMetadata().ResponseCode := 200;
      except
        object_json := TJSONObject.Create;
        object_json.AddPair('error', 'Não foi possível remover. Tente novamente.');
        Result := object_json;
        GetInvocationMetadata().ResponseCode := 401;
        GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
      end;
    end
    else
    begin
      object_json := TJSONObject.Create;
      object_json.AddPair('error', 'Não foi possível remover. Tente novamente.');
      Result := object_json;
      GetInvocationMetadata().ResponseCode := 401;
    end;
  end
  else
  begin
    object_json := TJSONObject.Create;
    object_json.AddPair('error', 'Você não está autorizado!');
    Result := object_json;
    GetInvocationMetadata().ResponseCode := 401;
  end;

  GetInvocationMetadata().ResponseContentType := 'application/json; charset=utf-8';
end;


end.

