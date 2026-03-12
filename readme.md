# 🚀 THTMLGrid – Gerador de Tabelas HTML para Lazarus & D2Bridge

O **THTMLGrid** é um componente avançado para Lazarus projetado para criar tabelas HTML profissionais, responsivas e totalmente compatíveis com **Bootstrap 5**. Ele foi desenvolvido especificamente para o ecossistema **D2Bridge**, permitindo que desenvolvedores Delphi/Lazarus criem interfaces web ricas sem a necessidade de escrever código HTML ou CSS manualmente.

---

## 📌 Sumário

- [✨ Principais Recursos](#-principais-recursos)
- [📦 Instalação](#-instalação)
- [🛠️ Propriedades do Componente](#️-propriedades-do-componente)
- [📋 Configuração de Colunas](#-configuração-de-colunas)
- [🎨 Temas e Customização](#-temas-e-customização)
- [🔗 Integração com D2Bridge (Callbacks)](#-integração-com-d2bridge-callbacks)
- [👁️ Preview e Prototipagem](#️-preview-e-prototipagem)
- [💾 Persistência (JSON)](#-persistência-json)
- [💡 Exemplos Práticos](#-exemplos-práticos)

---

## ✨ Principais Recursos

- **100% Bootstrap 5**: Gera tabelas com classes nativas e estilos modernos.
- **Responsividade Automática**: Suporte nativo a `table-responsive`.
- **Tipos de Coluna Ricos**: Texto, Badge, Botões, Dropdowns, Checkbox, Links, Formatação e Multi-Elementos.
- **Sistema de Temas**: Troca rápida de visual (Light, Dark, Corporate, Minimal, etc.).
- **Preview no Navegador**: Visualize o grid com dados fictícios inteligentes antes mesmo de rodar a aplicação.
- **Flexbox Layout**: Alinhamento perfeito de ícones e textos usando classes flex.
- **Customização por Coluna**: Propriedade `CssClass` individual para cada coluna.
- **Dados Fictícios Inteligentes**: Preenchimento automático de nomes, datas, valores e emails para testes de layout.

---

## 📦 Instalação

1. No Lazarus, vá em **Package** -> **Open Package File (.lpk)**.
2. Selecione o arquivo `HTMLGrid.lpk`.
3. Clique em **Compile** e depois em **Install**.
4. O componente estará disponível na paleta **VSComponents**.

---

## 🛠️ Propriedades do Componente

### Gerais
- **`DataSet`**: O `TDataSet` (ZQuery, MemTable, etc.) que servirá de fonte de dados.
- **`GridName`**: Nome identificador do grid (usado nos prefixos de callback).
- **`AutoGenerateColumns`**: Se `True`, cria colunas automaticamente baseadas no DataSet ao abrir.
- **`Responsive`**: Envolve a tabela em uma `div` responsiva (Padrão: `True`).

### Estilo e Visual
- **`Theme`**: Seleciona um tema pré-definido (`gtDefault`, `gtLight`, `gtDark`, `gtCorporate`, `gtMinimal`, `gtColorful`).
- **`UseBootstrapTheme`**: Ativa/Desativa o uso de classes Bootstrap.
- **`BootstrapTableClass`**: Classes CSS da tabela (Padrão: `table table-striped table-hover table-bordered table-sm`).
- **`FontName`, `FontSize`, `FontColor`**: Configurações globais de tipografia.
- **`HeaderBackground`, `HeaderFontColor`**: Cores do cabeçalho.
- **`RowBackground`, `RowAlternateBackground`**: Cores das linhas (zebra).

---

## 📋 Configuração de Colunas

Cada item na coleção `Columns` possui:

- **`FieldName`**: Nome do campo no banco de dados.
- **`Title`**: Texto que aparece no cabeçalho.
- **`ColumnType`**: Define como os dados serão renderizados:
  - `ctText`: Texto simples.
  - `ctBadge`: Etiquetas coloridas baseadas em regras (`BadgeRules`).
  - `ctButton`: Um ou mais botões de ação (`Buttons`).
  - `ctDropdown`: Menu de ações suspenso (`DropdownOptions`).
  - `ctLink`: Texto clicável com URL (`LinkField`).
  - `ctFormatted`: Valores formatados via máscara (`FormatMask`).
  - `ctMultiElement`: Combinação de Texto + Badge + Botões na mesma célula.
- **`CssClass`**: Classe CSS personalizada aplicada apenas a esta coluna.
- **`Align`**: Alinhamento horizontal (Esquerda, Centro, Direita).

---

## 🎨 Temas e Customização

Ao alterar a propriedade `Theme`, o componente aplica automaticamente um conjunto de cores harmônicas. Você ainda pode sobrescrever cores individuais após selecionar um tema.

**Dica**: Use a propriedade `CssClass` de uma coluna para aplicar cores específicas do Bootstrap, como `text-primary` ou `fw-bold`.

---

## 🔗 Integração com D2Bridge (Callbacks)

O `THTMLGrid` gera automaticamente a sintaxe de callback do D2Bridge: `{{CallBack=GridName.Acao(Param=Valor)}}`.

### Exemplo de Botão:
1. Configure `GridName` para `GridVendas`.
2. Adicione um botão com `ButtonID` = `Estornar`.
3. Configure `ParamField` = `ID_VENDA`.
4. No Lazarus, trate o evento:

```pascal
procedure TForm1.D2BridgeCallBack(const CallBackName: string; Params: TStrings);
begin
  if SameText(CallBackName, 'GridVendas.Estornar') then
    ShowMessage('Estornando venda ID: ' + Params.Values['ID_VENDA']);
end;
```

---

## 👁️ Preview e Prototipagem

O componente oferece duas formas de visualizar seu trabalho:
1. **Preview HTML**: Mostra o código-fonte gerado.
2. **Preview no Navegador**: Salva um arquivo HTML temporário na pasta do seu projeto e o abre no navegador padrão. 
   - Utiliza **Dados Fictícios Inteligentes** (nomes reais, datas válidas, etc.).
   - Carrega Bootstrap e FontAwesome via CDN para um visual fiel ao real.

---

## 💾 Persistência (JSON)

Você pode salvar e carregar toda a configuração do Grid (colunas, regras, botões, cores) usando arquivos JSON.
- **No IDE**: Clique com o botão direito no componente para **Exportar/Importar**.
- **Via Código**: Use `SaveToFile('config.json')` e `LoadFromFile('config.json')`.

---

## 💡 Exemplos Práticos

### Configurando uma Coluna de Status (Badge)
```pascal
with MyGrid.Columns.Add do
begin
  FieldName := 'ATIVO';
  Title := 'Situação';
  ColumnType := ctBadge;
  with BadgeRules.Add do
  begin
    MatchValue := 'T';
    Text := 'Ativo';
    CssClass := 'bg-success';
  end;
  with BadgeRules.Add do
  begin
    MatchValue := 'F';
    Text := 'Inativo';
    CssClass := 'bg-danger';
  end;
end;
```

---
Gerado por **D2Bridge Assistant** - 2026
