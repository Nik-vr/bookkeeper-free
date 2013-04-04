{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit manualdock; 

interface

uses
  mandocking, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('mandocking', @mandocking.Register); 
end; 

initialization
  RegisterPackage('manualdock', @Register); 
end.
