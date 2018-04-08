﻿unit TestAutoMapper;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework,
  Test.Models,
  AutoMapper.Mapper,
  AutoMapper.ConfigurationProvider,
  Spring,
  Spring.Collections,
  AutoMapper.ClassPair
  ;

type

  TestTMapper = class(TTestCase)
  strict private
    FMapper: TMapper;
    procedure _Configure;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConfigure;
    procedure TestMap;
  end;

implementation


procedure TestTMapper.SetUp;
begin
  FMapper := Mapper;
end;

procedure TestTMapper.TearDown;
begin
//  FMapper.Free;
end;

procedure TestTMapper.TestConfigure;
begin
  _configure;
end;

procedure TestTMapper.TestMap;
var
  FPerson:    TPerson;
  FUserDTO:   TUserDTO;
  FPersonDTO: TPersonDTO;

  FFirstName, FLastName, FMiddleName, FFullName: string;
  FAge: integer;
begin
  _configure;
  FLastName   := 'Иванов';
  FFirstName  := 'Сергей';
  FMiddleName := 'Николаеивч';
  FAge        :=  26;
  FFullName := FLastName+' '+FFirstName+' '+FMiddleName;

  FPerson := TPerson.Create(FLastName, FFirstName, FMiddleName, FAge);

  FUserDTO    := Mapper.Map<TPerson, TUserDTO>(FPerson);
  FPersonDTO  := Mapper.Map<TPerson, TPersonDTO>(FPerson);

  CheckEquals(FFullName, FUserDTO.FullName);
  CheckEquals(FAge, FUserDTO.Age);
  CheckEquals(FLastName, FPersonDTO.LastName);
  CheckEquals(FFirstName, FPersonDTO.FirstName);
  CheckEquals(FMiddleName, FPerson.MiddleName);
  CheckEquals(FAge, FPerson.Age);
end;

procedure TestTMapper._Configure;
begin
  Mapper.Reset;
  Mapper.Configure(procedure (const cfg: TConfigurationProvider)
                  begin
                    cfg.CreateMap<TPerson, TUserDTO>(procedure (const FPerson: TPerson; const FUserDTO: TUserDTO)
                                                        begin
                                                          FUserDTO.FullName := FPerson.LastName    +' '+
                                                                               FPerson.FirstName   +' '+
                                                                               FPerson.MiddleName;

                                                          FUserDTO.Age      := FPerson.Age;
                                                        end
                                                      )
                       .CreateMap<TPerson, TPersonDTO>(procedure (const FPerson: TPerson; const FPersonDTO: TPersonDTO)
                                                        begin
                                                          FPersonDTO.LastName    := FPerson.LastName;
                                                          FPersonDTO.FirstName   := FPerson.FirstName;
                                                          FPersonDTO.MiddleName  := FPerson.MiddleName;
                                                          FPersonDTO.Age         := FPerson.Age;
                                                        end)
                  end);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTMapper.Suite);
end.

