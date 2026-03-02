📘 THTMLGrid – Componente HTML Table Builder para Lazarus / D2Bridge
THTMLGrid é um componente visual para Lazarus que gera tabelas HTML completas, responsivas e estilizadas com Bootstrap 5, totalmente configuráveis via Object Inspector.
Ideal para aplicações web construídas com Lazarus + D2Bridge, permitindo criar tabelas ricas sem escrever HTML manualmente.

📑 Sumário
Introdução

Instalação

Tutorial Passo a Passo

Propriedades Principais

Configuração de Colunas

Tipos de Coluna

Badges

Botões e Callbacks

Boolean com Texto Personalizado

Temas e Estilos Visuais

AutoGenerateColumns

Exemplos Completos

Troubleshooting (Erros Comuns)

Boas Práticas

🧩 Introdução
THTMLGrid transforma qualquer TDataSet em uma tabela HTML moderna, responsiva e personalizável.
Ele foi projetado para:

Evitar HTML manual

Padronizar tabelas no sistema

Integrar com callbacks do D2Bridge

Ser configurado visualmente no Lazarus

Ser responsivo (celular, tablet, desktop)

Usar Bootstrap 5 automaticamente

O componente não interfere no D2Bridge — ele apenas gera HTML.

⚙️ Instalação
Abra o Lazarus.

Crie um novo pacote:
Package → New Package

Adicione a unit uHTMLGrid.pas ao pacote.

Em Required Packages, adicione:

LCL

LazUtils

Compile o pacote.

Instale:
Package → Install

O componente aparecerá na paleta:

Código
Vitor Components → THTMLGrid
🚀 Tutorial Passo a Passo
1) Arraste o componente para o form
No Object Inspector:

Código
DataSet = ZQuery1
GridName = GridProfissionais
AutoGenerateColumns = True
2) Abra o DataSet antes de gerar o HTML
pascal
ZQuery1.Open;
3) Gere o HTML
pascal
HTML := HTMLGrid1.TabelaGerada;
4) Envie para o D2Bridge
pascal
HTMLElement('tabela').InnerHTML := HTML;
5) Trate callbacks no form
pascal
procedure TFrmLocProfissionais.CallBack(const CallBackName: string; EventParams: TStrings);
begin
  if SameText(CallBackName, 'GridProfissionais.Edit') then
    ShowMessage('Editar ID: ' + EventParams.Values['ID']);
end;
🧱 Propriedades Principais
Propriedade	Descrição
DataSet	Fonte de dados
GridName	Nome lógico usado nos callbacks
Columns	Lista de colunas configuráveis
AutoGenerateColumns	Gera colunas automaticamente
UseBootstrapTheme	Usa classes Bootstrap
BootstrapTableClass	Classes CSS da tabela
Theme	Tema visual
BackgroundImage	Imagem de fundo
FontName, FontSize, FontColor	Estilo de fonte
BorderColor, BorderWidth	Bordas
StripedRows, HoverHighlight	Estilos de linha
📊 Configuração de Colunas
Cada coluna (TGridColumn) possui:

FieldName

Title

ColumnType

Width

Align

Visible

BadgeRules

Buttons

IconClass

TooltipField

LinkField

FormatMask

🧱 Tipos de Coluna
Tipo	Descrição
ctText	Texto simples
ctBadge	Badge Bootstrap
ctButton	Um ou vários botões
ctCheckBox	Checkbox desabilitado
ctIconText	Ícone + texto
ctLink	Link clicável
ctFormatted	Formatação de datas/números
🏷️ Badges
Badges são configurados por regras:

pascal
with HTMLGrid1.Columns[2].BadgeRules.Add do
begin
  MatchValue := '1';
  CssClass := 'bg-success';
  Text := 'Ativo';
end;
HTML gerado:

html
<span class="badge bg-success rounded-pill p-2">Ativo</span>
🔘 Botões e Callbacks
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
🔄 Boolean com Texto Personalizado
Existem 3 formas de trocar o texto de campos booleanos:

✔️ 1) Usar ctBadge (recomendado)
pascal
MatchValue = '1' → Text = 'Ativo'
MatchValue = '0' → Text = 'Inativo'
✔️ 2) Usar ctFormatted com máscara
pascal
FormatMask = 'Ativo;Inativo'
✔️ 3) Usar ctBooleanText (se habilitado)
pascal
TrueText = 'Sim'
FalseText = 'Não'
🎨 Temas e Estilos Visuais
Temas prontos:

Default

Light

Dark

Corporate

Minimal

Colorful

Propriedades visuais:

Fonte

Tamanho

Cor

Fundo

Imagem de fundo

Bordas

Hover

Linhas alternadas

Compact mode

Tudo gerado como CSS inline.

⚡ AutoGenerateColumns
Quando AutoGenerateColumns = True:

Lê os fields do DataSet

Cria colunas automaticamente

Define tipo básico (text / formatted)

Não cria badges, botões ou ícones automaticamente.  
Você controla tudo.

Importante:
AutoGenerateColumns só funciona se Columns.Count = 0.

🧪 Exemplos Completos
Exemplo 1 — Tabela simples
pascal
HTMLGrid1.DataSet := ZProfissionais;
HTMLGrid1.GridName := 'GridProfissionais';

HTML := HTMLGrid1.TabelaGerada;
HTMLElement('tabela').InnerHTML := HTML;
Exemplo 2 — Coluna com badge
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
Exemplo 3 — Coluna com múltiplos botões
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
🛠️ Troubleshooting (Erros Comuns)
❗ AutoGenerateColumns não funciona
Causa: Columns.Count > 0
Solução: Limpe todas as colunas antes de gerar.

❗ Boolean aparece como True/False
Use uma das opções:

ctBadge

ctFormatted com máscara

ctBooleanText

❗ Badge não muda de cor
Verifique:

MatchValue corresponde ao valor real do campo

CssClass existe no Bootstrap

❗ Callback não dispara
Verifique:

GridName está correto

ButtonID está correto

ParamField existe no DataSet

CallBack do form está implementado

❗ Bootstrap não aplica estilo
Verifique:

Bootstrap 5 está carregado no HTML principal

Não há conflito de CSS externo

❗ Erro “Graphics not found”
Adicione dependência:

Código
LCL
🧭 Boas Práticas
Sempre defina GridName

Use ctFormatted para datas e valores

Use ctBadge para status

Use ctButton para ações

Use ctIconText para colunas visuais

Use temas para padronizar o sistema

Use AutoGenerateColumns para prototipagem rápida
