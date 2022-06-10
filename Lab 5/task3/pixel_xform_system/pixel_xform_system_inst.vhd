	component pixel_xform_system is
		port (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			leds_export     : out std_logic_vector(7 downto 0);                    -- export
			resetn_reset_n  : in  std_logic                    := 'X';             -- reset_n
			switches_export : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component pixel_xform_system;

	u0 : component pixel_xform_system
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --      clk.clk
			leds_export     => CONNECTED_TO_leds_export,     --     leds.export
			resetn_reset_n  => CONNECTED_TO_resetn_reset_n,  --   resetn.reset_n
			switches_export => CONNECTED_TO_switches_export  -- switches.export
		);

