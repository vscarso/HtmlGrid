README.md
markdown
# THTMLGrid – Componente HTML Table Builder para Lazarus / D2Bridge

O **THTMLGrid** é um componente para Lazarus que gera tabelas HTML completas, responsivas e compatíveis com Bootstrap 5.  
Ele foi criado para facilitar o uso de tabelas em aplicações web feitas com **Lazarus + D2Bridge**, sem precisar escrever HTML manualmente.

O componente é totalmente configurável pelo **Object Inspector**, suporta **badges**, **botões**, **ícones**, **links**, **formatação**, **temas**, **callbacks**, e funciona com qualquer `TDataSet`.

---

## 📌 SUMÁRIO

- [Instalação](#instalação)
- [Como usar (passo a passo)](#como-usar-passo-a-passo)
- [Propriedades principais](#propriedades-principais)
- [Configuração de colunas](#configuração-de-colunas)
- [Tipos de coluna](#tipos-de-coluna)
- [Badges](#badges)
- [Botões e callbacks](#botões-e-callbacks)
- [Boolean com texto personalizado](#boolean-com-texto-personalizado)
- [Temas](#temas)
- [AutoGenerateColumns](#autogeneratecolumns)
- [Exemplos completos](#exemplos-completos)
- [Erros comuns e soluções](#erros-comuns-e-soluções)
- [Boas práticas](#boas-práticas)

---

# Instalação

1. Abra o Lazarus.
2. Crie um novo pacote: **Package → New Package**
3. Adicione o arquivo `uHTMLGrid.pas` ao pacote.
4. Em **Required Packages**, adicione:
   - `LCL`
   - `LazUtils`
5. Compile o pacote.
6. Instale o pacote: **Package → Install**

O componente aparecerá na paleta:

Vitor Components → THTMLGrid

Código

---

# Como usar (passo a passo)

## 1) Coloque o componente no form

No Object Inspector:

DataSet = ZQuery1
GridName = GridProfissionais
AutoGenerateColumns = True

Código

## 2) Abra o DataSet em tempo de execução

```pascal
ZQuery1.Open;
3) Gere o HTML
pascal
HTML := HTMLGrid1.TabelaGerada;
4) Envie para o D2Bridge
pascal
HTMLElement('tabela').InnerHTML := HTML;
5) Trate callbacks no form
pascal
procedure TFrmProfissionais.CallBack(const CallBackName: string; EventParams: TStrings);
begin
  if SameText(CallBackName, 'GridProfissionais.Edit') then
    ShowMessage('Editar ID: ' + EventParams.Values['ID']);
end;
Propriedades principais
DataSet
Dataset que será lido para gerar a tabela.

GridName
Nome lógico usado nos callbacks do D2Bridge.

Exemplo:

Código
GridName = 'GridProfissionais'
Gera:

Código
{{CallBack=GridProfissionais.Edit(ID=10)}}
Columns
Lista de colunas configuráveis.

AutoGenerateColumns
Se True, o componente cria colunas automaticamente somente se Columns estiver vazio.

UseBootstrapTheme
Se True, usa classes Bootstrap como:

Código
table table-striped table-hover table-bordered table-sm
BootstrapTableClass
Permite trocar o estilo da tabela.

Exemplo:

Código
table table-dark table-striped
Propriedades visuais
FontName

FontSize

FontColor

HeaderBackground

HeaderFontColor

RowBackground

RowAlternateBackground

BorderColor

BorderWidth

RoundedCorners

HoverHighlight

StripedRows

CompactMode

BackgroundImage

BackgroundMode

Todas geram CSS inline, ideal para D2Bridge.

Configuração de colunas
Cada coluna possui:

FieldName → nome do campo do DataSet

Title → texto exibido no cabeçalho

ColumnType → tipo da coluna

Width → largura em pixels

Align → alinhamento (left, center, right)

Visible → mostra ou oculta

BadgeRules → regras de badge

Buttons → botões da coluna

IconClass → classe de ícone (FontAwesome)

TooltipField → campo usado como tooltip

LinkField → campo usado como link

FormatMask → máscara de formatação

Tipos de coluna
Tipo	Descrição
ctText	Texto simples
ctBadge	Badge Bootstrap
ctButton	Um ou vários botões
ctCheckBox	Checkbox desabilitado
ctIconText	Ícone + texto
ctLink	Link clicável
ctFormatted	Formatação de datas/números
Badges
Badges permitem trocar texto e cor conforme o valor do campo.

Exemplo:

pascal
with HTMLGrid1.Columns[2].BadgeRules.Add do
begin
  MatchValue := '1';
  CssClass := 'bg-success';
  Text := 'Ativo';
end;

with HTMLGrid1.Columns[2].BadgeRules.Add do
begin
  MatchValue := '0';
  CssClass := 'bg-danger';
  Text := 'Inativo';
end;
Resultado:

Código
Ativo   (verde)
Inativo (vermelho)
Botões e callbacks
Cada coluna pode ter vários botões.

Exemplo:

pascal
with HTMLGrid1.Columns[3].Buttons.Add do
begin
  ButtonID := 'Edit';
  CssClass := 'btn btn-sm btn-primary';
  IconClass := 'fa fa-edit';
  ParamField := 'ID';
end;
HTML gerado:

html
<button onclick="{{CallBack=GridProfissionais.Edit(ID=10)}}">...</button>
Callback:

pascal
if SameText(CallBackName, 'GridProfissionais.Edit') then
  ShowMessage(EventParams.Values['ID']);
Boolean com texto personalizado
Existem 3 formas de trocar o texto de campos booleanos:

1) Usar ctBadge (recomendado)
pascal
MatchValue = '1' → Text = 'Ativo'
MatchValue = '0' → Text = 'Inativo'
2) Usar ctFormatted com máscara
pascal
FormatMask = 'Ativo;Inativo'
3) Usar ctCheckBox
Mostra checkbox marcado ou não.

Temas
O componente possui temas prontos:

gtDefault

gtLight

gtDark

gtCorporate

gtMinimal

gtColorful

Como usar
No Object Inspector:

Código
Theme = gtDark
Importante:
O tema só altera:

Cabeçalho

Linhas

Bordas

Cores padrão

Se você sobrescrever manualmente alguma cor, ela prevalece sobre o tema.

AutoGenerateColumns
Como funciona
Se:

AutoGenerateColumns = True

Columns.Count = 0

DataSet.Active = True

Então o componente cria automaticamente:

Uma coluna para cada campo

Tipo básico (text ou formatted)

Importante:
Ele não cria badges, botões ou ícones automaticamente.

Dica:
Abra o DataSet em runtime, não precisa deixar ativo no design.

Exemplos completos
Exemplo 1 — Tabela simples
pascal
ZProfissionais.Open;
HTML := HTMLGrid1.TabelaGerada;
HTMLElement('tabela').InnerHTML := HTML;
Exemplo 2 — Badge de status
pascal
with HTMLGrid1.Columns.Add do
begin
  FieldName := 'Status';
  Title := 'Status';
  ColumnType := ctBadge;

  with BadgeRules.Add do
  begin
    MatchValue := '1';
    CssClass := 'bg-primary';
    Text := 'Ativo';
  end;

  with BadgeRules.Add do
  begin
    MatchValue := '0';
    CssClass := 'bg-secondary';
    Text := 'Inativo';
  end;
end;
Exemplo 3 — Botões de ação
pascal
with HTMLGrid1.Columns.Add do
begin
  FieldName := 'ID';
  Title := 'Ações';
  ColumnType := ctButton;

  with Buttons.Add do
  begin
    ButtonID := 'Edit';
    CssClass := 'btn btn-sm btn-primary';
    IconClass := 'fa fa-edit';
    ParamField := 'ID';
  end;

  with Buttons.Add do
  begin
    ButtonID := 'Delete';
    CssClass := 'btn btn-sm btn-danger';
    IconClass := 'fa fa-trash';
    ParamField := 'ID';
  end;
end;
Erros comuns e soluções
❗ AutoGenerateColumns não funciona
Causa: Columns.Count > 0
Solução: Limpe todas as colunas antes de gerar.

❗ Boolean aparece como True/False
Use:

ctBadge

ctFormatted com máscara

ctCheckBox

❗ Badge não muda de cor
Verifique:

MatchValue corresponde ao valor real

CssClass existe no Bootstrap

❗ Callback não dispara
Verifique:

GridName correto

ButtonID correto

ParamField existe no DataSet

CallBack implementado no form

❗ Bootstrap não aplica estilo
Verifique:

Bootstrap 5 está carregado no HTML principal

❗ Erro “Graphics not found”
Adicione dependência:

Código
LCL
Boas práticas
Sempre defina GridName

Use ctFormatted para datas e valores

Use ctBadge para status

Use ctButton para ações

Use ctIconText para colunas visuais

Use temas para padronizar o sistema

Use AutoGenerateColumns para prototipagem rápida
