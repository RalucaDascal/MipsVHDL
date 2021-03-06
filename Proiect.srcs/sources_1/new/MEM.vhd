----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2020 10:30:21 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
   Port ( Clk : in std_logic;
          EN : in std_logic;
          MemWrite: in std_logic;
          ALUResIn: in std_logic_vector (15 downto 0);
          rd2: in std_logic_vector (15 downto 0);
          MemData: out std_logic_vector (15 downto 0);
          ALUResOut: out std_logic_vector (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type RAM is array (0 to 15) of std_logic_vector(0 to 15);
signal mem_RAM: RAM := (
    X"0010",--16
    X"0002",--2
    X"0005",--5
    X"0014",--20
    X"002B",--43
    X"000A",--10
    X"001B",--27
    X"0013",--19
    X"0018",--24
    X"001E",--30
    X"0001",--1
    X"000A",--10
    X"0007",--7
    others =>X"FFFF");

begin
 process (clk) 
  begin
    if rising_edge(clk)then
     if EN='1' and MemWrite='1' then
      mem_RAM(conv_integer(ALUResIN(3 downto 0)))<=RD2;
     end if;
    end if;  
 end process; 
 
 MemData <= mem_RAM(conv_integer(ALUResIn(3 downto 0))); 
 ALUResOut<=ALUResIn;

end Behavioral;
