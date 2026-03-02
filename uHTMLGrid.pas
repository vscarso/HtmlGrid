unit uHTMLGrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Graphics, Controls, StrUtils;

type
  TColumnType = (ctText, ctBadge, ctButton, ctCheckBox, ctIconText, ctLink, ctFormatted);
  TGridTheme = (gtDefault, gtLight, gtDark, gtCorporate, gtMinimal, gtColorful);
  TBackgroundMode = (bmStretch, bmCenter, bmTile, bmCover);

  { Badge rule }

  TBadgeRuleItem = class(TCollectionItem)
  private
    FMatchValue: string;
    FCssClass: string;
    FText: string;
  published
    property MatchValue: string read FMatchValue write FMatchValue;
    property CssClass: string read FCssClass write FCssClass;
    property Text: string read FText write FText;
  end;

  TBadgeRuleCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TBadgeRuleItem;
    procedure SetItem(Index: Integer; AValue: TBadgeRuleItem);
  public
    function Add: TBadgeRuleItem;
    property Items[Index: Integer]: TBadgeRuleItem read GetItem write SetItem; default;
  end;

  { Button config }

  TGridButtonItem = class(TCollectionItem)
  private
    FButtonID: string;
    FCssClass: string;
    FIconClass: string;
    FParamField: string;
    FTooltip: string;
  published
    property ButtonID: string read FButtonID write FButtonID;
    property CssClass: string read FCssClass write FCssClass;
    property IconClass: string read FIconClass write FIconClass;
    property ParamField: string read FParamField write FParamField;
    property Tooltip: string read FTooltip write FTooltip;
  end;

  TGridButtonCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TGridButtonItem;
    procedure SetItem(Index: Integer; AValue: TGridButtonItem);
  public
    function Add: TGridButtonItem;
    property Items[Index: Integer]: TGridButtonItem read GetItem write SetItem; default;
  end;

  { Column }

  TGridColumn = class(TCollectionItem)
  private
    FFieldName: string;
    FTitle: string;
    FColumnType: TColumnType;
    FBadgeRules: TBadgeRuleCollection;
    FButtons: TGridButtonCollection;
    FWidth: Integer;
    FAlign: TAlignment;
    FVisible: Boolean;
    FIconClass: string;
    FTooltipField: string;
    FLinkField: string;
    FFormatMask: string;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property FieldName: string read FFieldName write FFieldName;
    property Title: string read FTitle write FTitle;
    property ColumnType: TColumnType read FColumnType write FColumnType;
    property BadgeRules: TBadgeRuleCollection read FBadgeRules write FBadgeRules;
    property Buttons: TGridButtonCollection read FButtons write FButtons;
    property Width: Integer read FWidth write FWidth;
    property Align: TAlignment read FAlign write FAlign;
    property Visible: Boolean read FVisible write FVisible;
    property IconClass: string read FIconClass write FIconClass;
    property TooltipField: string read FTooltipField write FTooltipField;
    property LinkField: string read FLinkField write FLinkField;
    property FormatMask: string read FFormatMask write FFormatMask;
  end;

  TGridColumnCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TGridColumn;
    procedure SetItem(Index: Integer; AValue: TGridColumn);
  public
    function Add: TGridColumn;
    property Items[Index: Integer]: TGridColumn read GetItem write SetItem; default;
  end;

  { Componente principal }

  THTMLGrid = class(TComponent)
  private
    FGridName: string;
    FDataSet: TDataSet;
    FColumns: TGridColumnCollection;

    FAutoGenerateColumns: Boolean;
    FUseBootstrapTheme: Boolean;
    FBootstrapTableClass: string;

    FFontName: string;
    FFontSize: Integer;
    FFontColor: TColor;
    FHeaderFontColor: TColor;
    FHeaderBackground: TColor;
    FRowBackground: TColor;
    FRowAlternateBackground: TColor;
    FBorderColor: TColor;
    FBorderWidth: Integer;
    FPadding: Integer;
    FMargin: Integer;
    FRoundedCorners: Boolean;
    FHoverHighlight: Boolean;
    FStripedRows: Boolean;
    FCompactMode: Boolean;

    FBackgroundImage: string;
    FBackgroundMode: TBackgroundMode;

    FTheme: TGridTheme;

    function ColorToHTML(AColor: TColor): string;
    function BuildTableStyle: string;
    function BuildHeaderStyle: string;
    function BuildRowStyle(Alternate: Boolean): string;
    function BuildBackgroundStyle: string;
    procedure ApplyThemeDefaults;
    procedure AutoBuildColumns;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function TabelaGerada: string;
  published
    property GridName: string read FGridName write FGridName;
    property DataSet: TDataSet read FDataSet write FDataSet;

    property Columns: TGridColumnCollection read FColumns write FColumns;
    property AutoGenerateColumns: Boolean read FAutoGenerateColumns write FAutoGenerateColumns default True;

    property UseBootstrapTheme: Boolean read FUseBootstrapTheme write FUseBootstrapTheme default True;
    property BootstrapTableClass: string read FBootstrapTableClass write FBootstrapTableClass;

    property FontName: string read FFontName write FFontName;
    property FontSize: Integer read FFontSize write FFontSize;
    property FontColor: TColor read FFontColor write FFontColor;
    property HeaderFontColor: TColor read FHeaderFontColor write FHeaderFontColor;
    property HeaderBackground: TColor read FHeaderBackground write FHeaderBackground;
    property RowBackground: TColor read FRowBackground write FRowBackground;
    property RowAlternateBackground: TColor read FRowAlternateBackground write FRowAlternateBackground;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderWidth: Integer read FBorderWidth write FBorderWidth;
    property Padding: Integer read FPadding write FPadding;
    property Margin: Integer read FMargin write FMargin;
    property RoundedCorners: Boolean read FRoundedCorners write FRoundedCorners;
    property HoverHighlight: Boolean read FHoverHighlight write FHoverHighlight;
    property StripedRows: Boolean read FStripedRows write FStripedRows;
    property CompactMode: Boolean read FCompactMode write FCompactMode;

    property BackgroundImage: string read FBackgroundImage write FBackgroundImage;
    property BackgroundMode: TBackgroundMode read FBackgroundMode write FBackgroundMode;

    property Theme: TGridTheme read FTheme write FTheme;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
