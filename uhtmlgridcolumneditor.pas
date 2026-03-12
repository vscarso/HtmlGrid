unit uHTMLGridColumnEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Spin, Dialogs, DB,
  uHTMLGrid;

type
  TfrmHTMLGridColumnEditor = class(TForm)
    lstColumns: TListBox;
    btnAdd: TButton;
    btnDelete: TButton;
    btnUp: TButton;
    btnDown: TButton;

    gbGeneral: TGroupBox;
    lblFieldName: TLabel;
    lblTitle: TLabel;
    lblColumnType: TLabel;
    edtFieldName: TEdit;
    edtTitle: TEdit;
    cbColumnType: TComboBox;

    gbAppearance: TGroupBox;
    lblWidth: TLabel;
    lblAlign: TLabel;
    lblVisible: TLabel;
    lblShowText: TLabel;
    seWidth: TSpinEdit;
    cbAlign: TComboBox;
    chkVisible: TCheckBox;
    chkShowText: TCheckBox;

    gbAdvanced: TGroupBox;
    lblFormatMask: TLabel;
    lblIconClass: TLabel;
    lblTooltipField: TLabel;
    lblLinkField: TLabel;
    edtFormatMask: TEdit;
    edtIconClass: TEdit;
    edtTooltipField: TEdit;
    edtLinkField: TEdit;

    btnEditBadgeRules: TButton;
    btnEditButtons: TButton;
    btnEditDropdown: TButton;

    btnOK: TButton;
    btnCancel: TButton;
    btnSync: TButton;

    procedure FormShow(Sender: TObject);
    procedure lstColumnsClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditBadgeRulesClick(Sender: TObject);
    procedure btnEditButtonsClick(Sender: TObject);
    procedure btnEditDropdownClick(Sender: TObject);
    procedure cbColumnTypeChange(Sender: TObject);
    procedure btnSyncClick(Sender: TObject);
  private
    FOriginal: TGridColumnCollection;
    FTemp: TGridColumnCollection;
    FOwnerGrid: THTMLGrid;

    procedure LoadColumnToUI;
    procedure SaveUIToColumn;
    procedure RefreshList;
    procedure UpdateUIState;
  public
    class function Execute(AOwner: TComponent; AColumns: TGridColumnCollection): Boolean;
  end;

implementation

{$R *.lfm}

uses
  TypInfo;

{ TfrmHTMLGridColumnEditor }

class function TfrmHTMLGridColumnEditor.Execute(AOwner: TComponent; AColumns: TGridColumnCollection): Boolean;
var
  F: TfrmHTMLGridColumnEditor;
begin
  F := TfrmHTMLGridColumnEditor.Create(AOwner);
  try
    if AOwner is THTMLGrid then
      F.FOwnerGrid := THTMLGrid(AOwner);
      
    F.FOriginal := AColumns;
    F.FTemp := TGridColumnCollection.Create(TGridColumn);
    F.FTemp.Assign(AColumns);
    Result := (F.ShowModal = mrOK);
    if Result then
      AColumns.Assign(F.FTemp);
  finally
    F.FTemp.Free; // Correção: Liberar FTemp explicitamente
    F.Free;
  end;
end;

procedure TfrmHTMLGridColumnEditor.FormShow(Sender: TObject);
begin
  cbColumnType.Items.Clear;
  cbColumnType.Items.AddStrings(['ctText','ctBadge','ctButton','ctCheckBox','ctIconText','ctLink','ctFormatted','ctDropdown','ctMultiElement']);
  cbAlign.Items.Clear;
  cbAlign.Items.AddStrings(['Left','Right','Center']);

  btnSync.Visible := (FOwnerGrid <> nil) and (FOwnerGrid.DataSet <> nil);

  RefreshList;
end;

procedure TfrmHTMLGridColumnEditor.btnSyncClick(Sender: TObject);
var
  i: Integer;
  col: TGridColumn;
  fld: TField;
  DS: TDataSet;
