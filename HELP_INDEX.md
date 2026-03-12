# 📖 Guia de Consulta Rápida - THTMLGrid

Este guia serve como uma referência rápida para as principais funcionalidades e configurações do componente **THTMLGrid**.

---

## 📑 Índice de Referência
1. [Configuração de Colunas (ColumnType)](#1-configuração-de-colunas-columntype)
2. [Sintaxe de Callbacks](#2-sintaxe-de-callbacks)
3. [Máscaras de Formatação (FormatMask)](#3-máscaras-de-formatação-formatmask)
4. [Classes CSS Bootstrap Úteis](#4-classes-css-bootstrap-úteis)
5. [Gerenciamento de Dados Fictícios](#5-gerenciamento-de-dados-fictícios)

---

## 1. Configuração de Colunas (ColumnType)

| Tipo | Uso Principal | Configuração Chave |
| :--- | :--- | :--- |
| **`ctText`** | Exibir dados brutos | `FieldName` |
| **`ctBadge`** | Status, Categorias | `BadgeRules` (MatchValue, CssClass, Text) |
| **`ctButton`** | Ações de linha | `Buttons` (ButtonID, IconClass, CssClass) |
| **`ctDropdown`**| Menus de contexto | `DropdownOptions` (Text, Value, IconClass) |
| **`ctFormatted`**| Moedas, Datas | `FormatMask` |
| **`ctMulti`** | Foto + Nome + Badge | `ShowText`, `BadgeRules`, `Buttons` |

---

## 2. Sintaxe de Callbacks

O componente gera automaticamente:
`{{CallBack=GridName.ID_ACAO(ParamField=Valor)}}`

**No Lazarus (Evento OnCallBack do Form):**
```pascal
if SameText(CallBackName, 'MeuGrid.Editar') then
  ID := EventParams.Values['ID']; // Pega o valor do parâmetro
```

---

## 3. Máscaras de Formatação (FormatMask)

- **Moeda**: `#,##0.00` ou `R$ #,##0.00`
- **Data**: `dd/mm/yyyy`
- **Data/Hora**: `dd/mm/yyyy hh:nn`
- **Boolean Customizado**: `Ativo;Inativo` (Exibe o primeiro para True e o segundo para False)

---

## 4. Classes CSS Bootstrap Úteis

Use na propriedade **`CssClass`** das colunas ou botões:

### Cores de Texto/Fundo
- `text-primary`, `text-success`, `text-danger`, `text-warning`
- `bg-primary`, `bg-light`, `bg-dark`, `bg-transparent`

### Estilo de Fonte
- `fw-bold` (Negrito)
- `fst-italic` (Itálico)
- `text-uppercase` (Maiúsculas)

### Botões
- `btn-primary`, `btn-outline-secondary`, `btn-sm` (Pequeno)

---

## 5. Gerenciamento de Dados Fictícios

Para que o **Preview no Navegador** gere dados realistas, use nomes de campos sugestivos no seu `TDataSet` ou na propriedade `FieldName`:

- **Nomes**: `nome`, `cliente`, `usuario`, `contato`
- **Datas**: `data`, `vencimento`, `cadastro`
- **Valores**: `valor`, `preco`, `total`, `subtotal`
- **Localização**: `cidade`, `local`, `endereco`
- **Identificação**: `id`, `codigo`, `pk`

---
*Dica: Clique com o botão direito no componente no Lazarus para acessar o Preview e Exportação JSON.*
