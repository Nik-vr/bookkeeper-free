{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit spkvcl; 

interface

uses
  SpkRollPanel, SpkAnimator, SpkExpandPanel, SpkGraphTools, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('SpkRollPanel', @SpkRollPanel.Register); 
  RegisterUnit('SpkExpandPanel', @SpkExpandPanel.Register); 
end; 

initialization
  RegisterPackage('spkvcl', @Register); 
end.
