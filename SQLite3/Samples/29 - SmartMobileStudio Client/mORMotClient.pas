/// remote access to a mORMot server using SmartMobileStudio
// - retrieved from http://localhost:888/root/wrapper/SmartMobileStudio/mORMotClient.pas
// at 2014-08-07 11:03:35 using "SmartMobileStudio.pas.mustache" template
unit mORMotClient;

{
  WARNING:
    This unit has been generated by a mORMot 1.18 server.
    Any manual modification of this file may be lost after regeneration.

  Synopse mORMot framework. Copyright (C) 2014 Arnaud Bouchez
    Synopse Informatique - http://synopse.info

  This unit is released under a MPL/GPL/LGPL tri-license,
  and therefore may be freely included in any application.

  This unit would work on Smart Mobile Studio 2.1 and later.
}

interface

uses
  SmartCL.System,
  System.Types,
  SynCrossPlatformSpecific,
  SynCrossPlatformREST;


type // define some enumeration types, used below
  TPeopleSexe = (sFemale, sMale);
  TRecordEnum = (reOne, reTwo, reLast);

type // define some record types, used as properties below
  TTestCustomJSONArraySimpleArray = record
    F: string;
    G: array of string;
    H: record
      H1: integer;
      H2: string;
      H3: record
        H3a: boolean;
        H3b: TSQLRawBlob;
      end;
    end;
    I: TDateTime;
    J: array of record
      J1: byte;
      J2: TGUID;
      J3: TRecordEnum;
    end;
  end;

type
  /// service accessible via http://localhost:888/root/Calculator
  // - this service will run in sicShared mode
  // - synchronous and asynchronous methods are available, depending on use case
  // - synchronous _*() methods names will block the browser execution, so won't
  // be appropriate for long process - on error, they may raise EServiceException
  TServiceCalculator = class(TServiceClientAbstract)
  public
    /// will initialize an access to the remote service
    constructor Create(aClient: TSQLRestClientURI); override;

    procedure Add(n1: integer; n2: integer; 
      onSuccess: procedure(Result: integer); onError: TSQLRestEvent);
    function _Add(const n1: integer; const n2: integer): integer;

    procedure ToText(Value: currency; Curr: string; Sexe: TPeopleSexe; Name: string; 
      onSuccess: procedure(Sexe: TPeopleSexe; Name: string); onError: TSQLRestEvent);
    procedure _ToText(const Value: currency; const Curr: RawUTF8; var Sexe: TPeopleSexe; var Name: RawUTF8);

    procedure RecordToText(Rec: TTestCustomJSONArraySimpleArray; 
      onSuccess: procedure(Rec: TTestCustomJSONArraySimpleArray; Result: string); onError: TSQLRestEvent);
    function _RecordToText(var Rec: TTestCustomJSONArraySimpleArray): string;
  end;

  /// map "People" table
  TSQLRecordPeople = class(TSQLRecord)
  protected
    fFirstName: string; 
    fLastName: string; 
    fData: TSQLRawBlob; 
    fYearOfBirth: integer; 
    fYearOfDeath: word; 
    fSexe: TPeopleSexe; 
    fSimple: TTestCustomJSONArraySimpleArray; 
    // those overriden methods will emulate the needed RTTI
    class function ComputeRTTI: TRTTIPropInfos; override;
    procedure SetProperty(FieldIndex: integer; const Value: variant); override;
    function GetProperty(FieldIndex: integer): variant; override;
  public
    property FirstName: string read fFirstName write fFirstName;
    property LastName: string read fLastName write fLastName;
    property Data: TSQLRawBlob read fData write fData;
    property YearOfBirth: integer read fYearOfBirth write fYearOfBirth;
    property YearOfDeath: word read fYearOfDeath write fYearOfDeath;
    property Sexe: TPeopleSexe read fSexe write fSexe;
    property Simple: TTestCustomJSONArraySimpleArray read fSimple write fSimple;
  end;
  

/// return the database Model corresponding to this server
function GetModel: TSQLModel;

const
  /// the server port, corresponding to http://localhost:888
  SERVER_PORT = 888;


implementation


{ Some helpers for enumerates types }

{$HINTS OFF} // for begin asm return ... end; end below

// those functions will use the existing generated string array constant
// defined by the SMS compiler for each enumeration

function Variant2TPeopleSexe(const _variant: variant): TPeopleSexe;
begin
  asm return @VariantToEnum(@_variant,@TPeopleSexe); end;
end;

function Variant2TRecordEnum(const _variant: variant): TRecordEnum;
begin
  asm return @VariantToEnum(@_variant,@TRecordEnum); end;
end;

{$HINTS ON}

{ Some helpers for record types:
  due to potential obfuscation of generated JavaScript, we can't assume
  that the JSON used for transmission would match record fields naming }

function Variant2TTestCustomJSONArraySimpleArray(const Value: variant): TTestCustomJSONArraySimpleArray;
begin
  result.F := Value.F;
  for var item in Value.G do result.G.Add(item);
  result.H.H1 := Value.H.H1;
  result.H.H2 := Value.H.H2;
  result.H.H3.H3a := Value.H.H3.H3a;
  result.H.H3.H3b := VariantToBlob(Value.H.H3.H3b);
  result.I := Iso8601ToDateTime(Value.I);
  result.J.SetLength(integer(Value.J.length));
  for var n := 0 to result.J.High do begin
    var source := Value.J[n];
    var dest := result.J[n];
    dest.J1 := source.J1;
    dest.J2 := VariantToGUID(source.J2);
    dest.J3 := Variant2TRecordEnum(source.J3);
    result.J[n] := dest;
  end;
