unit uCreateTest;

interface

uses classes;

type

  TCreateTestCodeBloatGenerics = class(TObject)
  private
    FSubPath: string;
    FNoUnits: integer;
    FNoOfClassesInUnit: integer;
    FPaddingFormatUnit: string;
    FPaddingFormatClass: string;
    procedure GenPasUnit(AUnitNo: integer);
    function PasUnitFileName(AUnitNo: integer): string;
    function PasUnitName(AUnitNo: integer): string;
    function GenClassName(AUnitNo: integer; AClassNo: integer): string;
    function GenListClassName(AUnitNo: integer; AClassNo: integer): string;
    function GenListClassVarName(AUnitNo: integer; AClassNo: integer): string;
  public
    constructor Create(ASubPath: string; ANoUnits: integer; ANoOfClassesInUnit: integer);
    procedure GeneratePasUnits;
    procedure GeneratePasProject;
  end;

implementation

uses sysutils, math;

{ TCreateTestCodeBloatGenerics }

constructor TCreateTestCodeBloatGenerics.Create(ASubPath: string; ANoUnits, ANoOfClassesInUnit: integer);
var
  iPad: integer;
begin
  inherited Create;
  FSubPath := ASubPath;
  if not directoryexists(FSubPath) then
    ForceDirectories(FSubPath);
  FNoUnits := ANoUnits;
  FNoOfClassesInUnit := ANoOfClassesInUnit;
  iPad := Floor(Log10(FNoUnits)) + 1;
  FPaddingFormatUnit := '%.' + iPad.ToString + 'd';
  iPad := Floor(Log10(FNoOfClassesInUnit)) + 1;
  FPaddingFormatClass := '%.' + iPad.ToString + 'd';
end;

procedure TCreateTestCodeBloatGenerics.GeneratePasUnits;
var
  i: integer;
begin
  for i := 0 to FNoUnits - 1 do
    GenPasUnit(i);
end;

function TCreateTestCodeBloatGenerics.PasUnitName(AUnitNo: integer): string;
begin
  Result := 'uGenClasses' + Format(FPaddingFormatUnit, [AUnitNo]);
end;

function TCreateTestCodeBloatGenerics.PasUnitFileName(AUnitNo: integer): string;
begin
  Result := PasUnitName(AUnitNo) + '.pas';
end;

function TCreateTestCodeBloatGenerics.GenClassName(AUnitNo, AClassNo: integer): string;
begin
  Result := 'TType' + Format(FPaddingFormatUnit, [AUnitNo]) +
  Format(FPaddingFormatClass, [AClassNo]);
end;

function TCreateTestCodeBloatGenerics.GenListClassName(AUnitNo, AClassNo: integer): string;
begin
  Result := 'TTypeList' + Format(FPaddingFormatUnit, [AUnitNo]) +
  Format(FPaddingFormatClass, [AClassNo]);
end;

function TCreateTestCodeBloatGenerics.GenListClassVarName(AUnitNo, AClassNo: integer): string;
begin
  Result := 'myList' + Format(FPaddingFormatUnit, [AUnitNo]) +
  Format(FPaddingFormatClass, [AClassNo]);
end;

procedure TCreateTestCodeBloatGenerics.GenPasUnit(AUnitNo: integer);
var
  LStream: TFileStream;
  LWriter: TTextWriter;
  LFileName: string;
  i: integer;
begin
  LFileName := FSubPath + PasUnitFileName(AUnitNo);
  LStream := TFileStream.Create(LFileName, fmCreate);
  try
    LWriter := TStreamWriter.Create(LStream);
    try
      LWriter.WriteLine('unit %s;', [PasUnitName(AUnitNo)]);
      LWriter.WriteLine;
      LWriter.WriteLine('interface');
      LWriter.WriteLine;
      LWriter.WriteLine('uses');
      LWriter.WriteLine('  SysUtils, Classes, Generics.Collections;');
      LWriter.WriteLine;
      LWriter.WriteLine('type');
      for i := 0 to FNoOfClassesInUnit - 1 do
        LWriter.WriteLine('  ' + GenClassName(AUnitNo, i) +
        ' = class(TObject) end;');
      LWriter.WriteLine;
      for i := 0 to FNoOfClassesInUnit - 1 do
        LWriter.WriteLine('  ' + GenListClassName(AUnitNo, i) + ' = TObjectList<'+ GenClassName(AUnitNo, i) + '>;');
      LWriter.WriteLine;
      LWriter.WriteLine('implementation');
      LWriter.WriteLine;
      LWriter.WriteLine('end.');
    finally
      LWriter.Free;
    end;
  finally
    LStream.Free;
  end;
end;

procedure TCreateTestCodeBloatGenerics.GeneratePasProject;
var
  LStream: TFileStream;
  LWriter: TTextWriter;
  LFileName: string;
  iU, iC: integer;
begin
  LFileName := FSubPath + 'TestProject.dpr';
  LStream := TFileStream.Create(LFileName, fmCreate);
  try
    LWriter := TStreamWriter.Create(LStream);
    try
      LWriter.WriteLine('program TestProject;');
      LWriter.WriteLine;
      LWriter.WriteLine('{$APPTYPE CONSOLE}');
      LWriter.WriteLine('{$R *.res}');
      LWriter.WriteLine;
      LWriter.WriteLine('uses');
      for iU := 0 to FNoUnits - 1 do
        LWriter.WriteLine('  ' + PasUnitName(iU) + ',');
      LWriter.WriteLine('  SysUtils, Classes, Generics.Collections;');
      LWriter.WriteLine;
      LWriter.WriteLine('var');
      for iU := 0 to FNoUnits - 1 do
      begin
        for iC := 0 to FNoOfClassesInUnit - 1 do
          LWriter.WriteLine('  ' + GenListClassVarName(iU, iC) + ': ' +
          GenListClassName(iU, iC) + ';');
      end;
      LWriter.WriteLine;
      LWriter.WriteLine('begin');
      for iU := 0 to FNoUnits - 1 do
      begin
        for iC := 0 to FNoOfClassesInUnit - 1 do
          LWriter.WriteLine('  ' + GenListClassVarName(iU, iC) + ':= ' +
          GenListClassName(iU, iC) + '.Create; ' + sLineBreak + '  ' +
          GenListClassVarName(iU, iC) + '.Sort; ' + sLineBreak + '  ' +
          GenListClassVarName(iU, iC) + '.Free;');
      end;
      LWriter.WriteLine('end.');
    finally
      LWriter.Free;
    end;
  finally
    LStream.Free;
  end;
end;

end.
