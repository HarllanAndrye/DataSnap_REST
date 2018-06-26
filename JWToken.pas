unit JWToken;

interface

uses
  Jose.Core.JWT, Jose.Core.Builder, Jose.Core.JWS, Jose.Core.JWK, Jose.Core.JWA, Jose.Types.JSON, Jose.Consumer,
  Jose.Core.Base, System.DateUtils, System.SysUtils;

function generateToken(subject: string): string;
function verifiedToken(subject, token: string): Boolean;

implementation

{ TJWToken }

function generateToken(subject: string): string;
var
  LToken: TJWT;
begin
  LToken := TJWT.Create;
  try
    // Token claims
    LToken.Claims.IssuedAt := Now;
    //LToken.Claims.Expiration := Now + 1; //24 Hrs
    LToken.Claims.Expiration := IncMinute(Now, 120); // 2 horas
    LToken.Claims.Issuer := 'apiREST';
    LToken.Claims.Subject := subject;

    // Signing and Compact format creation
    Result := TJOSE.SHA256CompactToken('my_v3ry_l0ng_4nd_s4f3_s3cr3t_k3y', LToken);
  finally
    LToken.Free;
  end;
end;

function verifiedToken(subject, token: string): Boolean;
var
  LConsumer: TJOSEConsumer;
begin
  LConsumer := TJOSEConsumerBuilder.NewConsumer
    .SetClaimsClass(TJWTClaims)
    // JWS-related validation
    .SetVerificationKey('my_v3ry_l0ng_4nd_s4f3_s3cr3t_k3y')
    .SetSkipVerificationKeyValidation
    .SetDisableRequireSignature
    // string-based claims validation
    .SetExpectedSubject(subject)
    // Time-related claims validation
    .SetRequireIssuedAt
    .SetRequireExpirationTime
    .SetAllowedClockSkew(25, TJOSETimeUnit.Seconds)
    .SetMaxFutureValidity(121, TJOSETimeUnit.Minutes)
    // Build the consumer object
    .Build();

  try
    LConsumer.Process(token);
    Result := True;
  except
    Result := False;
  end;
  LConsumer.Free;
end;

end.
