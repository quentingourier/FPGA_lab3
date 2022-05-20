----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:11 05/17/2022 
-- Design Name: 
-- Module Name:    Vga_timing - Behavioral 
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

entity Vga_timing is
Port ( clk : in STD_LOGIC;
 rst : in STD_LOGIC;
 Vsync : out STD_LOGIC;
 Hsync : out STD_LOGIC;
 Video : out STD_LOGIC;
 HCntparse: out integer);
end Vga_timing;

architecture Behavioral of Vga_timing is

-- Vertical & horizontal State Machines
type State is (ST_ACTIVE, ST_FRONT_PORCH, ST_SYNC, ST_BACK_PORCH);
signal VState, HState : State;
-- H & V counters
signal HCnt, VCnt : integer range 0 to 4095;

begin
-- Signal assignments
Vsync <= '0' when VState = ST_SYNC else '1';
Hsync <= '0' when HState = ST_SYNC else '1';
Video <= '1' when ((VState = ST_ACTIVE) and (HState = ST_ACTIVE)) else '0';
-- Horizontal state machine
pStateH : process(clk)
begin
 if clk'event and clk='1' then
	if rst = '1' then
		HState <= ST_ACTIVE;
		HCnt <= 1;
		HCntparse <= HCnt;
	else
		case HState is
			when ST_ACTIVE =>
				if HCnt = 640 then
					HState <= ST_FRONT_PORCH;
					HCnt <= 1;
					HCntparse <= HCnt;
				else
					HCnt <= HCnt + 1;
					HCntparse <= HCnt;
				end if;
			when ST_FRONT_PORCH =>
				if HCnt = 16 then
					HState <= ST_SYNC;
					HCnt <= 1;
					HCntparse <= HCnt;
				else
					HCnt <= HCnt + 1;
					HCntparse <= HCnt;
				end if;
			when ST_SYNC =>
				if HCnt = 96 then
					HState <= ST_BACK_PORCH;
					HCnt <= 1;
					HCntparse <= HCnt;
				else 
					HCnt <= HCnt + 1;
					HCntparse <= HCnt;
				end if;
			when ST_BACK_PORCH =>
				if HCnt = 48 then
					HState <= ST_ACTIVE;
					HCnt <= 1;
					HCntparse <= HCnt;
				else 
					HCnt <= HCnt + 1;
					HCntparse <= HCnt;
				end if;
			end case;
		end if; 
	end if;
end process;

pStateV : process(clk)
            begin
                if clk'event and clk='1' then
                    if rst = '1' then
                        VState <= ST_ACTIVE;
                        VCnt <= 1;
                    else
                        if ((HState = ST_BACK_PORCH) and (HCnt = 48)) then
                            case VState is
                                when ST_ACTIVE =>
                                    if VCnt = 480 then
                                        VState <= ST_FRONT_PORCH;
                                        VCnt <= 1;
                                    else
                                        VCnt <= VCnt + 1;
                                    end if;
											when ST_FRONT_PORCH =>
												 if VCnt = 10 then
														VState <= ST_SYNC;
														VCnt <= 1;
												 else
														VCnt <= VCnt + 1;
												 end if;

											when ST_SYNC =>
												 if VCnt = 2 then
														VState <= ST_BACK_PORCH;
														VCnt <= 1;
												 else
														VCnt <= VCnt + 1;
												 end if;

											when ST_BACK_PORCH =>
												 if VCnt = 29 then
														VState <= ST_ACTIVE;
														VCnt <= 1;
												 else
														VCnt <= VCnt + 1;
												 end if;
													
                                -- complete
									 end case;
								end if;
						  end if;
					 end if;
			end process;

end Behavioral;

