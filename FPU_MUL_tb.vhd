-- ====================================================================
--
--	File Name:		FPU_MUL_tb.vhd
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


entity FPU_MUL_tb is
end FPU_MUL_tb;

architecture rtl of FPU_MUL_tb is  

component FPU_MUL
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
        tester : FPU_MUL
        port map(A=>A_s, 
                 B=>B_s, 
                 result=>result_s);
      
      S <= result_s(31);
      e <= result_s(30 downto 23);
      f <= result_s(22 downto 0);
		
		testbench : process
        begin
       	A_s <= "01000011000001100001000000000000" ;
	     	B_s <= "11000000000100000000000000000000" ;
        wait for 20 ps;
       	A_s <= "11000001011010000000000000000000" ;
		    B_s <= "10111110110000000000000000000000" ;
        wait for 20 ps;
       	A_s <= "01000000111100000000000000000000" ;
		    B_s <= "01000001011110000000000000000000" ;
        wait for 20 ps;
      
        end process testbench;
        
end rtl;