	component pixel_xform_system is
		port (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			leds_export     : out std_logic_vector(7 downto 0);                    -- export
			resetn_reset_n  : in  std_logic                    := 'X';             -- reset_n
			switches_export : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			vga_b           : out std_logic_vector(7 downto 0);                    -- b
			vga_clk         : out std_logic;                                       -- clk
			vga_g           : out std_logic_vector(7 downto 0);                    -- g
			vga_hs          : out std_logic;                                       -- hs
			vga_r           : out std_logic_vector(7 downto 0);                    -- r
			vga_vs          : out std_logic                                        -- vs
		);
	end component pixel_xform_system;

	u0 : component pixel_xform_system
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --      clk.clk
			leds_export     => CONNECTED_TO_leds_export,     --     leds.export
			resetn_reset_n  => CONNECTED_TO_resetn_reset_n,  --   resetn.reset_n
			switches_export => CONNECTED_TO_switches_export, -- switches.export
			vga_b           => CONNECTED_TO_vga_b,           --      vga.b
			vga_clk         => CONNECTED_TO_vga_clk,         --         .clk
			vga_g           => CONNECTED_TO_vga_g,           --         .g
			vga_hs          => CONNECTED_TO_vga_hs,          --         .hs
			vga_r           => CONNECTED_TO_vga_r,           --         .r
			vga_vs          => CONNECTED_TO_vga_vs           --         .vs
		);

