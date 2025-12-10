# Sistema de Memória com Display 7 Segmentos - VHDL

![VHDL](https://img.shields.io/badge/VHDL-Hardware-blue)
![FPGA](https://img.shields.io/badge/FPGA-Basys3-green)
![Xilinx](https://img.shields.io/badge/Xilinx-Vivado-red)
![License](https://img.shields.io/badge/license-MIT-orange)

## 📋 Descrição

Sistema de memória avançado implementado em VHDL para FPGA Xilinx Basys3. O projeto estende o conceito de memória endereçável com visualização através de display de 7 segmentos multiplexado, incluindo conversão binário-BCD para exibição decimal dos valores armazenados.

## 🎥 Demonstração

[Vídeo de demonstração na Basys3](https://www.youtube.com/shorts/gwM9WC6nlcg)

## 🏗️ Arquitetura

O sistema integra os seguintes módulos especializados:

### Módulos Principais

- **`system_controller.vhd`**: Controlador principal que integra todos os componentes
- **`data_storage_unit.vhd`**: Unidade de armazenamento de dados (4 posições x 8 bits)
- **`memory_cell_8bit.vhd`**: Célula de memória individual de 8 bits
- **`address_decoder.vhd`**: Decodificador de endereços 1-para-2
- **`debounced_toggle_ff.vhd`**: Flip-flop toggle com debounce para controle de escrita/leitura
- **`output_multiplexer.vhd`**: Multiplexador de saída para seleção de dados
- **`binary_to_bcd_conv.vhd`**: Conversor binário para BCD (3 dígitos)
- **`display_manager.vhd`**: Gerenciador de display 7 segmentos multiplexado
- **`projeto.xdc`**: Arquivo de constraints (pinagem Basys3)

### Diagrama de Blocos

```
┌───────────────────────────────────────────────────────────────┐
│                    SYSTEM CONTROLLER                          │
│                                                               │
│  ┌─────────────┐                                              │
│  │ Debounced   │                                              │
│  │ Toggle FF   │ → write_enable                               │
│  └─────────────┘                                              │
│                                                               │
│  ┌─────────────┐      ┌──────────────────┐                    │
│  │  Address    │      │  Data Storage    │                    │
│  │  Decoder    │→sel →│   Unit (4x8b)    │                    │
│  │  (1-to-2)   │      │                  │                    │
│  └─────────────┘      └──────────────────┘                    │
│       ↑                        ↓                              │
│  addr[1:0]              ┌─────────────┐                       │
│                         │   Output    │                       │
│  data_in[7:0] ────────→ │     MUX     │                       │
│                         └─────────────┘                       │
│                                ↓                              │
│                         ┌─────────────┐                       │
│                         │  Binary to  │                       │
│                         │  BCD Conv   │                       │
│                         └─────────────┘                       │
│                                ↓                              │
│                         ┌─────────────┐                       │
│                         │   Display   │ → 7-Seg Display       │
│                         │   Manager   │   (4 dígitos)         │
│                         └─────────────┘                       │
│                                                               │
│  LEDs ← led_data_out[7:0], led_addr_out[1:0]                  │
└───────────────────────────────────────────────────────────────┘
```

## 🔌 Pinagem (Basys3)

### Clock e Controle
| Sinal | Pino | Descrição |
|-------|------|-----------|
| `clk_in` | F14 | Clock de 100 MHz da placa |
| `rst_in` | J2 | Botão de reset (ativo baixo) |
| `write_enable` | J5 | Botão toggle escrita/leitura (ativo baixo) |

### Entradas de Endereço
| Sinal | Pino | Descrição |
|-------|------|-----------|
| `addr_row` | V2 | Switch - Bit de linha do endereço |
| `addr_col` | U2 | Switch - Bit de coluna do endereço |

### Barramento de Dados (8 bits)
| Sinal | Pinos | Descrição |
|-------|-------|-----------|
| `data_in[7:0]` | N2, P1, P2, R1, R2, T1, T2, U1 | Switches para entrada de dados |

### Display 7 Segmentos
| Sinal | Pinos | Descrição |
|-------|-------|-----------|
| `segment_out[6:0]` | D1, H4, B1, C2, D2, J3, F4 | Segmentos a-g |
| `anode_select_out[3:0]` | E4, F3, J4, H3 | Seleção de dígito (multiplexação) |

### LEDs de Status
| Sinal | Pinos | Descrição |
|-------|-------|-----------|
| `led_data_out[7:0]` | M3, L3, A16, K3, C15, H1, A15, B15 | Espelha o valor armazenado |
| `led_addr_out[1:0]` | G1, G2 | Indica o endereço selecionado |

## 🚀 Como Usar

### Pré-requisitos
- Xilinx Vivado (versão 2018.2 ou superior)
- Placa FPGA Digilent Basys3
- Cabo USB para programação

### Compilação no Vivado

1. **Criar novo projeto:**
   ```
   File → Project → New
   ```

2. **Adicionar arquivos fonte:**
   - Adicione todos os arquivos `.vhd` da pasta `src/`
   - Adicione o arquivo `projeto.xdc` da pasta `hardware/`

3. **Definir top-level:**
   - Clique com botão direito em `system_controller.vhd`
   - Selecione "Set as Top"

4. **Compilar:**
   ```
   Flow → Run Synthesis
   Flow → Run Implementation
   Flow → Generate Bitstream
   ```

5. **Programar a FPGA:**
   ```
   Flow → Open Hardware Manager → Auto Connect
   Program Device → Selecione o bitstream gerado
   ```

### Operação do Sistema

1. **Reset**: Pressione o botão J2 para resetar (zera toda a memória)

2. **Selecionar Endereço**: Configure os switches de endereço
   - `addr_row` (V2) + `addr_col` (U2)
   - 00, 01, 10, 11 = Posições 0, 1, 2, 3

3. **Modo Escrita**: 
   - Pressione J5 para entrar em modo escrita (LED indicador)
   - Configure o valor nos switches `data_in[7:0]`
   - O valor é escrito automaticamente na posição selecionada

4. **Modo Leitura**:
   - Pressione J5 novamente para alternar para leitura
   - Display 7 segmentos mostra o valor decimal (0-255)
   - LEDs mostram o valor binário

5. **Visualização**:
   - **Display 7-seg**: Valor decimal de 3 dígitos (000-255)
   - **LEDs data**: Representação binária do dado
   - **LEDs addr**: Endereço selecionado

## 📁 Estrutura do Projeto

```
.
├── README.md
├── LICENSE
├── .gitignore
├── src/                                  # Código fonte VHDL
│   ├── system_controller.vhd            # Top-level entity
│   ├── data_storage_unit.vhd
│   ├── memory_cell_8bit.vhd
│   ├── address_decoder.vhd
│   ├── debounced_toggle_ff.vhd
│   ├── output_multiplexer.vhd
│   ├── binary_to_bcd_conv.vhd
│   └── display_manager.vhd
├── hardware/                             # Arquivos de hardware
│   └── projeto.xdc                      # Constraints (pinagem)
└── docs/                                 # Documentação
    ├── setup_guide.md
    └── architecture.md
```

## 🛠️ Tecnologias Utilizadas

- **Linguagem**: VHDL
- **Ferramenta**: Xilinx Vivado
- **Hardware**: Digilent Basys3 (Artix-7 XC7A35T-1CPG236C)
- **Clock**: 100 MHz
- **Display**: 7 segmentos x 4 dígitos (multiplexado)

## 📝 Funcionalidades

✅ Memória de 4 posições x 8 bits  
✅ Endereçamento via switches (2 bits)  
✅ Modo escrita/leitura com debounce  
✅ Conversão binário → BCD automática  
✅ Display 7 segmentos multiplexado (taxa de refresh otimizada)  
✅ Visualização simultânea: display decimal + LEDs binários  
✅ Reset assíncrono  
✅ Clock de 100 MHz (Basys3)  

## 🔍 Diferenciais deste Projeto

Comparado ao projeto anterior (DE0-nano), este sistema inclui:
- **Display 7 segmentos** com multiplexação automática
- **Conversão BCD** para exibição decimal legível
- **Debounce em hardware** para botões mais confiáveis
- **Visualização dupla** (decimal + binário)
- **Plataforma Xilinx** (Vivado vs Quartus)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Enviar pull requests

## 📄 Licença

Este projeto está sob a licença MIT.

## ✍️ Autor

Projeto desenvolvido como parte da disciplina de Sistemas Digitais.

---

⭐ Se este projeto foi útil para você, considere dar uma estrela!
