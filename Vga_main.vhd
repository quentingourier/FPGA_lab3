----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:33 05/17/2022 
-- Design Name: 
-- Module Name:    Vga_main - Behavioral 
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
        Port ( clk     : in  STD_LOGIC;
                rst1   : in std_logic;
                Vsync  : out STD_LOGIC;
                Hsync  : out STD_LOGIC;
					 Red    : out STD_logic_vector (2 downto 0);
                Green  : out STD_logic_vector (2 downto 0);
                Blue   : out STD_logic_vector (1 downto 0));
               
end VGA_main;

architecture Behavioral of VGA_main is
    component clock_divider
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
					 HCntparse : out integer);
    end component;
    signal clk_25MHz    :std_logic:='0';
	 signal Video: std_logic;
	 signal Redtemp: STD_logic_vector (2 downto 0):="000";
	 signal Greentemp: STD_logic_vector (2 downto 0):="000";
	 signal Bluetemp: std_logic_vector(1 downto 0) := "00";
	 signal HCntparsetemp: integer:= 0;
	 
begin
	-- Clock Divider  for 4ps
    CV0 : clock_divider port map (
        clk     => clk,
        rst    =>rst1,
        clock_out    =>clk_25MHz
        );
	-- Map for VGA_Timming
    VT0 : VGA_timing port map (
        clk     => clk_25MHz,
        rst    =>rst1,
        Vsync => Vsync,
        Hsync =>Hsync,
        Video => Video,
		  HCntparse => HCntparsetemp
        );
		  
	 Redtemp    <= "111" when Video = '1' and HCntparsetemp <= 80 else -- Fisrt columne, red color red
						"000" when Video = '1' and (HCntparsetemp > 80 and HCntparsetemp <= 160) else -- Seconde columne, red color green 
						"000" when Video = '1' and (HCntparsetemp > 160 and HCntparsetemp <= 240) else -- Third columne, red color Blue
						"000" when Video = '1' and (HCntparsetemp > 240 and HCntparsetemp <= 320) else-- Forth columne, red color Black
						"111" when Video = '1' and (HCntparsetemp > 320 and HCntparsetemp <= 400) else-- fifth columne, red color white
						"111" when Video = '1' and (HCntparsetemp > 400 and HCntparsetemp <= 480) else -- sixth columne, red color yellow
						"000" when Video = '1' and (HCntparsetemp > 480 and HCntparsetemp <= 560) else-- seventh columne, red color cyan
						"111" when Video = '1' and (HCntparsetemp > 560 and HCntparsetemp <= 640) else -- hiehth columne, red color maganta
						"000";
						
						
	Greentemp    <= "000" when Video = '1' and HCntparsetemp <= 80 else -- Fisrt columne, red color red
						"111" when Video = '1' and (HCntparsetemp > 80 and HCntparsetemp <= 160) else-- Seconde columne, red color green
						"000" when Video = '1' and (HCntparsetemp > 160 and HCntparsetemp <= 240) else-- Third columne, red color Blue
						"000" when Video = '1' and (HCntparsetemp > 240 and HCntparsetemp <= 320) else-- Forth columne, red color Black
						"111" when Video = '1' and (HCntparsetemp > 320 and HCntparsetemp <= 400) else-- fifth columne, red color white
						"111" when Video = '1' and (HCntparsetemp > 400 and HCntparsetemp <= 480) else -- sixth columne, red color yellow
						"111" when Video = '1' and (HCntparsetemp > 480 and HCntparsetemp <= 560) else-- seventh columne, red color cyan
						"000" when Video = '1' and (HCntparsetemp > 560 and HCntparsetemp <= 640) else-- hiehth columne, red color maganta
						"000";
						 
	Bluetemp    <= "00" when Video = '1' and HCntparsetemp <= 80 else -- Fisrt columne, red color red
						"00" when Video = '1' and (HCntparsetemp > 80 and HCntparsetemp <= 160) else-- Seconde columne, red color green
						"11" when Video = '1' and (HCntparsetemp > 160 and HCntparsetemp <= 240) else-- Third columne, red color Blue
						"00" when Video = '1' and (HCntparsetemp > 240 and HCntparsetemp <= 320) else-- Forth columne, red color Black
						"11" when Video = '1' and (HCntparsetemp > 320 and HCntparsetemp <= 400) else-- fifth columne, red color white
						"00" when Video = '1' and (HCntparsetemp > 400 and HCntparsetemp <= 480) else -- sixth columne, red color yellow
						"11" when Video = '1' and (HCntparsetemp > 480 and HCntparsetemp <= 560) else-- seventh columne, red color cyan
						"11" when Video = '1' and (HCntparsetemp > 560 and HCntparsetemp <= 640) else -- hiehth columne, red color maganta
						"00";
	 
	 
	 
	 Red <= Redtemp;
	 Green <= Greentemp;
	 Blue <= Bluetemp;
	 
	 
end Behavioral;
