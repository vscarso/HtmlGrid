unit uHTMLGridPreview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type
  TfrmHTMLGridPreview = class(TForm)
    MemoHTML: TMemo;
  public
    procedure LoadHTML(const AHTML: string);
  end;

implementation

{$R *.lfm}

procedure TfrmHTMLGridPreview.LoadHTML(const AHTML: string);
begin
  MemoHTML.Lines.Text := AHTML;
end;

end.

