library ieee;
use ieee.std_logic_1164.all;

-- Este componente transforma um botão momentâneo (com bounce)
-- em um sinal estável do tipo liga/desliga (toggle).
entity debounced_toggle_ff is
    port (
        clk_in : in  std_logic; -- Clock principal
        rst_in : in  std_logic; -- Reset do sistema (ativo-alto)
        btn_in : in  std_logic; -- Entrada do botão (ativo-baixo)
        q_out  : out std_logic  -- Saída estável (o modo)
    );
end entity debounced_toggle_ff;

architecture Logic of debounced_toggle_ff is
    -- Sinal interno para o estado (começa em '0' = Modo Leitura)
    signal s_q_reg    : std_logic := '0';
    -- Sinal para guardar o estado anterior do botão (para detectar a borda)
    signal s_btn_prev : std_logic := '1'; -- Botão ativo-baixo, ocioso é '1'
begin

    process(clk_in, rst_in)
    begin
        if rst_in = '1' then
            s_q_reg    <= '0'; -- Reseta para Modo Leitura
            s_btn_prev <= '1';
        elsif rising_edge(clk_in) then
            -- Armazena o estado atual do botão
            s_btn_prev <= btn_in;
            
            -- Lógica de detecção de borda (Debounce simples):
            -- Se o botão *estava* em '1' (solto) E *agora* está em '0' (pressionado)
            if s_btn_prev = '1' and btn_in = '0' then
                s_q_reg <= not s_q_reg; -- Inverte o modo
            end if;
        end if;
    end process;

    -- Atribui o modo atual à porta de saída
    q_out <= s_q_reg;
    
end architecture Logic;