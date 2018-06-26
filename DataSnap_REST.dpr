program DataSnap_REST;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ServerUnit in 'ServerUnit.pas' {Form1},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas' {api: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  uLkJSON in 'uLkJSON\uLkJSON.pas',
  JOSE.Encoding.Base64 in 'JWT\Common\JOSE.Encoding.Base64.pas',
  JOSE.Hashing.HMAC in 'JWT\Common\JOSE.Hashing.HMAC.pas',
  JOSE.Signing.RSA in 'JWT\Common\JOSE.Signing.RSA.pas',
  JOSE.Types.Arrays in 'JWT\Common\JOSE.Types.Arrays.pas',
  JOSE.Types.Bytes in 'JWT\Common\JOSE.Types.Bytes.pas',
  JOSE.Types.JSON in 'JWT\Common\JOSE.Types.JSON.pas',
  JOSE.Builder in 'JWT\JOSE\JOSE.Builder.pas',
  JOSE.Consumer in 'JWT\JOSE\JOSE.Consumer.pas',
  JOSE.Consumer.Validators in 'JWT\JOSE\JOSE.Consumer.Validators.pas',
  JOSE.Context in 'JWT\JOSE\JOSE.Context.pas',
  JOSE.Core.Base in 'JWT\JOSE\JOSE.Core.Base.pas',
  JOSE.Core.Builder in 'JWT\JOSE\JOSE.Core.Builder.pas',
  JOSE.Core.JWA.Compression in 'JWT\JOSE\JOSE.Core.JWA.Compression.pas',
  JOSE.Core.JWA.Encryption in 'JWT\JOSE\JOSE.Core.JWA.Encryption.pas',
  JOSE.Core.JWA.Factory in 'JWT\JOSE\JOSE.Core.JWA.Factory.pas',
  JOSE.Core.JWA in 'JWT\JOSE\JOSE.Core.JWA.pas',
  JOSE.Core.JWA.Signing in 'JWT\JOSE\JOSE.Core.JWA.Signing.pas',
  JOSE.Core.JWE in 'JWT\JOSE\JOSE.Core.JWE.pas',
  JOSE.Core.JWK in 'JWT\JOSE\JOSE.Core.JWK.pas',
  JOSE.Core.JWS in 'JWT\JOSE\JOSE.Core.JWS.pas',
  JOSE.Core.JWT in 'JWT\JOSE\JOSE.Core.JWT.pas',
  JOSE.Core.Parts in 'JWT\JOSE\JOSE.Core.Parts.pas',
  JWToken in 'JWToken.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
