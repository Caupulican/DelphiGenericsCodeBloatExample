program GenerateBloatTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  uCreateTest in 'uCreateTest.pas';

var
  CreateTestCodeBloatGenerics: TCreateTestCodeBloatGenerics;
begin
  try
    CreateTestCodeBloatGenerics:= TCreateTestCodeBloatGenerics.Create('.\BloatTest\',30,20);
    try
      CreateTestCodeBloatGenerics.GeneratePasUnits;
      CreateTestCodeBloatGenerics.GeneratePasProject;
    finally
      CreateTestCodeBloatGenerics.Free;
    end;
  except
    on E: Exception do
    begin
      Writeln('Error: '+E.Message);
      exit;
    end;
  end;
  Writeln('Test Files generated');
  ReadLn(emptystr);
end.
