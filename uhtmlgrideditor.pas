unit uHTMLGridEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComponentEditors, Dialogs, Controls;

procedure Register;

type
  THTMLGridEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

uses
  uHTMLGrid;

procedure Register;
begin
  RegisterComponentEditor(THTMLGrid, THTMLGridEditor);
end;

procedure THTMLGridEditor.ExecuteVerb(Index: Integer);
var
  SaveDlg: TSaveDialog;
  OpenDlg: TOpenDialog;
  Grid: THTMLGrid;
begin
  Grid := Component as THTMLGrid;
  case Index of
    0: Grid.ShowPreview;
    1: Grid.ShowBrowserPreview;
    2: 
      begin
        SaveDlg := TSaveDialog.Create(nil);
        try
          SaveDlg.Title := 'Exportar Configuração do Grid';
          SaveDlg.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
          SaveDlg.DefaultExt := 'json';
          if SaveDlg.Execute then
          begin
            Grid.SaveToFile(SaveDlg.FileName);
            ShowMessage('Configuração exportada com sucesso para: ' + SaveDlg.FileName);
          end;
        finally
          SaveDlg.Free;
        end;
      end;
    3:
      begin
        OpenDlg := TOpenDialog.Create(nil);
        try
          OpenDlg.Title := 'Importar Configuração do Grid';
          OpenDlg.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
          if OpenDlg.Execute then
          begin
            if MessageDlg('Isso substituirá as colunas atuais. Continuar?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
              Grid.LoadFromFile(OpenDlg.FileName);
              ShowMessage('Configuração importada com sucesso!');
            end;
          end;
        finally
          OpenDlg.Free;
        end;
      end;
  end;
end;


function THTMLGridEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Preview HTML (Código Fonte)';
    1: Result := 'Preview no Navegador (Dados Fictícios)';
    2: Result := 'Exportar Configuração...';
    3: Result := 'Importar Configuração...';
  end;
end;

function THTMLGridEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

end.