begin
  RegisterComponents('VSComponents', [THTMLGrid]);
end;

{ TBadgeRuleCollection }

function TBadgeRuleCollection.Add: TBadgeRuleItem;
begin
  Result := TBadgeRuleItem(inherited Add);
end;

function TBadgeRuleCollection.GetItem(Index: Integer): TBadgeRuleItem;
begin
  Result := TBadgeRuleItem(inherited GetItem(Index));
end;

procedure TBadgeRuleCollection.SetItem(Index: Integer; AValue: TBadgeRuleItem);
begin
  inherited SetItem(Index, AValue);
end;

{ TGridButtonCollection }

function TGridButtonCollection.Add: TGridButtonItem;
begin
  Result := TGridButtonItem(inherited Add);
end;

function TGridButtonCollection.GetItem(Index: Integer): TGridButtonItem;
begin
  Result := TGridButtonItem(inherited GetItem(Index));
end;

procedure TGridButtonCollection.SetItem(Index: Integer; AValue: TGridButtonItem);
begin
  inherited SetItem(Index, AValue);
end;

{ TGridColumn }

constructor TGridColumn.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FBadgeRules := TBadgeRuleCollection.Create(TBadgeRuleItem);
  FButtons := TGridButtonCollection.Create(TGridButtonItem);
  FVisible := True;
  FAlign := taLeftJustify;
end;

destructor TGridColumn.Destroy;
begin
  FBadgeRules.Free;
  FButtons.Free;
  inherited Destroy;
end;

{ TGridColumnCollection }

function TGridColumnCollection.Add: TGridColumn;
begin
  Result := TGridColumn(inherited Add);
end;

function TGridColumnCollection.GetItem(Index: Integer): TGridColumn;
begin
  Result := TGridColumn(inherited GetItem(Index));
end;

procedure TGridColumnCollection.SetItem(Index: Integer; AValue: TGridColumn);
begin
  inherited SetItem(Index, AValue);
end;

{ THTMLGrid }

constructor THTMLGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColumns := TGridColumnCollection.Create(TGridColumn);
  FAutoGenerateColumns := True;
  FUseBootstrapTheme := True;
  FBootstrapTableClass := 'table table-striped table-hover table-bordered table-sm';

  FFontName := 'Segoe UI';
  FFontSize := 14;
  FFontColor := clBlack;
  FHeaderFontColor := clWhite;
  FHeaderBackground := $00444444;
  FRowBackground := clWhite;
  FRowAlternateBackground := $00F7F7F7;
  FBorderColor := $00CCCCCC;
  FBorderWidth := 1;
  FPadding := 4;
  FMargin := 0;
  FRoundedCorners := True;
  FHoverHighlight := True;
  FStripedRows := True;
  FCompactMode := True;

  FBackgroundImage := '';
  FBackgroundMode := bmCover;

  FTheme := gtDefault;
  ApplyThemeDefaults;
end;

destructor THTMLGrid.Destroy;
begin
  FColumns.Free;
  inherited Destroy;
end;

