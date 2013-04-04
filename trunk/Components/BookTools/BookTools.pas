{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit BookTools; 

interface

uses
 CurrencyEdit, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('CurrencyEdit', @CurrencyEdit.Register); 
end; 

initialization
  RegisterPackage('BookTools', @Register); 
end.
