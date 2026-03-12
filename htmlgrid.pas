{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit HtmlGrid;

{$warn 5023 off : no warning about unused units}
interface

uses
  uHTMLGridColumnEditor, uHTMLGridColumnPropertyEditor, uHTMLGridEditor, 
  uHTMLGrid, uHTMLGridPreviewRender, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('uHTMLGridEditor', @uHTMLGridEditor.Register);
  RegisterUnit('uHTMLGrid', @uHTMLGrid.Register);
end;

initialization
  RegisterPackage('HtmlGrid', @Register);
end.