procedure THTMLGrid.ApplyThemeDefaults;
begin
  case FTheme of
    gtDefault:
      begin
        // já configurado no construtor
      end;
    gtLight:
      begin
        FHeaderBackground := $00E0E0E0;
        FHeaderFontColor := clBlack;
        FRowBackground := clWhite;
        FRowAlternateBackground := $00F7F7F7;
        FBorderColor := $00DDDDDD;
      end;
    gtDark:
      begin
        FHeaderBackground := $00222222;
        FHeaderFontColor := clWhite;
        FRowBackground := $00333333;
        FRowAlternateBackground := $00444444;
        FFontColor := clWhite;
        FBorderColor := $00555555;
      end;
    gtCorporate:
      begin
        FHeaderBackground := $006666CC;
        FHeaderFontColor := clWhite;
        FRowBackground := clWhite;
        FRowAlternateBackground := $00F5F7FB;
        FBorderColor := $00CCCCCC;
      end;
    gtMinimal:
      begin
        FHeaderBackground := clWhite;
        FHeaderFontColor := clBlack;
        FRowBackground := clWhite;
        FRowAlternateBackground := clWhite;
        FBorderColor := $00DDDDDD;
      end;
    gtColorful:
      begin
        FHeaderBackground := $0048C9B0;
        FHeaderFontColor := clWhite;
        FRowBackground := clWhite;
        FRowAlternateBackground := $00FFF8E1;
        FBorderColor := $00FFB74D;
      end;
  end;
end;

function THTMLGrid.ColorToHTML(AColor: TColor): string;
begin
  Result := Format('#%.2x%.2x%.2x', [Red(AColor), Green(AColor), Blue(AColor)]);
end;

function THTMLGrid.BuildBackgroundStyle: string;
begin
  Result := '';
  if FBackgroundImage <> '' then
  begin
    Result := Result + 'background-image:url(''' +
      StringReplace(FBackgroundImage, '\', '/', [rfReplaceAll]) + ''');';
    case FBackgroundMode of
      bmStretch:
        Result := Result + 'background-size:100% 100%;background-repeat:no-repeat;';
      bmCenter:
        Result := Result + 'background-size:auto;background-repeat:no-repeat;background-position:center;';
      bmTile:
        Result := Result + 'background-repeat:repeat;';
      bmCover:
        Result := Result + 'background-size:cover;background-repeat:no-repeat;background-position:center;';
    end;
  end;
end;

function THTMLGrid.BuildTableStyle: string;
begin
  Result := 'font-family:' + FFontName + ';' +
            'font-size:' + IntToStr(FFontSize) + 'px;' +
            'color:' + ColorToHTML(FFontColor) + ';' +
            'border:' + IntToStr(FBorderWidth) + 'px solid ' + ColorToHTML(FBorderColor) + ';' +
            'padding:' + IntToStr(FPadding) + 'px;' +
            'margin:' + IntToStr(FMargin) + 'px;';
  if FRoundedCorners then
    Result := Result + 'border-radius:4px;';
  Result := Result + BuildBackgroundStyle;
end;

function THTMLGrid.BuildHeaderStyle: string;
begin
  Result := 'background-color:' + ColorToHTML(FHeaderBackground) + ';' +
            'color:' + ColorToHTML(FHeaderFontColor) + ';';
end;

function THTMLGrid.BuildRowStyle(Alternate: Boolean): string;
var
  c: TColor;
begin
  if Alternate then
    c := FRowAlternateBackground
  else
    c := FRowBackground;
  Result := 'background-color:' + ColorToHTML(c) + ';';
end;

procedure THTMLGrid.AutoBuildColumns;
var
  i: Integer;
  col: TGridColumn;
  fld: TField;
begin
  if (FDataSet = nil) or (not FDataSet.Active) then Exit;
  if FColumns.Count > 0 then Exit;

  for i := 0 to FDataSet.FieldCount - 1 do
  begin
    fld := FDataSet.Fields[i];
    col := FColumns.Add;
    col.FieldName := fld.FieldName;
    col.Title := fld.DisplayLabel;
    if col.Title = '' then
      col.Title := fld.FieldName;

    case fld.DataType of
      ftDate, ftDateTime, ftTime:
        begin
          col.ColumnType := ctFormatted;
          col.FormatMask := 'dd/mm/yyyy hh:nn';
        end;
      ftFloat, ftCurrency, ftBCD, ftFMTBcd:
        begin
          col.ColumnType := ctFormatted;
          col.FormatMask := '#,##0.00';
        end;
    else
      col.ColumnType := ctText;
    end;
  end;
end;

function THTMLGrid.TabelaGerada: string;
var
  SL: TStringList;
  i, r: Integer;
  col: TGridColumn;
  v, html, styleRow, alignStr: string;
  fld: TField;
  btn: TGridButtonItem;
  alt: Boolean;
  brIdx, bIdx: Integer;
