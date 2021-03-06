----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 02:33:27 PM
-- Design Name: 
-- Module Name: MP_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MP_tb is
--  Port ( );
end MP_tb;

architecture Behavioral of MP_tb is
signal clk: std_logic :='0';
signal Rst: std_logic :='0';
signal En: std_logic :='0';
signal pc: std_logic_vector(15 downto 0):=(others => '0');
signal ALUResult: std_logic_vector(15 downto 0):=(others => '0');
constant clk_period : time := 10 ns;
begin
MP: entity work.ModulPrincipal
  Port map (clk=> clk,
        Rst=> Rst,
        En=>En,
        pc=>pc,
        aluresult=> ALUResult);
 gen_clk: process
  begin
   Clk <= '0';
   wait for (CLK_PERIOD/2);
   Clk <= '1';
   wait for (CLK_PERIOD/2);
end process gen_clk;

   stim_proc: process
   begin  
      rst <= '1';
      wait for clk_period;
      rst <= '0';
      en<='1';
 

      wait;
   end process;


end Behavioral;
