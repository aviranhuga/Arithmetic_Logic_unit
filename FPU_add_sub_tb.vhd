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
	sub : in std_logic;
	result: out std_logic_vector(31 downto 0)
	);
end component;  

signal sub_s : std_logic;
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
                 result=>result_s,
                 sub=>sub_s);
      
      S <= result_s(31);
      e <= result_s(30 downto 23);
      f <= result_s(22 downto 0);
		
		testbench : process
        begin
        sub_s <= '0';
       	A_s <= "00000001100000000000000000000011" ;
		B_s <= "00000001100000000000000000000001" ;
        wait for 20 ps;
      
        end process testbench;
        
end rtl;