begin
  Result := '';
  if (FDataSet = nil) then Exit;

  if FAutoGenerateColumns and (FColumns.Count = 0) then
    AutoBuildColumns;

  SL := TStringList.Create;
  try
    SL.Add('<div class="table-responsive">');

    if FUseBootstrapTheme then
      SL.Add('<table class="' + FBootstrapTableClass + '" style="' + BuildTableStyle + '">')
    else
      SL.Add('<table style="' + BuildTableStyle + '">');

    // Cabeçalho
    SL.Add('<thead>');
    SL.Add('<tr style="' + BuildHeaderStyle + '">');
    for i := 0 to FColumns.Count - 1 do
    begin
      col := FColumns[i];
      if not col.Visible then Continue;
      html := '<th';
      if col.Width > 0 then
        html := html + ' style="width:' + IntToStr(col.Width) + 'px;"';
      html := html + '>' + col.Title + '</th>';
      SL.Add(html);
    end;
    SL.Add('</tr>');
    SL.Add('</thead>');

    // Corpo
    SL.Add('<tbody>');
    FDataSet.First;
    r := 0;
    while not FDataSet.EOF do
    begin
      alt := (r mod 2 = 1) and FStripedRows;
      styleRow := BuildRowStyle(alt);
      if FHoverHighlight then
        SL.Add('<tr style="' + styleRow + '" class="table-row">')
      else
        SL.Add('<tr style="' + styleRow + '">');

      for i := 0 to FColumns.Count - 1 do
      begin
        col := FColumns[i];
        if not col.Visible then Continue;

        fld := FDataSet.FindField(col.FieldName);
        if fld <> nil then
          v := fld.AsString
        else
          v := '';

        case col.Align of
          taLeftJustify: alignStr := 'left';
          taRightJustify: alignStr := 'right';
        else
          alignStr := 'center';
        end;

        html := '<td style="text-align:' + alignStr + ';">';

        case col.ColumnType of
          ctText:
            html := html + v;

          ctBadge:
            begin
              // valor padrão se nenhuma regra bater
              html := html + v;
              for brIdx := 0 to col.BadgeRules.Count - 1 do
              begin
                if SameText(v, col.BadgeRules[brIdx].MatchValue) then
                begin
                  html :=
                    '<span class="badge ' + col.BadgeRules[brIdx].CssClass +
                    ' rounded-pill p-2" style="width:7em;">' +
                    col.BadgeRules[brIdx].Text + '</span>';
                  Break;
                end;
              end;
            end;

          ctButton:
            begin
              html := html + '<div class="btn-group" role="group">';
              for bIdx := 0 to col.Buttons.Count - 1 do
              begin
                btn := col.Buttons[bIdx];
                html := html + '<button type="button" class="' + btn.CssClass + '"';
                if btn.Tooltip <> '' then
                  html := html + ' title="' + btn.Tooltip + '"';

                html := html + ' onclick="{{CallBack=' + FGridName + '.' + btn.ButtonID;
                if btn.ParamField <> '' then
                begin
                  fld := FDataSet.FindField(btn.ParamField);
                  if fld <> nil then
                    html := html + '(' + btn.ParamField + '=' + fld.AsString + ')';
                end;
                html := html + '}}">';

                if btn.IconClass <> '' then
                  html := html + '<span class="' + btn.IconClass + '"></span>'
                else
                  html := html + btn.ButtonID;

                html := html + '</button>';
              end;
              html := html + '</div>';
            end;

          ctCheckBox:
            begin
              if SameText(v, '1') or SameText(v, 'true') then
                html := html + '<input type="checkbox" checked disabled>'
              else
                html := html + '<input type="checkbox" disabled>';
            end;

          ctIconText:
            begin
              if col.IconClass <> '' then
                html := html + '<span class="' + col.IconClass + '"></span> ';
              html := html + v;
            end;

          ctLink:
            begin
              if col.LinkField <> '' then
              begin
                fld := FDataSet.FindField(col.LinkField);
                if fld <> nil then
                  html := html + '<a href="' + fld.AsString + '">' + v + '</a>'
                else
                  html := html + v;
              end
              else
                html := html + v;
            end;

          ctFormatted:
            begin
              if (col.FormatMask <> '') and (fld <> nil) then
              begin
                case fld.DataType of
                  ftFloat, ftCurrency, ftBCD, ftFMTBcd:
                    html := html + FormatFloat(col.FormatMask, fld.AsFloat);
                  ftDate, ftDateTime, ftTime:
                    html := html + FormatDateTime(col.FormatMask, fld.AsDateTime);
                else
                  html := html + v;
                end;
              end
              else
                html := html + v;
            end;
        end;

        html := html + '</td>';
        SL.Add(html);
      end;

      SL.Add('</tr>');
      Inc(r);
      FDataSet.Next;
    end;

    SL.Add('</tbody>');
    SL.Add('</table>');
    SL.Add('</div>');

    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

end.
