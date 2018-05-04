-- ====================================================================
--
--	File Name:		top_entity_tb.vhd
--	Description:	top entity test bench
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


entity top_entity_tb is
end top_entity_tb;

architecture rtl of top_entity_tb is  

component top_entity
port (
	data : in std_logic_vector(7 downto 0);
	key0_en : in std_logic;
	key1_en : in std_logic;
	key2_en : in std_logic;
	clock : in std_logic;
	HI_out : out std_logic_vector(7 downto 0);
	LO_out : out std_logic_vector(7 downto 0);
	Status_out : out std_logic_vector(5 downto 0)
	--enable : in std_logic
	);
end component;  

signal key0_en_t : std_logic;
signal key1_en_t : std_logic;
signal key2_en_t : std_logic;
signal clock_t : std_logic;
signal data_t : std_logic_vector(7 downto 0);
signal HI_out_t : std_logic_vector(7 downto 0);
signal LO_out_t : std_logic_vector(7 downto 0);
signal status_t : std_logic_vector(5 downto 0);

begin
        tester : top_entity
        port map(
		data => data_t, 
		key0_en => key0_en_t, 
		key1_en => key1_en_t,
		key2_en => key2_en_t,
		clock => clock_t,
		HI_out => HI_out_t, 
		LO_out => LO_out_t, 
		Status_out => status_t);
		
		testbench : process
        begin
		data_t <= "00000000";
		key0_en_t <= '0';
		key1_en_t <= '0';
		key2_en_t <= '0';
		clock_t <= '0';
		wait for 30 ps; 
		data_t <= "00000011";
		key0_en_t <= '1';
		key1_en_t <= '0';
		key2_en_t <= '0';
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 30 ps; 
		
		data_t <= "00000111";
		key0_en_t <= '0';
		key1_en_t <= '1';
		key2_en_t <= '0';
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		
		wait for 30 ps; 
		data_t <= "00000001";
		key0_en_t <= '0';
		key1_en_t <= '0';
		key2_en_t <= '1';
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 30 ps; 
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 30 ps; 
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 30 ps; 
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 30 ps; 
		clock_t <= '1';
		wait for 30 ps; 
		clock_t <= '0';
		wait for 5 ns;
		
        end process testbench;
end rtl;
