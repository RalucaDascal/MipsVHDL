----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2020 01:43:42 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
 Port ( Clk: in std_logic;
        EN: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        writeData: in std_logic_vector(15 downto 0);
        regWrite: in std_logic;
        regDest: in std_logic;
        extOp: in std_logic;
        rd1: out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0);
        extImm: out std_logic_vector(15 downto 0);
        func: out std_logic_vector(2 downto 0); 
        sa: out std_logic);
end IDecode;

architecture Behavioral of IDecode is
signal writeAddress: std_logic_vector(2 downto 0); 
type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (others => X"0000");
begin
 
 with regDest select
        writeAddress <= instruction(6 downto 4) when '1', -- rd
                        instruction(9 downto 7) when '0', -- rt
                        (others => '0') when others; -- unknown  
 
 process (Clk)
  begin
   if falling_edge(Clk) then 
    if EN='1' and regWrite='1' then
     reg_file(conv_integer(writeAddress)) <= writeData;
    end if; 
   end if; 
 end process;
 
 rd1 <= reg_file(conv_integer(instruction(12 downto 10)));
 rd2 <= reg_file(conv_integer(instruction(9 downto 7))); 

 extImm(6 downto 0) <= instruction(6 downto 0); 
 with extOp select
     extImm(15 downto 7) <= (others => instruction(6)) when '1',
                            (others => '0') when '0',
                            (others => '0') when others;
 
sa<=instruction(3);
func<=instruction(2 downto 0); 
end Behavioral;
