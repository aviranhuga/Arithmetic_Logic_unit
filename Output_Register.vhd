-- ====================================================================
--
--	File Name:		Output_Register.vhd
--	Description:	Output register
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Output_Register is 
port (
	clk : in std_logic;
	HI_in : in std_logic_vector(7 downto 0);
	LO_in : in std_logic_vector(7 downto 0);
	Status_in : in std_logic_vector(5 downto 0);
	HI_seven_seg1 : out std_logic_vector(6 downto 0);
	HI_seven_seg2 : out std_logic_vector(6 downto 0);
	LO_seven_seg1 : out std_logic_vector(6 downto 0);
	LO_seven_seg2 : out std_logic_vector(6 downto 0);
	Status_out : out std_logic_vector(5 downto 0)
	);
	
end Output_Register;

architecture Output_Register_arch of Output_Register is

component DFF_for_reg 
	port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end component;

component seven_seg_disp 
port (
	data : in std_logic_vector(3 downto 0);	
	data_out : out std_logic_vector(6 downto 0)
	);
end component;

signal one_signal : std_logic;
signal Low_data : std_logic_vector(7 downto 0);
signal High_data : std_logic_vector(7 downto 0);

begin    
	one_signal <= '1';
	
	seven_seg_disp_LO1: seven_seg_disp
	port map(
	data => Low_data(3 downto 0),
	data_out => LO_seven_seg1);
	
	seven_seg_disp_LO2: seven_seg_disp
	port map(
	data => Low_data(7 downto 4),
	data_out => LO_seven_seg2);
	
	seven_seg_disp_HI1: seven_seg_disp
	port map(
	data => High_data(3 downto 0),
	data_out => HI_seven_seg1);
	
	seven_seg_disp_HI2: seven_seg_disp
	port map(
	data => High_data(7 downto 4),
	data_out => HI_seven_seg2);
	
	--register for HI
	Array_Of_DFF_HI: for i in 0 to 7 generate
		dff_HIi: DFF_for_reg port map(data => HI_in(i),clk=>clk, en=>one_signal, q=>High_data(i));
	end generate Array_Of_DFF_HI;
	
	--Register for B
	Array_Of_DFF_LO: for i in 0 to 7 generate
		dff_LOi: DFF_for_reg port map(data => LO_in(i),clk=>clk, en=>one_signal, q=>Low_data(i));
	end generate Array_Of_DFF_LO;
	
		--Register for OP
	Array_Of_DFF_status: for i in 0 to 5 generate
		dff_statusi: DFF_for_reg port map(data => Status_in(i),clk=>clk, en=>one_signal, q=>Status_out(i));
	end generate Array_Of_DFF_status;
	
	
end Output_Register_arch;