----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2020 02:49:01 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
 Port (Clk: in std_logic;
       Rst: in std_logic;
       EN: in std_logic;  
       branchAddress: in std_logic_vector(15 downto 0);
       jumpAddress: in std_logic_vector(15 downto 0);
       jump: in std_logic;
       pcSrc: in std_logic;
       instruction: out std_logic_vector(15 downto 0);
       nextInstruction:  out std_logic_vector(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
type MEM is array (0 to 22) of std_logic_vector(15 downto 0);
signal ROM:MEM:=(B"001_000_111_0001100", -- addi $7,$0,12 - 12 numere in sir
                 B"001_000_110_0000000", -- addi $6,$0,0 - suma numerelor
                 B"001_000_001_0000000", -- addi $1,$0,0 - counter in sir
                 B"001_000_101_0000100", -- addi $5,$0,4 - multiplu

                 B"010_001_010_0000000", -- lw $2,0($1) - ia cate un element din sir
                 B"011_010_011_0000001", -- andi $3,$2,1 - daca e numar par reg3 va avea valoarea 0, altfel 1
                 B"001_000_100_0000001", -- addi $4,$0,1 - in reg4 incarca valoarea 1
                 B"100_100_011_0000001", -- beq $3,$4,1 - daca numarul e impar va sari peste suma
                 B"000_110_010_110_0_001", -- add $6,$6,$2 - daca numarul e par se va aduna la suma
                 B"001_001_001_0000001", -- addi $1,$1,1 - se incrementeaza pozitia in sir
                 B"100_111_001_0000001", -- beq $1,$7,1 - in cazul in care pozitia e 13 inseamna ca am evaluat cele 12 numere din sir
                 B"101_0000000000100", -- j 4 - in cazul in care nu am ajuns la 13 se sare la citirea numerelor din memorie

                 B"001_110_001_0000000", -- addi $1,$6,0 - se incarca in reg1 suma, deoarece aceasta va suferi scaderi succesive si astfel se va pierde valoarea
                 B"100_000_001_0000100", -- beq $1,$0,4 - daca suma e egala cu 0 inseamna ca e multiplu si se sare la validarea cond suma e un multiplu de numar dat
                 B"100_001_101_0000011", -- beq $5,$1,3 - daca suma e egala cu numarul dat se sare la validarea cond suma e un multiplu de numar dat
                 B"110_001_101_0000110", -- blt $5,$1,6 - daca suma ramasa e mai mica decat numarul dat inseamna ca aceasta nu e multiplu si se sare la negarea conditiei (adica valoarea 0-False in reg7) 
                 B"000_001_101_001_0_010", -- sub $1,$1,$5 - in cazul in care e mai mare se face scaderea numarului dat din suma ramasa
                 B"101_0000000001110", -- j 14 - se sare la compararea sumei ramase cu multiplu

                 B"001_000_111_0000001", -- addi $7,$0,1 - se incarca valoare 1 in cazul in care e multiplu de numar dat
                 B"001_000_001_0000001", -- addi $1,$0,1 - se incarca valoarea 1 in reg1 
                 B"111_001_110_0000000", -- sw $6 0($1) - daca e suma e multiplu de numar dat se incarca suma la adresa 1 in memorie
                 B"100_111_001_0000001", -- beq  $1,$7,1 - in cazul in care a fost multiplu de numar dat se sare peste setarea reg7 cu valoarea 0 specifica lui False.  
                 B"001_000_111_0000000"); -- addi $7,$0,0  - se incarca valoarea 0 in caz ca nu e multiplu
signal pc : std_logic_vector(15 downto 0) := (others => '0');
signal pcAux,mux1,mux2: std_logic_vector(15 downto 0);
begin
process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                pc <= (others => '0');
            elsif EN = '1' then
                pc <= mux2;
            end if;
        end if;
end process;

instruction <= ROM(conv_integer(pc(15 downto 0)));

pcAux <= pc + 1;
nextInstruction <= pcAux;

process(pcSrc, pcAux, BranchAddress)
    begin
        if (pcSrc='1') then
           mux1 <= branchAddress;
        else
           mux1 <= pcAux;
       end if;
end process;	

process(jump, mux1, jumpAddress)
    begin
        if (jump='1') then
           mux2 <= jumpAddress;
        else
           mux2 <= mux1;
        end if;
end process;

end Behavioral;
