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
    procedure TestMap;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConfigure;
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
  TestMap;
end;

procedure TestTMapper.TestMap;
var
  FPerson:    TPerson;
  FUserDTO:   TUserDTO;
  FPersonDTO: TPersonDTO;
begin
  FPerson := TPerson.Create('Иванов', 'Сергей', 'Николаевич', 26);

  FUserDTO    := Mapper.Map<TPerson, TUserDTO>(FPerson);
  FPersonDTO  := Mapper.Map<TPerson, TPersonDTO>(FPerson);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTMapper.Suite);
end.
