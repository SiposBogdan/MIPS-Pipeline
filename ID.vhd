
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID is
Port (
clk: in std_logic;
en: in std_logic;
RegWrite: in std_logic;
Instr: in std_logic_vector(25 downto 0);
--RegDst: in std_logic;
ExtOP: in std_logic;
wa : in std_logic_vector(4 downto 0);
RD1: out std_logic_vector(31 downto 0);
RD2: out std_logic_vector(31 downto 0);
WD: in std_logic_vector(31 downto 0);
Ext_Imm: out std_logic_vector(31 downto 0);
func : out std_logic_vector(5 downto 0);
sa : out std_logic_vector(4 downto 0);
rt: out std_logic_vector(4 downto 0);
rd: out std_logic_vector(4 downto 0)
);
    
end ID;

architecture Behavioral of ID is
signal mux: std_logic_vector(4 downto 0);

component reg_file
  port (
en: in std_logic;
clk : in std_logic;
ra1 : in std_logic_vector(4 downto 0);
ra2 : in std_logic_vector(4 downto 0);
wa : in std_logic_vector(4 downto 0);
wd : in std_logic_vector(31 downto 0);
regwr : in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0));
end component;
begin


    --process (RegDst) 
    --begin
        --if RegDst = '0' then 
            --mux <= Instr(20 downto 16);
        --else
            --mux <= Instr(15 downto 11); 
        --end if;
    --end process;
    mux <= wa(4 downto 0);
    process(ExtOp)
    begin
   
    if(ExtOp = '1') then
        Ext_Imm(31 downto 16) <= (others => Instr(15)) ;
        Ext_Imm(15 downto 0) <= Instr(15 downto 0);
    else
        Ext_Imm(31 downto 16) <= (others => '0');
        Ext_Imm(15 downto 0) <= Instr(15 downto 0);
    end if;
    end process;
    Registru: reg_file port map (clk=>clk, en=>en, ra1=>Instr(25 downto 21), ra2=>Instr(20 downto 16),wa=>mux, wd=>WD, regwr=>RegWrite, rd1=>RD1, rd2=>RD2);    
    func <= Instr(5 downto 0);
    sa <= Instr(10 downto 6);
    rt <= Instr(20 downto 16);
    rd <= Instr(15 downto 11);
end Behavioral;
