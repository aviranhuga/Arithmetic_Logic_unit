-- ====================================================================
--
--	File Name:		Lead_zeros_counter_tb.vhd
--	Description:	Lead_zeros_counter testbench  
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


entity Lead_zeros_counter_tb is
end Lead_zeros_counter_tb;

architecture rtl of Lead_zeros_counter_tb is  

component Lead_zeros_counter
port (
	add_sub_cout : in std_logic;
	num : in std_logic_vector(21 downto 0);	
	side_to_shift : out std_logic;
	result : out std_logic_vector(4 downto 0)
	);
end component;  

signal add_sub_cout_s : std_logic;
signal num_s : std_logic_vector(21 downto 0);
signal side_to_shift_s : std_logic;
signal result_s : std_logic_vector(4 downto 0);

begin
        tester : Lead_zeros_counter
        port map(add_sub_cout=>add_sub_cout_s, 
                 num=>num_s, 
                 side_to_shift=>side_to_shift_s,
                 result=>result_s);
		
		testbench : process
        begin
        add_sub_cout_s <= '1';
       	num_s <= "0010000001000000100000" ;
        wait for 20 ps;
		
        num_s <= "0000100001000000100100" ;
        wait for 20 ps;
		
        num_s <= "0100100001000000100001" ;
        wait for 20 ps;
      
        end process testbench;
        
end rtl;