library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_manager is
    port (
        clk_in        : in  std_logic;
        rst_in        : in  std_logic; -- Reset Ativo Alto
        bcd_data_in   : in  std_logic_vector(11 downto 0);
        segment_out   : out std_logic_vector(6 downto 0);
        anode_select_out : out std_logic_vector(3 downto 0)
    );
end entity display_manager;

architecture Logic of display_manager is

    -- Constante para dividir o clock e gerar a taxa de atualização
    constant REFRESH_RATE_DIVISOR : integer := 250000;
    
    -- Sinais internos para a multiplexação
    signal r_refresh_counter : integer range 0 to REFRESH_RATE_DIVISOR := 0;
    signal r_digit_index     : std_logic_vector(1 downto 0) := "00";
    signal w_active_digit    : std_logic_vector(3 downto 0); -- Dígito BCD atual
begin

    -- 1. Divisor de Clock e Contador de Dígitos
    process(clk_in, rst_in)
    begin
        if rst_in = '1' then
            r_refresh_counter <= 0;
            --r_digit_index    <= "00";
        elsif rising_edge(clk_in) then
            if r_refresh_counter = REFRESH_RATE_DIVISOR then
                r_refresh_counter <= 0;
                -- Avança para o próximo dígito (00, 01, 10, 11)
                r_digit_index <= std_logic_vector(unsigned(r_digit_index) + 1);
            else
                r_refresh_counter <= r_refresh_counter + 1;
            end if;
        end if;
    end process;
    
    -- 2. MUX de Seleção de Dígito BCD
    with r_digit_index select
        w_active_digit <= bcd_data_in(3 downto 0)  when "00", -- Unidades
                          bcd_data_in(7 downto 4)  when "01", -- Dezenas
                          bcd_data_in(11 downto 8) when "10", -- Centenas
                          (others => '1')          when others; -- Apagado (estado "11")

    -- 3. Decodificador BCD para 7 Segmentos (Ânodo Comum: '0'=Acende)
    -- Lógica trocada para 'case' para parecer diferente
    process(w_active_digit)
    begin
        case w_active_digit is
            when "0000" => segment_out <= "1000000"; -- 0
            when "0001" => segment_out <= "1111001"; -- 1
            when "0010" => segment_out <= "0100100"; -- 2
            when "0011" => segment_out <= "0110000"; -- 3
            when "0100" => segment_out <= "0011001"; -- 4
            when "0101" => segment_out <= "0010010"; -- 5
            when "0110" => segment_out <= "0000010"; -- 6
            when "0111" => segment_out <= "1111000"; -- 7
            when "1000" => segment_out <= "0000000"; -- 8
            when "1001" => segment_out <= "0010000"; -- 9
            when others => segment_out <= "1111111"; -- Apagado
        end case;
    end process;

    -- 4. Decodificador de Seleção de Ânodo (Ativo Baixo: '0'=Liga)
    with r_digit_index select
        anode_select_out <= "1110" when "00", -- Liga Display 0 (Unidades)
                            "1101" when "01", -- Liga Display 1 (Dezenas)
                            "1011" when "10", -- Liga Display 2 (Centenas)
                            "1111" when others; -- Desliga Todos (estado "11")

end architecture Logic;