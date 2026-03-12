unit uHTMLGridPreviewRender;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, IpHtml;

type
  TfrmHTMLGridPreviewRender = class(TForm)
    HtmlPanel: TIpHtmlPanel;
  public
    procedure LoadHTML(const AHTML: string);
  end;

implementation

{$R *.lfm}

procedure TfrmHTMLGridPreviewRender.LoadHTML(const AHTML: string);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create(AHTML);
  try
    HtmlPanel.SetHtmlFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

end.

