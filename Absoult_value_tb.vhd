-- ====================================================================
--
--	File Name:		Absoult_value_tb.vhd
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


entity Absoult_value_tb is
end Absoult_value_tb;

architecture rtl of Absoult_value_tb is  

component Absoult_value
generic ( N: integer :=8);
port (
	Input : in std_logic_vector(N-1 downto 0);
	Output : out std_logic_vector(N-1 downto 0)
	);
end component;  

signal Input_s: std_logic_vector(7 downto 0);
signal Output_s : std_logic_vector(7 downto 0);


begin
        tester : Absoult_value
        port map(Input=>Input_s, 
                 Output=>Output_s);
      
		testbench : process
        begin
		Input_s <= "11111110" ;
        wait for 20 ps;
       	Input_s <= "01010111" ;
        wait for 20 ps;
      
        end process testbench;
        
end rtl;