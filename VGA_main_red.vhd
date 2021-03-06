----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:08:22 05/17/2022 
-- Design Name: 
-- Module Name:    VGA_main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_main is
		Port ( clk : in  STD_LOGIC;
				rst1 :in std_logic;
				Vsync : out STD_LOGIC;
				Hsync : out STD_LOGIC;
				Red	: out STD_logic_vector (2 downto 0);
				Green	: out STD_logic_vector (2 downto 0);
				Blue	: out STD_logic_vector (1 downto 0));
end VGA_main;

architecture Behavioral of VGA_main is
	component Clock_Vga
		Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clock_out : out  STD_LOGIC);
	end component;
	component VGA_timing
		Port ( clk : in  STD_LOGIC;
				rst :in std_logic;
				Vsync : out STD_LOGIC;
				Hsync : out STD_LOGIC;
				Video : out STD_LOGIC;
				HCnto : out integer);
	end component;
	signal clk_25MHz	:std_logic:='0';
	SIGNAL Video : STD_LOGIC;
	SIGNAL HCnto_temp : integer;
	Signal Red_temps	:  STD_logic_vector (2 downto 0);
	Signal Green_temps	:  STD_logic_vector (2 downto 0);
	Signal Blue_temps	:  STD_logic_vector (1 downto 0);
begin
	-- Clock Divider  for 4ps
	CV0 : Clock_Vga port map (
		clk 	=> clk,
		rst	=>rst1,
		clock_out	=>clk_25MHz
		);
	-- Map for VGA_Timming
	VT0 : VGA_timing port map (
		clk 	=> clk_25MHz,
		rst	=>rst1,
		Vsync => Vsync,
		Hsync =>Hsync,
		Video => Video,
		HCnto =>HCnto_temp
		);
		Red_temps <= "111" when Video = '1' else
							"000";
		Blue_temps <= "00";
		Green_temps <= "000";

	 
	 Red <= Red_temps;
	 Green <= Green_temps;
	 Blue <= Blue_temps;
end Behavioral;
