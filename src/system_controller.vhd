library ieee;
use ieee.std_logic_1164.all;

entity system_controller is
    port (
        -- Entradas Globais (dos botões/clock)
        clk_in : in  std_logic;
        rst_in : in  std_logic; -- Botão J2 (Ativo-Alto)
        write_enable : in  std_logic; -- Botão J5 (Ativo-Baixo)

        -- Entradas de Controle (dos switches)
        addr_row : in  std_logic;
        addr_col : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);

        -- Saídas para o Display
        segment_out      : out std_logic_vector(6 downto 0);
        anode_select_out : out std_logic_vector(3 downto 0);
        
        -- Saídas para os LEDs
        led_data_out : out std_logic_vector(7 downto 0);
        led_addr_out : out std_logic_vector(1 downto 0)
    );
end entity system_controller;

architecture Structure of system_controller is

    -- COMPONENTES (Nenhuma mudança aqui)
    component debounced_toggle_ff is
        port (
            clk_in : in  std_logic;
            rst_in : in  std_logic;
            btn_in : in  std_logic;
            q_out  : out std_logic
        );
    end component;
    
    component data_storage_unit is
        port (
            clk_in       : in  std_logic;
            rst_in       : in  std_logic;
            write_enable : in  std_logic;
            addr_row     : in  std_logic;
            addr_col     : in  std_logic;
            data_in      : in  std_logic_vector(7 downto 0);
            data_out     : out std_logic_vector(7 downto 0)
        );
    end component;

    component binary_to_bcd_conv is
        port (
            bin_in : in  std_logic_vector(7 downto 0);
            bcd_out : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component display_manager is
        port (
            clk_in        : in  std_logic;
            rst_in        : in  std_logic;
            bcd_data_in   : in  std_logic_vector(11 downto 0);
            segment_out   : out std_logic_vector(6 downto 0);
            anode_select_out : out std_logic_vector(3 downto 0)
        );
    end component;

    -- SINAIS INTERNOS
    signal s_memory_output : std_logic_vector(7 downto 0);
    signal s_bcd_result    : std_logic_vector(11 downto 0);
    
    signal s_reset_sync_0   : std_logic := '0'; -- MUDANÇA: Inicia em '0'
    signal s_reset_sync_1   : std_logic := '0'; -- MUDANÇA: Inicia em '0'
    signal s_reset_internal : std_logic; 
    signal s_write_mode     : std_logic; 

begin

    -- 1. LÓGICA DE CONTROLE DOS BOTÕES
    
    -- Sincronizador de Reset (Debounce)
    -- MUDANÇA: Removemos o "not"
    -- Agora, o reset (ativo-alto) do botão J2 é limpo e passado adiante.
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            s_reset_sync_0 <= rst_in; -- <-- A CORREÇÃO ESTÁ AQUI
            s_reset_sync_1 <= s_reset_sync_0;
        end if;
    end process;
    s_reset_internal <= s_reset_sync_1;

    -- Instancia o Toggle FF para o botão J5 (Apertar-para-Alternar)
    -- (Esta lógica assume que J5 é ativo-baixo, o que parece estar correto)
    U_TOGGLE: debounced_toggle_ff
        port map (
            clk_in => clk_in,
            rst_in => s_reset_internal, 
            btn_in => write_enable,     
            q_out  => s_write_mode      
        );

    -- 2. LÓGICA PRINCIPAL (Nenhuma mudança daqui para baixo)
    
    -- U1: Memória
    U1_STORAGE: data_storage_unit
        port map (
            clk_in       => clk_in,
            rst_in       => s_reset_internal,
            write_enable => s_write_mode,
            addr_row     => addr_row,
            addr_col     => addr_col,
            data_in      => data_in,
            data_out     => s_memory_output
        );

    -- U2: Conversor BCD
    U2_CONVERTER: binary_to_bcd_conv
        port map (
            bin_in => s_memory_output,
            bcd_out => s_bcd_result
        );

    -- U3: Display
    U3_DISPLAY: display_manager
        port map (
            clk_in        => clk_in,
            rst_in        => s_reset_internal,
            bcd_data_in   => s_bcd_result,
            segment_out   => segment_out,
            anode_select_out => anode_select_out
        );
        
    
    -- Espelha os switches de entrada nos LEDs
    led_data_out <= data_in;
    led_addr_out(1) <= addr_row;
    led_addr_out(0) <= addr_col;

end architecture Structure;