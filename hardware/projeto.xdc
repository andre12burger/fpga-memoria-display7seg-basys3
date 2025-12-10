# --- Clock ---
#create_clock -period 10.000 -name gclk [get_ports clk_in]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk_in}]

# --- Configuração ---
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# --- Botões de Controle ---
# RESET (Botão J2 - Ativo Baixo)
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst_in}]
# ESCRITA (Botão J5 - Ativo Baixo)
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {write_enable}]

# --- Switches de Endereço (Memória) ---
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {addr_row}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {addr_col}]


# --- Switches de Dados (data_in) ---
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {data_in[0]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {data_in[1]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {data_in[2]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {data_in[3]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {data_in[4]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {data_in[5]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {data_in[6]}]
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {data_in[7]}]

# --- Display de 7 Segmentos (Saídas) ---

# Seleção de Ânodo (4 bits)
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {anode_select_out[0]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {anode_select_out[1]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {anode_select_out[2]}]
set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS33} [get_ports {anode_select_out[3]}]

# Segmentos (a-g)
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {segment_out[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {segment_out[1]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {segment_out[2]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {segment_out[3]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {segment_out[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {segment_out[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {segment_out[6]}]

# --- LEDs de Status (Espelho dos Switches) ---

# LED[1] (G2) espelha addr_row (Switch U2)
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led_addr_out[1]}]
# LED[2] (F1) espelha addr_col (Switch U1)
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {led_addr_out[0]}]

# LED[4] (E1) espelha data_in[0] (Switch T1)
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led_data_out[0]}]
# LED[5] (E2) espelha data_in[1] (Switch R2)
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {led_data_out[1]}]
# LED[6] (E3) espelha data_in[2] (Switch R1)
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {led_data_out[2]}]
# LED[7] (E5) espelha data_in[3] (Switch P2)
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {led_data_out[3]}]
# LED[8] (E6) espelha data_in[4] (Switch P1)
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {led_data_out[4]}]
# LED[9] (C3) espelha data_in[5] (Switch N2)
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {led_data_out[5]}]
# LED[10] (B2) espelha data_in[6] (Switch N1)
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {led_data_out[6]}]
# LED[11] (A2) espelha data_in[7] (Switch M2)
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {led_data_out[7]}]