end;

function TTestCustomJSONArraySimpleArray2Variant(const Value: TTestCustomJSONArraySimpleArray): variant;
begin
  result := TVariant.CreateObject;
  result.F := Value.F;
  result.G := variant(Value.G);
  result.H := TVariant.CreateObject;
  result.H.H1 := Value.H.H1;
  result.H.H2 := Value.H.H2;
  result.H.H3 := TVariant.CreateObject;
  result.H.H3.H3a := Value.H.H3.H3a;
  result.H.H3.H3b := BlobToVariant(Value.H.H3.H3b);
  result.I := DateTimeToIso8601(Value.I);
  result.J := TVariant.CreateArray;
  for var source in Value.J do begin
    var dest := TVariant.CreateObject;
    dest.J1 := source.J1;
    dest.J2 := GUIDToVariant(source.J2);
    dest.J3 := ord(source.J3);
    result.J.push(dest);
  end;
end;


{ TSQLRecordPeople }

class function TSQLRecordPeople.ComputeRTTI: TRTTIPropInfos;
begin
  result := TRTTIPropInfos.Create(
    ['FirstName','LastName','Data','YearOfBirth','YearOfDeath','Sexe','Simple'],
    [sftUnspecified,sftUnspecified,sftBlob,sftUnspecified,sftUnspecified,sftUnspecified,sftRecord]);
end;

procedure TSQLRecordPeople.SetProperty(FieldIndex: integer; const Value: variant);
begin
  case FieldIndex of
  0: fID := Value;
  1: fFirstName := Value;
  2: fLastName := Value;
  3: fData := VariantToBlob(Value);
  4: fYearOfBirth := Value;
  5: fYearOfDeath := Value;
  6: fSexe := TPeopleSexe(Value);
  7: fSimple := Variant2TTestCustomJSONArraySimpleArray(Value);
  end;
end;

function TSQLRecordPeople.GetProperty(FieldIndex: integer): variant;
begin
  case FieldIndex of
  0: result := fID;
  1: result := fFirstName;
  2: result := fLastName;
  3: result := BlobToVariant(fData);
  4: result := fYearOfBirth;
  5: result := fYearOfDeath;
  6: result := ord(fSexe);
  7: result := TTestCustomJSONArraySimpleArray2Variant(fSimple);
  end;
end;


function GetModel: TSQLModel;
begin
  result := TSQLModel.Create([TSQLAuthUser,TSQLAuthGroup,TSQLRecordPeople],'root');
end;


{ TServiceCalculator }

constructor TServiceCalculator.Create(aClient: TSQLRestClientURI);
begin
  fServiceName := 'Calculator';
  fServiceURI := 'Calculator';
  fInstanceImplementation := sicShared;
  fContractExpected := 'D9CD85D75F8AE460';
  inherited Create(aClient);
end;


procedure TServiceCalculator.Add(n1: integer; n2: integer; 
      onSuccess: procedure(Result: integer); onError: TSQLRestEvent);
begin 
  fClient.CallRemoteServiceAsynch(self,'Add',1,
    [n1,n2],
    lambda (res: array of Variant)
      onSuccess(res[0]);
    end, onError); 
end;

function TServiceCalculator._Add(const n1: integer; const n2: integer): integer;
begin
  var res := fClient.CallRemoteServiceSynch(self,'Add',1,
    [n1,n2]);
  Result := res[0];
end;


procedure TServiceCalculator.ToText(Value: currency; Curr: string; Sexe: TPeopleSexe; Name: string; 
      onSuccess: procedure(Sexe: TPeopleSexe; Name: string); onError: TSQLRestEvent);
begin 
  fClient.CallRemoteServiceAsynch(self,'ToText',2,
    [Value,Curr,ord(Sexe),Name],
    lambda (res: array of Variant)
      onSuccess(TPeopleSexe(res[0]),res[1]);
    end, onError); 
end;

procedure TServiceCalculator._ToText(const Value: currency; const Curr: RawUTF8; var Sexe: TPeopleSexe; var Name: RawUTF8);
begin
  var res := fClient.CallRemoteServiceSynch(self,'ToText',2,
    [Value,Curr,ord(Sexe),Name]);
  Sexe := TPeopleSexe(res[0]);
  Name := res[1];
end;


procedure TServiceCalculator.RecordToText(Rec: TTestCustomJSONArraySimpleArray; 
      onSuccess: procedure(Rec: TTestCustomJSONArraySimpleArray; Result: string); onError: TSQLRestEvent);
begin 
  fClient.CallRemoteServiceAsynch(self,'RecordToText',2,
    [TTestCustomJSONArraySimpleArray2Variant(Rec)],
    lambda (res: array of Variant)
      onSuccess(Variant2TTestCustomJSONArraySimpleArray(res[0]),res[1]);
    end, onError); 
end;

function TServiceCalculator._RecordToText(var Rec: TTestCustomJSONArraySimpleArray): string;
begin
  var res := fClient.CallRemoteServiceSynch(self,'RecordToText',2,
    [TTestCustomJSONArraySimpleArray2Variant(Rec)]);
  Rec := Variant2TTestCustomJSONArraySimpleArray(res[0]);
  Result := res[1];
end;



end.