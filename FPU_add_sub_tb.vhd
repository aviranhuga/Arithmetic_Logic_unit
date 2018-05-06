-- ====================================================================
--
--	File Name:		FPU_add_sub_tb.vhd
--	Description:	FPU add sub tb testbench  
--					
--
--	Date:			4/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity FPU_add_sub_tb is
end FPU_add_sub_tb;

architecture rtl of FPU_add_sub_tb is  

component FPU_add_sub
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	result: out std_logic_vector(31 downto 0)
	);
end component;  

signal A_s : std_logic_vector(31 downto 0);
signal B_s : std_logic_vector(31 downto 0);
signal result_s : std_logic_vector(31 downto 0);
signal S: std_logic;
signal e: std_logic_vector(7 downto 0);
signal f: std_logic_vector(22 downto 0);

begin
        tester : FPU_add_sub
        port map(A=>A_s, 
                 B=>B_s, 
                 result=>result_s);
      
      S <= result_s(31);
      e <= result_s(30 downto 23);
      f <= result_s(22 downto 0);
		
		testbench : process
        begin
       	A_s <= x"41580000" ;
		    B_s <= x"41c80000" ;
        wait for 20 ps;
       	A_s <= x"41c80000" ;
		    B_s <= x"41580000" ;
        wait for 20 ps;
       	A_s <= x"c2530000" ;
		    B_s <= x"c0f00000" ;
        wait for 20 ps;
       	A_s <= x"c0500000" ;
		    B_s <= x"42000000" ;
		    wait for 20 ps;
       	A_s <= x"42000000" ;
		    B_s <= x"c0500000" ;
        wait for 20 ps;
       	A_s <= x"418a0000" ;
		    B_s <= x"c11c0000" ;
        wait for 20 ps;
        
        end process testbench;
        
end rtl;