begin
  if (FOwnerGrid = nil) or (FOwnerGrid.DataSet = nil) then Exit;
  DS := FOwnerGrid.DataSet;
  
  if MessageDlg('Isso substituirá as colunas atuais pelos campos do DataSet. Continuar?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FTemp.Clear;
    
    // Tenta abrir o dataset se estiver fechado (pode falhar em design time dependendo do componente)
    try
      if not DS.Active then DS.Open;
    except
      // Ignora erro se não conseguir abrir (ex: falta conexão)
    end;

    if DS.FieldCount > 0 then
    begin
      for i := 0 to DS.FieldCount - 1 do
      begin
        fld := DS.Fields[i];
        col := FTemp.Add;
        col.FieldName := fld.FieldName;
        col.Title := fld.DisplayLabel;
        if col.Title = '' then col.Title := fld.FieldName;
        
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
    end
    else
    begin
       // Se não tem fields definidos (ex: SQL dinâmica sem abrir), tenta usar FieldDefs
       try
         DS.FieldDefs.Update;
         for i := 0 to DS.FieldDefs.Count - 1 do
         begin
           col := FTemp.Add;
           col.FieldName := DS.FieldDefs[i].Name;
           col.Title := DS.FieldDefs[i].Name;
           col.ColumnType := ctText;
         end;
       except
       end;
    end;
    
    RefreshList;
  end;
end;

procedure TfrmHTMLGridColumnEditor.UpdateUIState;
var
  CT: TColumnType;
  HasSel: Boolean;
begin
  HasSel := lstColumns.ItemIndex >= 0;
  
  if not HasSel then
  begin
    gbGeneral.Enabled := False;
    gbAppearance.Enabled := False;
    gbAdvanced.Enabled := False;
    btnEditBadgeRules.Enabled := False;
    btnEditButtons.Enabled := False;
    btnEditDropdown.Enabled := False;
    Exit;
  end;

  gbGeneral.Enabled := True;
  gbAppearance.Enabled := True;
  gbAdvanced.Enabled := True;

  CT := TColumnType(cbColumnType.ItemIndex);
  
  btnEditBadgeRules.Enabled := (CT = ctBadge) or (CT = ctMultiElement);
  btnEditButtons.Enabled := (CT = ctButton) or (CT = ctMultiElement);
  btnEditDropdown.Enabled := (CT = ctDropdown);
  
  chkShowText.Enabled := (CT = ctMultiElement);
end;

procedure TfrmHTMLGridColumnEditor.cbColumnTypeChange(Sender: TObject);
begin
  SaveUIToColumn;
  UpdateUIState;
end;

procedure TfrmHTMLGridColumnEditor.RefreshList;
var
  i: Integer;
begin
  lstColumns.Clear;
  for i := 0 to FTemp.Count - 1 do
    lstColumns.Items.Add(FTemp[i].Title);
  
  // Seleciona o primeiro item se houver
  if lstColumns.Count > 0 then
  begin
    lstColumns.ItemIndex := 0;
    LoadColumnToUI;
  end
  else
  begin
    // Se não houver itens, limpa a UI e garante que o estado esteja correto
    LoadColumnToUI; 
  end;
end;

procedure TfrmHTMLGridColumnEditor.lstColumnsClick(Sender: TObject);
begin
  LoadColumnToUI;
  UpdateUIState;
end;

procedure TfrmHTMLGridColumnEditor.LoadColumnToUI;
var
  C: TGridColumn;
begin
  if lstColumns.ItemIndex < 0 then
  begin
    // Se não houver item selecionado, limpa os campos para evitar confusão
    edtFieldName.Clear;
    edtTitle.Clear;
    cbColumnType.ItemIndex := -1;
    seWidth.Value := 0;
    cbAlign.ItemIndex := -1;
    chkVisible.Checked := False;
    chkShowText.Checked := False;
    edtFormatMask.Clear;
    edtIconClass.Clear;
    edtTooltipField.Clear;
    edtLinkField.Clear;
    
    UpdateUIState;
    Exit;
  end;
  C := FTemp[lstColumns.ItemIndex];

  edtFieldName.Text := C.FieldName;
  edtTitle.Text := C.Title;
  cbColumnType.ItemIndex := Ord(C.ColumnType);

  seWidth.Value := C.Width;
  cbAlign.ItemIndex := Ord(C.Align);
  chkVisible.Checked := C.Visible;
  chkShowText.Checked := C.ShowText;

  edtFormatMask.Text := C.FormatMask;
  edtIconClass.Text := C.IconClass;
  edtTooltipField.Text := C.TooltipField;
  edtLinkField.Text := C.LinkField;
  
  UpdateUIState;
end;

procedure TfrmHTMLGridColumnEditor.SaveUIToColumn;
var
  C: TGridColumn;
begin
  if lstColumns.ItemIndex < 0 then Exit;
  C := FTemp[lstColumns.ItemIndex];

  C.FieldName := edtFieldName.Text;
  C.Title := edtTitle.Text;
  C.ColumnType := TColumnType(cbColumnType.ItemIndex);

  C.Width := seWidth.Value;
  C.Align := TAlignment(cbAlign.ItemIndex);
  C.Visible := chkVisible.Checked;
  C.ShowText := chkShowText.Checked;

  C.FormatMask := edtFormatMask.Text;
  C.IconClass := edtIconClass.Text;
  C.TooltipField := edtTooltipField.Text;
  C.LinkField := edtLinkField.Text;
end;

procedure TfrmHTMLGridColumnEditor.btnAddClick(Sender: TObject);
var
  C: TGridColumn;
begin
  C := FTemp.Add;
  C.Title := 'Nova Coluna';
  RefreshList;
end;

procedure TfrmHTMLGridColumnEditor.btnDeleteClick(Sender: TObject);
begin
  if lstColumns.ItemIndex < 0 then Exit;
  FTemp.Delete(lstColumns.ItemIndex);
  RefreshList;
end;

procedure TfrmHTMLGridColumnEditor.btnUpClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lstColumns.ItemIndex;
  if idx > 0 then
  begin
    FTemp.Items[idx].Index := idx - 1;
    RefreshList;
    lstColumns.ItemIndex := idx - 1;
  end;
end;

procedure TfrmHTMLGridColumnEditor.btnDownClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lstColumns.ItemIndex;
  if (idx >= 0) and (idx < FTemp.Count - 1) then
  begin
    FTemp.Items[idx].Index := idx + 1;
    RefreshList;
    lstColumns.ItemIndex := idx + 1;
  end;
end;

procedure TfrmHTMLGridColumnEditor.btnEditBadgeRulesClick(Sender: TObject);
begin
  // TODO: Implementar editor visual para BadgeRules
  ShowMessage('Edição de BadgeRules via Object Inspector (Propriedade BadgeRules)');
end;

procedure TfrmHTMLGridColumnEditor.btnEditButtonsClick(Sender: TObject);
begin
  // TODO: Implementar editor visual para Buttons
  ShowMessage('Edição de Buttons via Object Inspector (Propriedade Buttons)');
end;

procedure TfrmHTMLGridColumnEditor.btnEditDropdownClick(Sender: TObject);
begin
  // TODO: Implementar editor visual para Dropdown
  ShowMessage('Edição de Dropdown via Object Inspector (Propriedade DropdownOptions)');
end;

procedure TfrmHTMLGridColumnEditor.btnOKClick(Sender: TObject);
begin
  SaveUIToColumn;
  ModalResult := mrOK;
end;

procedure TfrmHTMLGridColumnEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

