--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(7 downto 0); -- operands and opcode
        btnU    :   in std_logic; -- reset
        btnC    :   in std_logic; -- fsm cycle
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
    component controller_fsm is
    Port(
        i_clk   : in STD_LOGIC;
        i_reset : in STD_LOGIC;
        i_adv   : in STD_LOGIC;
        o_cycle : out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    
    

    component ALU is
        Port (
            i_A      : in STD_LOGIC_VECTOR (7 downto 0);
            i_B      : in STD_LOGIC_VECTOR (7 downto 0);
            i_op     : in STD_LOGIC_VECTOR (2 downto 0);
            o_result : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
  
  
  signal w_cycle  : std_logic_vector(3 downto 0);
    signal f_A      : std_logic_vector(7 downto 0);
    signal f_B      : std_logic_vector(7 downto 0);
    signal f_op     : std_logic_vector(2 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    
    
begin
	-- PORT MAPS ----------------------------------------
    fsm_inst : controller_fsm
    port map (
        i_clk   => clk,
        i_reset => btnU,
        i_adv   => btnC,
        o_cycle => w_cycle
    );
    alu_inst : ALU
        port map (
            i_A      => f_A,
            i_B      => f_B,
            i_op     => f_op,
            o_result => w_result
        );
        
      process(clk, btnU)
    begin
        if btnU = '1' then
            f_A  <= (others => '0');
            f_B  <= (others => '0');
            f_op <= (others => '0');

       elsif rising_edge(clk) then
    if btnC = '1' then
        case w_cycle is
            when "0001" =>
                f_A <= sw;

            when "0010" =>
                f_B <= sw;

            when "0100" =>
                f_op <= sw(2 downto 0);

            when others =>
                null;
        end case;
    end if;
end if;
    end process;
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	led(7 downto 0)   <= w_result;
    led(11 downto 8)  <= w_cycle;
    led(15 downto 12) <= "0000";
  
    seg <= "1111111";
    an  <= "1111";

	
	
end top_basys3_arch;
