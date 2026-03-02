MANUAL TÉCNICO – THTMLGrid (Lazarus + D2Bridge)
markdown
# MANUAL TÉCNICO – THTMLGrid
Componente gerador de tabelas HTML responsivas para Lazarus + D2Bridge.

Este manual explica **como o componente funciona internamente**, como configurar cada propriedade, como usar cada tipo de coluna, como integrar com D2Bridge, como resolver erros comuns e como aplicar temas e estilos.

---

# 1. Objetivo do componente

O **THTMLGrid** foi criado para:

- Gerar tabelas HTML completas a partir de um `TDataSet`
- Ser totalmente configurável pelo Object Inspector
- Evitar HTML manual
- Integrar com callbacks do D2Bridge
- Ser responsivo (Bootstrap 5)
- Permitir badges, botões, ícones, links, formatação e temas
- Ser simples de usar, mesmo para iniciantes

O componente **não renderiza nada** — ele apenas gera HTML como string.

---

# 2. Como o componente funciona internamente

O fluxo interno é:

1. O DataSet é lido (campos, valores, tipos)
2. As colunas configuradas são processadas
3. O componente monta:
   - `<table>`
   - `<thead>`
   - `<tbody>`
   - `<tr>` e `<td>`
4. Aplica estilos (CSS inline)
5. Aplica classes Bootstrap
6. Gera HTML final
7. Retorna via `TabelaGerada`

O componente **não depende de navegador** e **não depende do D2Bridge**.

---

# 3. Instalação

1. Crie um pacote no Lazarus.
2. Adicione `uHTMLGrid.pas`.
3. Em Required Packages, adicione:
   - `LCL`
   - `LazUtils`
4. Compile.
5. Instale o pacote.

O componente aparecerá em:

Vitor Components → THTMLGrid

Código

---

# 4. Propriedades principais (explicadas com exemplos)

## 4.1 DataSet
Dataset que será lido.

Exemplo:
DataSet = ZQuery1

Código

## 4.2 GridName
Nome lógico usado nos callbacks do D2Bridge.

Exemplo:
GridName = 'GridProfissionais'

Código

Gera:
{{CallBack=GridProfissionais.Edit(ID=10)}}

Código

## 4.3 AutoGenerateColumns
Se **True**, o componente cria colunas automaticamente **somente se Columns estiver vazio**.

Exemplo:
AutoGenerateColumns = True

Código

## 4.4 Columns
Lista de colunas configuráveis.

Se você adicionar 1 coluna manualmente, o AutoGenerateColumns **não gera mais nada**.

---

# 5. Propriedades visuais (CSS inline)

Todas geram CSS inline automaticamente.

## 5.1 FontName
Fonte usada na tabela.

Exemplo:
FontName = 'Segoe UI'

Código

## 5.2 FontSize
Tamanho da fonte.

Exemplo:
FontSize = 14

Código

## 5.3 FontColor
Cor do texto.

Exemplo:
FontColor = clBlack

Código

## 5.4 HeaderBackground
Cor do cabeçalho.

Exemplo:
HeaderBackground = $00444444

Código

## 5.5 RowBackground / RowAlternateBackground
Cor das linhas.

Exemplo:
RowBackground = clWhite
RowAlternateBackground = $00F7F7F7

Código

## 5.6 BorderColor / BorderWidth
Borda da tabela.

Exemplo:
BorderColor = $00CCCCCC
BorderWidth = 1

Código

## 5.7 RoundedCorners
Arredonda bordas.

RoundedCorners = True

Código

## 5.8 HoverHighlight
Destaca linha ao passar o mouse.

HoverHighlight = True

Código

## 5.9 StripedRows
Linhas alternadas.

StripedRows = True

Código

## 5.10 BackgroundImage
Imagem de fundo da tabela.

BackgroundImage = 'C:\imagens\fundo.png'
BackgroundMode = bmCover

Código

---

# 6. Temas (Theme)

O componente possui temas prontos:

- `gtDefault`
- `gtLight`
- `gtDark`
- `gtCorporate`
- `gtMinimal`
- `gtColorful`

## Como usar:

Theme = gtDark

Código

## Importante:
Se você alterar manualmente alguma cor (ex.: HeaderBackground), ela **sobrescreve o tema**.

---

# 7. Configuração de colunas (TGridColumn)

Cada coluna possui:

| Propriedade | Explicação |
|------------|------------|
| FieldName | Nome do campo do DataSet |
| Title | Texto do cabeçalho |
| ColumnType | Tipo da coluna |
| Width | Largura em pixels |
| Align | Alinhamento |
| Visible | Mostrar/ocultar |
| BadgeRules | Regras de badge |
| Buttons | Botões da coluna |
| IconClass | Ícone (FontAwesome) |
| TooltipField | Campo usado como tooltip |
| LinkField | Campo usado como link |
| FormatMask | Máscara de formatação |

---

# 8. Tipos de coluna (explicados com exemplos)

## 8.1 ctText
Texto simples.

ColumnType = ctText

Código

## 8.2 ctBadge
Badge Bootstrap.

ColumnType = ctBadge

Código

## 8.3 ctButton
Um ou vários botões.

ColumnType = ctButton

Código

## 8.4 ctCheckBox
Checkbox desabilitado.

ColumnType = ctCheckBox

Código

## 8.5 ctIconText
Ícone + texto.

IconClass = 'fa fa-user'

Código

## 8.6 ctLink
Transforma o texto em link.

LinkField = 'URL'

Código

## 8.7 ctFormatted
Formata datas e números.

FormatMask = '#,##0.00'

Código

---

# 9. Badges (TBadgeRule)

Badges permitem trocar texto e cor conforme o valor do campo.

Exemplo:

```pascal
with HTMLGrid1.Columns[2].BadgeRules.Add do
begin
  MatchValue := '1';
  CssClass := 'bg-success';
  Text := 'Ativo';
end;
10. Botões (TGridButtonItem)
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

Código
<button onclick="{{CallBack=GridProfissionais.Edit(ID=10)}}">...</button>
11. Boolean com texto personalizado
Existem 3 formas:

11.1 ctBadge
Código
1 → Ativo
0 → Inativo
11.2 ctFormatted
Código
FormatMask = 'Ativo;Inativo'
11.3 ctCheckBox
Mostra checkbox marcado.

12. AutoGenerateColumns
Como funciona:
Ele só gera colunas automaticamente se:

AutoGenerateColumns = True

Columns.Count = 0

DataSet.Active = True no momento da geração

Exemplo correto:
pascal
ZQuery1.Open;
HTML := HTMLGrid1.TabelaGerada;
Importante:
Se você adicionar qualquer coluna manualmente, ele não gera mais nada.

13. Exemplos completos
13.1 Tabela simples
pascal
ZProfissionais.Open;
HTML := HTMLGrid1.TabelaGerada;
HTMLElement('tabela').InnerHTML := HTML;
13.2 Badge de status
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
13.3 Botões de ação
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
14. Erros comuns e soluções
❗ AutoGenerateColumns não funciona
Causa: Columns.Count > 0
Solução: Limpe todas as colunas.

❗ Boolean aparece como True/False
Use:

ctBadge

ctFormatted

ctCheckBox

❗ Badge não muda de cor
Verifique:

MatchValue correto

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
15. Boas práticas
Sempre defina GridName

Use ctFormatted para datas e valores

Use ctBadge para status

Use ctButton para ações

Use ctIconText para colunas visuais

Use temas para padronizar o sistema

Use AutoGenerateColumns para prototipagem rápida