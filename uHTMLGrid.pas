unit uHTMLGrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Graphics, Controls, StrUtils, uHTMLGridEditor, LCLIntf, Variants;

type
  TColumnType = (ctText, ctBadge, ctButton, ctCheckBox, ctIconText, ctLink, ctFormatted, ctDropdown, ctMultiElement);
  TGridTheme = (gtDefault, gtLight, gtDark, gtCorporate, gtMinimal, gtColorful);
  TBackgroundMode = (bmStretch, bmCenter, bmTile, bmCover);
  TCallbackType = (ctAuto, ctCustom);

  { Dropdown item }

  TDropdownItem = class(TCollectionItem)
  private
    FValue: string;
    FText: string;
    FIconClass: string;
    FCallbackType: TCallbackType; // ctAuto, ctCustom
    FCallbackName: string; // Nome do callback (ex: Excluir)
    FCallbackParam: string; // Parâmetro automático (ex: ID)
    FCallbackCustom: string; // String completa do callback (ex: {{CallBack=MinhaFuncao(A=1)}})
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Value: string read FValue write FValue; // Mantido para compatibilidade, usado como CallbackName se ctAuto
    property Text: string read FText write FText;
    property IconClass: string read FIconClass write FIconClass;
    property CallbackType: TCallbackType read FCallbackType write FCallbackType default ctAuto;
    property CallbackName: string read FCallbackName write FCallbackName;
    property CallbackParam: string read FCallbackParam write FCallbackParam;
    property CallbackCustom: string read FCallbackCustom write FCallbackCustom;
  end;

  TDropdownCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TDropdownItem;
    procedure SetItem(Index: Integer; AValue: TDropdownItem);
  public
    constructor Create; reintroduce;
    function Add: TDropdownItem;
    property Items[Index: Integer]: TDropdownItem read GetItem write SetItem; default;
  end;

  { Badge rule }

  TBadgeRuleItem = class(TCollectionItem)
  private
    FMatchValue: string;
    FCssClass: string;
    FText: string;
  public
    procedure Assign(Source: TPersistent); override;
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
    constructor Create; reintroduce;
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
    FCallbackType: TCallbackType;
    FCallbackCustom: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ButtonID: string read FButtonID write FButtonID;
    property CssClass: string read FCssClass write FCssClass;
    property IconClass: string read FIconClass write FIconClass;
    property ParamField: string read FParamField write FParamField;
    property Tooltip: string read FTooltip write FTooltip;
    property CallbackType: TCallbackType read FCallbackType write FCallbackType default ctAuto;
    property CallbackCustom: string read FCallbackCustom write FCallbackCustom;
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
    FDropdownOptions: TDropdownCollection;
    FWidth: Integer;
    FAlign: TAlignment;
    FVisible: Boolean;
    FShowText: Boolean;
    FIconClass: string;
    FTooltipField: string;
    FLinkField: string;
    FFormatMask: string;
    FCssClass: string;
    procedure SetBadgeRules(AValue: TBadgeRuleCollection);
    procedure SetDropdownOptions(AValue: TDropdownCollection);

  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;

  published
    property FieldName: string read FFieldName write FFieldName;
    property Title: string read FTitle write FTitle;
    property ColumnType: TColumnType read FColumnType write FColumnType;
    property BadgeRules: TBadgeRuleCollection read FBadgeRules write SetBadgeRules;
    property Buttons: TGridButtonCollection read FButtons write FButtons;
    property DropdownOptions: TDropdownCollection read FDropdownOptions write SetDropdownOptions;
    property Width: Integer read FWidth write FWidth;
    property Align: TAlignment read FAlign write FAlign;
    property Visible: Boolean read FVisible write FVisible;
    property ShowText: Boolean read FShowText write FShowText default True;
    property IconClass: string read FIconClass write FIconClass;
    property TooltipField: string read FTooltipField write FTooltipField;
    property LinkField: string read FLinkField write FLinkField;
    property FormatMask: string read FFormatMask write FFormatMask;
    property CssClass: string read FCssClass write FCssClass;
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
    FResponsive: Boolean;

    FBackgroundImage: string;
    FBackgroundMode: TBackgroundMode;

    FTheme: TGridTheme;

    procedure SetTheme(AValue: TGridTheme);
    procedure SetDataSet(AValue: TDataSet);
    function ColorToHTML(AColor: TColor): string;
    function BuildTableStyle: string;
    function BuildHeaderStyle: string;
    function BuildCellStyle: string;
    function BuildRowStyle(RowIndex: Integer): string;
    function BuildBackgroundStyle: string;

    procedure ApplyThemeDefaults;
    procedure AutoBuildColumns;
    procedure GerarColunasFicticias;
    function TabelaFicticia: string;
    function ValorFicticio(Linha, Coluna: Integer): string;
    function CSSPreviewBootstrap: string;
    function RenderCellText(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellBadge(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellButton(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellCheckBox(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellIconText(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellLink(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellFormatted(RowIndex: Integer; Col: TGridColumn): string;
    function RenderCellDropdown(RowIndex: Integer; Col: TGridColumn): string;
    function RenderMultiElement(RowIndex: Integer; Col: TGridColumn): string;
  public
    procedure ClearColumns;
    procedure RefreshColumns;
    procedure ShowPreview;
    procedure ShowBrowserPreview;
    procedure ImportarJSON(const AJSON: string);
    function ExportarJSON: string;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TabelaGerada(UseDummyData: Boolean = False): string;
  published
    property GridName: string read FGridName write FGridName;
    property DataSet: TDataSet read FDataSet write SetDataSet;

    property Columns: TGridColumnCollection read FColumns write FColumns;
    property AutoGenerateColumns: Boolean read FAutoGenerateColumns write FAutoGenerateColumns default False; // Mudado para False por padrão

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

    property Theme: TGridTheme read FTheme write SetTheme;
  end;

procedure Register;

implementation

uses
  Math, uHTMLGridPreview, uHTMLGridPreviewRender,fpjson, jsonparser;

{ TBadgeRuleItem }

procedure THTMLGrid.SaveToFile(const FileName: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := ExportarJSON;
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

procedure THTMLGrid.LoadFromFile(const FileName: string);
var
  SL: TStringList;
begin
  if not FileExists(FileName) then Exit;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    ImportarJSON(SL.Text);
  finally
    SL.Free;
  end;
end;

function THTMLGrid.ExportarJSON: string;
var
  root, colObj, ruleObj, btnObj, dropObj: TJSONObject;
  colsArr, rulesArr, btnsArr, dropsArr: TJSONArray;
  c, r, b, d: Integer;
  col: TGridColumn;
  rule: TBadgeRuleItem;
  btn: TGridButtonItem;
  opt: TDropdownItem;
begin
  root := TJSONObject.Create;
  colsArr := TJSONArray.Create;
  root.Add('columns', colsArr);

  for c := 0 to FColumns.Count - 1 do
  begin
    col := FColumns[c];
    colObj := TJSONObject.Create;

    colObj.Add('FieldName', col.FieldName);
    colObj.Add('Title', col.Title);
    colObj.Add('ColumnType', Ord(col.ColumnType));
    colObj.Add('Width', col.Width);
    colObj.Add('Align', Ord(col.Align));
    colObj.Add('Visible', col.Visible);
    colObj.Add('ShowText', col.ShowText);
    colObj.Add('IconClass', col.IconClass);
    colObj.Add('TooltipField', col.TooltipField);
    colObj.Add('LinkField', col.LinkField);
    colObj.Add('FormatMask', col.FormatMask);
    colObj.Add('CssClass', col.CssClass);

    // Badges
    rulesArr := TJSONArray.Create;
    for r := 0 to col.BadgeRules.Count - 1 do
    begin
      rule := col.BadgeRules[r];
      ruleObj := TJSONObject.Create;
      ruleObj.Add('MatchValue', rule.MatchValue);
      ruleObj.Add('CssClass', rule.CssClass);
      ruleObj.Add('Text', rule.Text);
      rulesArr.Add(ruleObj);
    end;
    colObj.Add('BadgeRules', rulesArr);

    // Buttons
    btnsArr := TJSONArray.Create;
    for b := 0 to col.Buttons.Count - 1 do
    begin
      btn := col.Buttons[b];
      btnObj := TJSONObject.Create;
      btnObj.Add('ButtonID', btn.ButtonID);
      btnObj.Add('CssClass', btn.CssClass);
      btnObj.Add('IconClass', btn.IconClass);
      btnObj.Add('ParamField', btn.ParamField);
      btnObj.Add('Tooltip', btn.Tooltip);
      btnObj.Add('CallbackType', Ord(btn.CallbackType));
      btnObj.Add('CallbackCustom', btn.CallbackCustom);
      btnsArr.Add(btnObj);
    end;
    colObj.Add('Buttons', btnsArr);

    // Dropdown
    dropsArr := TJSONArray.Create;
    for d := 0 to col.DropdownOptions.Count - 1 do
    begin
      opt := col.DropdownOptions[d];
      dropObj := TJSONObject.Create;
      dropObj.Add('Value', opt.Value);
      dropObj.Add('Text', opt.Text);
      dropObj.Add('IconClass', opt.IconClass);
      dropObj.Add('CallbackType', Ord(opt.CallbackType));
      dropObj.Add('CallbackName', opt.CallbackName);
      dropObj.Add('CallbackParam', opt.CallbackParam);
      dropObj.Add('CallbackCustom', opt.CallbackCustom);
      dropsArr.Add(dropObj);
    end;
    colObj.Add('DropdownOptions', dropsArr);

    colsArr.Add(colObj);
  end;

  Result := root.FormatJSON;
  root.Free;
end;

procedure THTMLGrid.ImportarJSON(const AJSON: string);
var
  root, colObj, ruleObj, btnObj, dropObj: TJSONObject;
  colsArr, rulesArr, btnsArr, dropsArr: TJSONArray;
  c, r, b, d: Integer;
  col: TGridColumn;
  rule: TBadgeRuleItem;
  btn: TGridButtonItem;
  opt: TDropdownItem;
begin
  root := TJSONObject(GetJSON(AJSON));
  colsArr := root.Arrays['columns'];

  FColumns.Clear;

  for c := 0 to colsArr.Count - 1 do
  begin
    colObj := colsArr.Objects[c];
    col := FColumns.Add;

    col.FieldName := colObj.Get('FieldName', '');
    col.Title := colObj.Get('Title', '');
    col.ColumnType := TColumnType(colObj.Get('ColumnType', 0));
    col.Width := colObj.Get('Width', 0);
    col.Align := TAlignment(colObj.Get('Align', 0));
    col.Visible := colObj.Get('Visible', True);
    col.ShowText := colObj.Get('ShowText', True);
    col.IconClass := colObj.Get('IconClass', '');
    col.TooltipField := colObj.Get('TooltipField', '');
    col.LinkField := colObj.Get('LinkField', '');
    col.FormatMask := colObj.Get('FormatMask', '');
    col.CssClass := colObj.Get('CssClass', '');

    // Badges
    rulesArr := colObj.Arrays['BadgeRules'];
    if rulesArr <> nil then
      for r := 0 to rulesArr.Count - 1 do
      begin
        ruleObj := rulesArr.Objects[r];
        rule := col.BadgeRules.Add;
        rule.MatchValue := ruleObj.Get('MatchValue', '');
        rule.CssClass := ruleObj.Get('CssClass', '');
        rule.Text := ruleObj.Get('Text', '');
      end;

    // Buttons
    btnsArr := colObj.Arrays['Buttons'];
    if btnsArr <> nil then
      for b := 0 to btnsArr.Count - 1 do
      begin
        btnObj := btnsArr.Objects[b];
        btn := col.Buttons.Add;
        btn.ButtonID := btnObj.Get('ButtonID', '');
        btn.CssClass := btnObj.Get('CssClass', '');
        btn.IconClass := btnObj.Get('IconClass', '');
        btn.ParamField := btnObj.Get('ParamField', '');
        btn.Tooltip := btnObj.Get('Tooltip', '');
        btn.CallbackType := TCallbackType(btnObj.Get('CallbackType', 0));
        btn.CallbackCustom := btnObj.Get('CallbackCustom', '');
      end;

    // Dropdown
    dropsArr := colObj.Arrays['DropdownOptions'];
    if dropsArr <> nil then
      for d := 0 to dropsArr.Count - 1 do
      begin
        dropObj := dropsArr.Objects[d];
        opt := col.DropdownOptions.Add;
        opt.Value := dropObj.Get('Value', '');
        opt.Text := dropObj.Get('Text', '');
        opt.IconClass := dropObj.Get('IconClass', '');
        opt.CallbackType := TCallbackType(dropObj.Get('CallbackType', 0));
        opt.CallbackName := dropObj.Get('CallbackName', '');
        opt.CallbackParam := dropObj.Get('CallbackParam', '');
        opt.CallbackCustom := dropObj.Get('CallbackCustom', '');
      end;
  end;
  root.Free;
end;

function THTMLGrid.CSSPreviewBootstrap: string;
begin
  Result :=
    '<style>' +
    'table { border-collapse: collapse; width: 100%; }' +
    'th, td { border: 1px solid #ccc; padding: 4px; }' +
    '.table-striped tbody tr:nth-of-type(odd) { background-color: #f9f9f9; }' +
    '.table-hover tbody tr:hover { background-color: #f1f1f1; }' +
    '.table-bordered { border: 1px solid #ccc; }' +
    '.table-sm th, .table-sm td { padding: 2px !important; }' +
    '</style>';
end;

procedure TBadgeRuleItem.Assign(Source: TPersistent);
var
  S: TBadgeRuleItem;
begin
  if Source is TBadgeRuleItem then
  begin
    S := TBadgeRuleItem(Source);
    MatchValue := S.MatchValue;
    CssClass   := S.CssClass;
    Text       := S.Text;
  end
  else
    inherited Assign(Source);
end;

{ TBadgeRuleCollection }

constructor TBadgeRuleCollection.Create;
begin
  inherited Create(TBadgeRuleItem);
end;

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

{ TDropdownCollection }

constructor TDropdownCollection.Create;
begin
  inherited Create(TDropdownItem);
end;

function TDropdownCollection.Add: TDropdownItem;
begin
  Result := TDropdownItem(inherited Add);
end;

function TDropdownCollection.GetItem(Index: Integer): TDropdownItem;
begin
  Result := TDropdownItem(inherited GetItem(Index));
end;

procedure TDropdownCollection.SetItem(Index: Integer; AValue: TDropdownItem);
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
  FBadgeRules := TBadgeRuleCollection.Create;
  FButtons    := TGridButtonCollection.Create(TGridButtonItem);
  FDropdownOptions := TDropdownCollection.Create;
  FVisible    := True;
  FShowText   := True;
  FAlign      := taLeftJustify;
end;

destructor TGridColumn.Destroy;
begin
  FBadgeRules.Free;
  FButtons.Free;
  FDropdownOptions.Free;
  inherited Destroy;
end;

procedure TGridColumn.Assign(Source: TPersistent);
var
  S: TGridColumn;
begin
  if Source is TGridColumn then
  begin
    S := TGridColumn(Source);

    FieldName     := S.FieldName;
    Title         := S.Title;
    ColumnType    := S.ColumnType;
    Width         := S.Width;
    Align         := S.Align;
    Visible       := S.Visible;
    ShowText      := S.ShowText;
    IconClass     := S.IconClass;
    TooltipField  := S.TooltipField;
    LinkField     := S.LinkField;
    FormatMask    := S.FormatMask;
    CssClass      := S.CssClass;

    BadgeRules.Assign(S.BadgeRules);
    Buttons.Assign(S.Buttons);
    DropdownOptions.Assign(S.DropdownOptions);
  end
  else
    inherited Assign(Source);
end;

procedure TGridColumn.SetBadgeRules(AValue: TBadgeRuleCollection);
begin
  FBadgeRules.Assign(AValue);
end;

procedure TGridColumn.SetDropdownOptions(AValue: TDropdownCollection);
begin
  FDropdownOptions.Assign(AValue);
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

procedure TGridButtonItem.Assign(Source: TPersistent);
var
  S: TGridButtonItem;
begin
  if Source is TGridButtonItem then
  begin
    S := TGridButtonItem(Source);
    ButtonID := S.ButtonID;
    CssClass := S.CssClass;
    IconClass := S.IconClass;
    ParamField := S.ParamField;
    Tooltip := S.Tooltip;
    CallbackType := S.CallbackType;
    CallbackCustom := S.CallbackCustom;
  end
  else
    inherited Assign(Source);
end;

procedure TDropdownItem.Assign(Source: TPersistent);
var
  S: TDropdownItem;
begin
  if Source is TDropdownItem then
  begin
    S := TDropdownItem(Source);
    Value := S.Value;
    Text := S.Text;
    IconClass := S.IconClass;
    CallbackType := S.CallbackType;
    CallbackName := S.CallbackName;
    CallbackParam := S.CallbackParam;
    CallbackCustom := S.CallbackCustom;
  end
  else
    inherited Assign(Source);
end;

{ THTMLGrid }

procedure THTMLGrid.SetDataSet(AValue: TDataSet);
begin
  if FDataSet = AValue then Exit;
  FDataSet := AValue;
  if FDataSet <> nil then
    FDataSet.FreeNotification(Self);

  // Só gera colunas automaticamente se a coleção estiver vazia E a flag AutoGenerateColumns estiver True
  if (FDataSet <> nil) and (FDataSet.Active) and (FAutoGenerateColumns) and (FColumns.Count = 0) then
    AutoBuildColumns;
end;

procedure THTMLGrid.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

constructor THTMLGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColumns := TGridColumnCollection.Create(TGridColumn);
  FAutoGenerateColumns := False; // Padrão False para não sobrescrever
  FUseBootstrapTheme   := True;
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

procedure THTMLGrid.SetTheme(AValue: TGridTheme);
begin
  if FTheme = AValue then Exit;
  FTheme := AValue;
  ApplyThemeDefaults;
end;

procedure THTMLGrid.ApplyThemeDefaults;
begin
  case FTheme of
    gtDefault:
      begin
        FHeaderBackground := $00444444;
        FHeaderFontColor := clWhite;
        FRowBackground := clWhite;
        FRowAlternateBackground := $00F7F7F7;
        FBorderColor := $00CCCCCC;
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
  Result :=
    'font-family:' + FFontName + ';' +
    'font-size:' + IntToStr(FFontSize) + 'px;' +
    'color:' + ColorToHTML(FFontColor) + ';' +
    'border:' + IntToStr(FBorderWidth) + 'px solid ' + ColorToHTML(FBorderColor) + ';' +
    'padding:' + IntToStr(FPadding) + 'px;' +
    'margin:' + IntToStr(FMargin) + 'px;' +
    'border-collapse:collapse;';
end;

function THTMLGrid.BuildHeaderStyle: string;
begin
  Result :=
    'background-color:' + ColorToHTML(FHeaderBackground) + ';' +
    'color:' + ColorToHTML(FHeaderFontColor) + ';' +
    'border:' + IntToStr(FBorderWidth) + 'px solid ' + ColorToHTML(FBorderColor) + ';' +
    'padding:' + IntToStr(FPadding) + 'px;';
end;

function THTMLGrid.BuildCellStyle: string;
begin
  Result :=
    'color:' + ColorToHTML(FFontColor) + ';' +
    'border:' + IntToStr(FBorderWidth) + 'px solid ' + ColorToHTML(FBorderColor) + ';' +
    'padding:' + IntToStr(FPadding) + 'px;';
end;

function THTMLGrid.BuildRowStyle(RowIndex: Integer): string;
var
  bg: TColor;
begin
  if FStripedRows and (RowIndex mod 2 = 1) then
    bg := FRowAlternateBackground
  else
    bg := FRowBackground;

  Result := 'background-color:' + ColorToHTML(bg) + ';';
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

function THTMLGrid.ValorFicticio(Linha, Coluna: Integer): string;
var
  Col: TGridColumn;
  BaseVal: string;
begin
  if (Coluna < 0) or (Coluna >= FColumns.Count) then
  begin
    Result := 'Dado ' + IntToStr(Linha + 1);
    Exit;
  end;

  Col := FColumns[Coluna];
  BaseVal := LowerCase(Col.FieldName + ' ' + Col.Title);

  if (ContainsText(BaseVal, 'nome')) or (ContainsText(BaseVal, 'cliente')) or (ContainsText(BaseVal, 'usuario')) then
  begin
    case Linha mod 5 of
      0: Result := 'João Silva';
      1: Result := 'Maria Santos';
      2: Result := 'Pedro Oliveira';
      3: Result := 'Ana Costa';
      4: Result := 'Carlos Souza';
    end;
  end
  else if (ContainsText(BaseVal, 'data')) or (ContainsText(BaseVal, 'vencimento')) then
    Result := DateToStr(Date - Linha)
  else if (ContainsText(BaseVal, 'valor')) or (ContainsText(BaseVal, 'preco')) or (ContainsText(BaseVal, 'total')) or (Col.ColumnType = ctFormatted) then
    Result := FormatCurr(IfThen(Col.FormatMask <> '', Col.FormatMask, '#,##0.00'), 100.50 + Linha * 15.75)
  else if (ContainsText(BaseVal, 'cidade')) or (ContainsText(BaseVal, 'local')) then
  begin
    case Linha mod 5 of
      0: Result := 'São Paulo';
      1: Result := 'Rio de Janeiro';
      2: Result := 'Belo Horizonte';
      3: Result := 'Curitiba';
      4: Result := 'Porto Alegre';
    end;
  end
  else if (ContainsText(BaseVal, 'id')) or (ContainsText(BaseVal, 'codigo')) then
    Result := IntToStr(Linha + 101)
  else if (Col.ColumnType = ctBadge) and (Col.BadgeRules.Count > 0) then
    Result := Col.BadgeRules[Linha mod Col.BadgeRules.Count].MatchValue
  else if (ContainsText(BaseVal, 'email')) then
    Result := 'contato' + IntToStr(Linha + 1) + '@exemplo.com'
  else
    Result := Col.Title + ' ' + IntToStr(Linha + 1);
end;

function THTMLGrid.TabelaFicticia: string;
var
  SL: TStringList;
  r, c: Integer;
begin
  SL := TStringList.Create;
  try
    if FUseBootstrapTheme and (FBootstrapTableClass <> '') then
      SL.Add('<table class="' + FBootstrapTableClass + '" style="' + BuildTableStyle + '">')
    else
      SL.Add('<table style="' + BuildTableStyle + '">');

    SL.Add('<thead><tr>');
    for c := 0 to Columns.Count - 1 do
      SL.Add('<th style="' + BuildHeaderStyle + '">' + Columns[c].Title + '</th>');
    SL.Add('</tr></thead>');

    SL.Add('<tbody>');
    for r := 0 to 4 do
    begin
      SL.Add('<tr style="' + BuildRowStyle(r) + '">');
      for c := 0 to Columns.Count - 1 do
        SL.Add('<td style="' + BuildCellStyle + '">' + ValorFicticio(r, c) + '</td>');
      SL.Add('</tr>');
    end;
    SL.Add('</tbody>');

    SL.Add('</table>');
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function THTMLGrid.RenderCellText(RowIndex: Integer; Col: TGridColumn): string;
var
  F: TField;
begin
  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
      Result := F.AsString
    else
      Result := '';
  end
  else
    Result := ValorFicticio(RowIndex, Col.Index);
end;

function THTMLGrid.RenderCellBadge(RowIndex: Integer; Col: TGridColumn): string;
var
  Value, CssClass, Text: string;
  i: Integer;
  Rule: TBadgeRuleItem;
  F: TField;
begin
  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
      Value := Trim(F.DisplayText)
    else
      Value := '';
  end
  else
    Value := Trim(ValorFicticio(RowIndex, Col.Index));

  Value := LowerCase(Value);

  if (Value = 'true') or (Value = 't') or (Value = '1') then
    Value := 'true'
  else
  if (Value = 'false') or (Value = 'f') or (Value = '0') then
    Value := 'false';

  CssClass := 'badge bg-secondary';
  Text := Value;

  for i := 0 to Col.BadgeRules.Count - 1 do
  begin
    Rule := Col.BadgeRules[i];
    if SameText(Rule.MatchValue, Value) then
    begin
      if Rule.CssClass <> '' then
        CssClass := 'badge ' + Rule.CssClass;
      if Rule.Text <> '' then
        Text := Rule.Text;
      Break;
    end;
  end;

  Result :=
    '<span class="' + CssClass + '">' +
    Text +
    '</span>';
end;

function THTMLGrid.RenderCellButton(RowIndex: Integer; Col: TGridColumn): string;
var
  i: Integer;
  Btn: TGridButtonItem;
  IDValue, CallbackStr, ParamName, EffectiveGridName: string;
  SL: TStringList;
  F: TField;
begin
  Result := '';
  if Col.Buttons.Count = 0 then Exit;

  EffectiveGridName := FGridName;
  if EffectiveGridName = '' then
    EffectiveGridName := Name;
  if EffectiveGridName = '' then
    EffectiveGridName := 'HtmlGrid';

  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
      IDValue := F.AsString
    else
      IDValue := '';
  end
  else
    IDValue := IntToStr(RowIndex + 1);

  SL := TStringList.Create;
  try
    for i := 0 to Col.Buttons.Count - 1 do
    begin
      Btn := Col.Buttons[i];
      SL.Add('<button type="button" class="btn btn-sm ' + Btn.CssClass + '" ');
      if Btn.Tooltip <> '' then
        SL.Add('title="' + Btn.Tooltip + '" ');

      // Callback D2Bridge
      if Btn.CallbackType = ctCustom then
        CallbackStr := Btn.CallbackCustom
      else
      begin
        // Usa ParamField se definido, senão usa FieldName da coluna
        if Btn.ParamField <> '' then
          ParamName := Btn.ParamField
        else
          ParamName := Col.FieldName;
          
        CallbackStr := '{{CallBack=' + EffectiveGridName + '.' + Btn.ButtonID + '(' + ParamName + '=' + IDValue + ')}}';
      end;
      
      SL.Add('onclick="' + CallbackStr + '">');

      if Btn.IconClass <> '' then
        SL.Add('<i class="' + Btn.IconClass + '"></i> ');

      SL.Add('</button> ');
    end;
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function THTMLGrid.RenderCellDropdown(RowIndex: Integer; Col: TGridColumn): string;
var
  i: Integer;
  Opt: TDropdownItem;
  IDValue, CallbackStr, ParamName, CallName, EffectiveGridName: string;
  SL: TStringList;
  F: TField;
begin
  Result := '';
  if Col.DropdownOptions.Count = 0 then Exit;

  EffectiveGridName := FGridName;
  if EffectiveGridName = '' then
    EffectiveGridName := Name;
  if EffectiveGridName = '' then
    EffectiveGridName := 'HtmlGrid';

  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
      IDValue := F.AsString
    else
      IDValue := '';
  end
  else
    IDValue := IntToStr(RowIndex + 1);

  SL := TStringList.Create;
  try
    SL.Add('<div class="dropdown">');
    SL.Add('  <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">');
    SL.Add('    Ações');
    SL.Add('  </button>');
    SL.Add('  <ul class="dropdown-menu">');

    for i := 0 to Col.DropdownOptions.Count - 1 do
    begin
      Opt := Col.DropdownOptions[i];
      
      if Opt.CallbackType = ctCustom then
        CallbackStr := Opt.CallbackCustom
      else
      begin
        if Opt.CallbackName <> '' then
          CallName := Opt.CallbackName
        else
          CallName := Opt.Value; // Fallback para Value

        if Opt.CallbackParam <> '' then
          ParamName := Opt.CallbackParam
        else
          ParamName := Col.FieldName;

        CallbackStr := '{{CallBack=' + EffectiveGridName + '.' + CallName + '(' + ParamName + '=' + IDValue + ')}}';
      end;

      SL.Add('    <li><a class="dropdown-item" href="#" onclick="' + CallbackStr + '">');
      if Opt.IconClass <> '' then
        SL.Add('<i class="' + Opt.IconClass + '"></i> ');
      SL.Add(Opt.Text + '</a></li>');
    end;

    SL.Add('  </ul>');
    SL.Add('</div>');
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function THTMLGrid.RenderMultiElement(RowIndex: Integer; Col: TGridColumn): string;
begin
  Result := '<div class="d-flex align-items-center gap-2">';
  if Col.ShowText then
    Result := Result + '<span>' + RenderCellText(RowIndex, Col) + '</span>';

  if Col.BadgeRules.Count > 0 then
    Result := Result + RenderCellBadge(RowIndex, Col);

  if Col.Buttons.Count > 0 then
    Result := Result + RenderCellButton(RowIndex, Col);
    
  Result := Result + '</div>';
end;

function THTMLGrid.RenderCellCheckBox(RowIndex: Integer; Col: TGridColumn): string;
var
  Checked: Boolean;
  Value: string;
  F: TField;
begin
  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
      Value := F.AsString
    else
      Value := '0';
  end
  else
    Value := '0';

  Checked := (Value = '1') or SameText(Value, 'true') or SameText(Value, 'T');

  Result := '<input type="checkbox" ';
  if Checked then Result := Result + 'checked ';
  Result := Result + 'disabled>';
end;

function THTMLGrid.RenderCellIconText(RowIndex: Integer; Col: TGridColumn): string;
begin
  Result := '';
  if Col.IconClass <> '' then
    Result := '<i class="' + Col.IconClass + '"></i> ';
  Result := Result + RenderCellText(RowIndex, Col);
end;

function THTMLGrid.RenderCellLink(RowIndex: Integer; Col: TGridColumn): string;
var
  Link: string;
  F: TField;
begin
  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.LinkField);
    if F <> nil then
      Link := F.AsString
    else
      Link := '#';
  end
  else
    Link := '#';

  Result := '<a href="' + Link + '">' + RenderCellText(RowIndex, Col) + '</a>';
end;

function THTMLGrid.RenderCellFormatted(RowIndex: Integer; Col: TGridColumn): string;
var
  V: Variant;
  F: TField;
begin
  if (FDataSet <> nil) and FDataSet.Active then
  begin
    F := FDataSet.FindField(Col.FieldName);
    if F <> nil then
    begin
      V := F.Value;
      if VarIsNull(V) then
        Result := ''
      else
        Result := FormatCurr(Col.FormatMask, V);
    end
    else
      Result := '';
  end
  else
    Result := ValorFicticio(RowIndex, Col.Index);
end;

function THTMLGrid.TabelaGerada(UseDummyData: Boolean = False): string;
var
  SL: TStringList;
  r, c: Integer;
  CellHTML: string;
  EffectiveGridName: string;
begin
  if FColumns.Count = 0 then
    GerarColunasFicticias;

  EffectiveGridName := FGridName;
  if EffectiveGridName = '' then
    EffectiveGridName := Name;
  if EffectiveGridName = '' then
    EffectiveGridName := 'HtmlGrid';

  if (not UseDummyData) and (FDataSet <> nil) and (FDataSet.Active) then
  begin
    SL := TStringList.Create;
    try
      if FUseBootstrapTheme and (FBootstrapTableClass <> '') then
        SL.Add('<table id="' + EffectiveGridName + '" class="' + FBootstrapTableClass + '" style="' + BuildTableStyle + '">')
      else
        SL.Add('<table id="' + EffectiveGridName + '" style="' + BuildTableStyle + '">');

      SL.Add('<thead><tr>');
      for c := 0 to Columns.Count - 1 do
        if Columns[c].Visible then
          SL.Add('<th style="' + BuildHeaderStyle + 'width:' + IntToStr(Columns[c].Width) + 'px;text-align:' + IfThen(Columns[c].Align = taLeftJustify, 'left', IfThen(Columns[c].Align = taRightJustify, 'right', 'center')) + ';">' + Columns[c].Title + '</th>');
      SL.Add('</tr></thead>');

      SL.Add('<tbody>');
      FDataSet.First;
      r := 0;
      while not FDataSet.EOF do
      begin
        SL.Add('<tr style="' + BuildRowStyle(r) + '">');
        for c := 0 to Columns.Count - 1 do
        begin
          if not Columns[c].Visible then Continue;

          case Columns[c].ColumnType of
            ctText:      CellHTML := RenderCellText(r, Columns[c]);
            ctBadge:     CellHTML := RenderCellBadge(r, Columns[c]);
            ctButton:    CellHTML := RenderCellButton(r, Columns[c]);
            ctCheckBox:  CellHTML := RenderCellCheckBox(r, Columns[c]);
            ctIconText:  CellHTML := RenderCellIconText(r, Columns[c]);
            ctLink:      CellHTML := RenderCellLink(r, Columns[c]);
            ctFormatted: CellHTML := RenderCellFormatted(r, Columns[c]);
            ctDropdown:  CellHTML := RenderCellDropdown(r, Columns[c]);
            ctMultiElement: CellHTML := RenderMultiElement(r, Columns[c]);
          else
            CellHTML := RenderCellText(r, Columns[c]);
          end;
          SL.Add('<td class="' + Columns[c].CssClass + '" style="' + BuildCellStyle + 'text-align:' + IfThen(Columns[c].Align = taLeftJustify, 'left', IfThen(Columns[c].Align = taRightJustify, 'right', 'center')) + ';">' + CellHTML + '</td>');
        end;
        SL.Add('</tr>');
        Inc(r);
        FDataSet.Next;
      end;
      SL.Add('</tbody>');
      SL.Add('</table>');
      
      if FResponsive then
        SL.Add('</div>');

      Result := SL.Text;
    finally
      SL.Free;
    end;
  end
  else
  begin
    // Render com dados fictícios
    SL := TStringList.Create;
    try
      if FResponsive then
        SL.Add('<div class="table-responsive">');

      if FUseBootstrapTheme and (FBootstrapTableClass <> '') then
        SL.Add('<table id="' + EffectiveGridName + '" class="' + FBootstrapTableClass + '" style="' + BuildTableStyle + '">')
      else
        SL.Add('<table id="' + EffectiveGridName + '" style="' + BuildTableStyle + '">');

      SL.Add('<thead><tr>');
      for c := 0 to Columns.Count - 1 do
        if Columns[c].Visible then
          SL.Add('<th style="' + BuildHeaderStyle + 'width:' + IntToStr(Columns[c].Width) + 'px;text-align:' + IfThen(Columns[c].Align = taLeftJustify, 'left', IfThen(Columns[c].Align = taRightJustify, 'right', 'center')) + ';">' + Columns[c].Title + '</th>');
      SL.Add('</tr></thead>');

      SL.Add('<tbody>');
      for r := 0 to 9 do // Mostrar 10 linhas no preview fictício
      begin
        SL.Add('<tr style="' + BuildRowStyle(r) + '">');
        for c := 0 to Columns.Count - 1 do
        begin
          if not Columns[c].Visible then Continue;
          
          case Columns[c].ColumnType of
            ctText:      CellHTML := ValorFicticio(r, c);
            ctBadge:     CellHTML := RenderCellBadge(r, Columns[c]);
            ctButton:    CellHTML := RenderCellButton(r, Columns[c]);
            ctCheckBox:  CellHTML := RenderCellCheckBox(r, Columns[c]);
            ctIconText:  CellHTML := RenderCellIconText(r, Columns[c]);
            ctLink:      CellHTML := RenderCellLink(r, Columns[c]);
            ctFormatted: CellHTML := RenderCellFormatted(r, Columns[c]);
            ctDropdown:  CellHTML := RenderCellDropdown(r, Columns[c]);
            ctMultiElement: CellHTML := RenderMultiElement(r, Columns[c]);
          else
            CellHTML := ValorFicticio(r, c);
          end;
          SL.Add('<td class="' + Columns[c].CssClass + '" style="' + BuildCellStyle + 'text-align:' + IfThen(Columns[c].Align = taLeftJustify, 'left', IfThen(Columns[c].Align = taRightJustify, 'right', 'center')) + ';">' + CellHTML + '</td>');
        end;
        SL.Add('</tr>');
      end;
      SL.Add('</tbody>');
      SL.Add('</table>');

      if FResponsive then
        SL.Add('</div>');

      Result := SL.Text;
    finally
      SL.Free;
    end;
  end;
end;

procedure THTMLGrid.ClearColumns;
begin
  FColumns.Clear;
end;

procedure THTMLGrid.RefreshColumns;
begin
  FColumns.Clear;
  AutoBuildColumns;
end;

procedure THTMLGrid.GerarColunasFicticias;
var
  C: TGridColumn;
begin
  FColumns.Clear;

  C := FColumns.Add;
  C.Title := 'Nome';
  C.FieldName := 'Nome';

  C := FColumns.Add;
  C.Title := 'Idade';
  C.FieldName := 'Idade';

  C := FColumns.Add;
  C.Title := 'Cidade';
  C.FieldName := 'Cidade';
end;

procedure THTMLGrid.ShowBrowserPreview;
var
  TempFile: string;
  SL: TStringList;
  EffectiveGridName: string;
begin
  EffectiveGridName := FGridName;
  if EffectiveGridName = '' then
    EffectiveGridName := Name;
  if EffectiveGridName = '' then
    EffectiveGridName := 'HtmlGrid';

  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'grid_preview_' + EffectiveGridName + '.html';
  SL := TStringList.Create;
  try
    SL.Add('<!DOCTYPE html>');
    SL.Add('<html lang="pt-br">');
    SL.Add('<head>');
    SL.Add('  <meta charset="utf-8">');
    SL.Add('  <meta name="viewport" content="width=device-width, initial-scale=1">');
    SL.Add('  <title>Preview HtmlGrid - ' + EffectiveGridName + '</title>');
    if FUseBootstrapTheme then
    begin
      SL.Add('  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">');
      SL.Add('  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>');
      SL.Add('  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">');
    end;
    SL.Add('  <style>');
    SL.Add('    body { padding: 30px; background-color: #f4f7f6; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; }');
    SL.Add('    .preview-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }');
    SL.Add('    .header-info { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }');
    SL.Add('    .badge-preview { font-size: 0.8rem; padding: 0.4em 0.8em; }');
    SL.Add('    h2 { color: #2c3e50; font-weight: 600; margin: 0; }');
    SL.Add('  </style>');
    SL.Add('</head>');
    SL.Add('<body>');
    SL.Add('  <div class="container-fluid">');
    SL.Add('    <div class="preview-card">');
    SL.Add('      <div class="header-info">');
    SL.Add('        <div>');
    SL.Add('          <h2><i class="fas fa-table me-2 text-primary"></i>' + EffectiveGridName + '</h2>');
    SL.Add('          <p class="text-muted mb-0">Visualização com dados fictícios para ajuste de layout</p>');
    SL.Add('        </div>');
    SL.Add('        <span class="badge bg-info text-dark">D2Bridge Component</span>');
    SL.Add('      </div>');
    SL.Add('      <div class="table-responsive">');
    SL.Add(TabelaGerada(True)); // Sempre usa dados fictícios para o preview do browser
    SL.Add('      </div>');
    SL.Add('      <div class="mt-4 pt-3 border-top d-flex justify-content-between text-muted small">');
    SL.Add('        <span>Componente: THTMLGrid</span>');
    SL.Add('        <span>Gerado em: ' + DateTimeToStr(Now) + '</span>');
    SL.Add('      </div>');
    SL.Add('    </div>');
    SL.Add('  </div>');
    SL.Add('</body>');
    SL.Add('</html>');
    SL.SaveToFile(TempFile);
    OpenURL(TempFile);
  finally
    SL.Free;
  end;
end;

procedure THTMLGrid.ShowPreview;
var
  F: TfrmHTMLGridPreview;
begin
  F := TfrmHTMLGridPreview.Create(nil);
  try
    F.LoadHTML('<pre>' + StringReplace(TabelaGerada, '<', '&lt;', [rfReplaceAll]) + '</pre>');
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('VSComponents', [THTMLGrid]);
end;

end.

