program golfumlwin64;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ugolfmainform, thandicapgolfumlclass
  { you can add units after this };

{$R *.res}

begin
  application.title:='Golfml Reader';
  Application.Initialize;
  application.createform(tmainform, mainform);
  Application.Run;
end.

