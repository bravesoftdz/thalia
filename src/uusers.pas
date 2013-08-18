unit uUsers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uSpeaker,uwhois;

implementation

function HandleTalk(Speaker : TSpeaker;language : string;var sentence : string;var canhandle : Boolean) : Boolean;
var
  tmp: String;
  tmp1: String;
  avar: String;
  sl: TStringList;
begin
  Result:=False;
  canhandle:=(pos('$userinfo(',sentence)>0);
  if pos('$getdescription(de)',sentence)>0 then
    begin
      sentence:='Oder Informationen über andere Benutzer erfragen.';
      result := true;
      canhandle:=true;
      exit;
    end;
  if not canhandle then exit;
  tmp := copy(sentence,0,pos('$userinfo(',sentence)-1);
  tmp1 :=copy(sentence,pos('$userinfo(',sentence)+10,length(sentence));
  avar := copy(tmp1,0,pos(')',tmp1)-1);
  tmp1 := copy(tmp1,pos(')',tmp1)+1,length(tmp1));
  if trim(avar) = '' then exit;
  sl := TStringList.Create;
  sl.Text := Speaker.Intf.Whois(avar);
  Result := True;
  if sl.Count>1 then
    sentence:=sl[1]
  else if (sl.Count>0) then
    sentence:=sl[0]
  else Result := False;
  sl.Free;
end;

initialization
  RegisterToSpeaker(@HandleTalk);
end.

