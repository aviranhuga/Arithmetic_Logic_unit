-- ====================================================================
--
--	File Name:		FPU_encoder_tb.vhd
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


entity FPU_encoder_tb is
end FPU_encoder_tb;

architecture rtl of FPU_encoder_tb is  

component FPU_encoder
port (
	Input : in std_logic_vector(7 downto 0);	
	Output : out std_logic_vector(31 downto 0)
	);
end component;  

signal Input_s: std_logic_vector(7 downto 0);
signal result_s : std_logic_vector(31 downto 0);
signal S: std_logic;
signal e: std_logic_vector(7 downto 0);
signal f: std_logic_vector(22 downto 0);

begin
        tester : FPU_encoder
        port map(Input=>Input_s, 
                 Output=>result_s);
      
      S <= result_s(31);
      e <= result_s(30 downto 23);
      f <= result_s(22 downto 0);
		
		testbench : process
        begin
       	Input_s <= "01010111" ;
        wait for 20 ps;
        Input_s <= "10011110" ;
        wait for 20 ps;
        end process testbench;
        
end rtl;