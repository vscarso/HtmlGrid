unit uHTMLGridColumnPropertyEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, PropEdits, uHTMLGrid, uHTMLGridColumnEditor;

type
  TGridColumnCollectionEditor = class(TClassPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

function TGridColumnCollectionEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure TGridColumnCollectionEditor.Edit;
begin
  TfrmHTMLGridColumnEditor.Execute(nil, TGridColumnCollection(GetObjectValue));
end;

end.

