library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;
Architecture Behavioral of test_env is

component MPG 
   Port (enable: out STD_LOGIC;
          btn: in STD_LOGIC;
          clk: in STD_LOGIC);
end component ;

component SSD
   PORT( clk : in STD_LOGIC;
       digits : in STD_LOGIC_VECTOR(31 downto 0);
        --schimba :in std_logic;
       an : out STD_LOGIC_VECTOR(7 downto 0);
       cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch is
Port (clk : in STD_LOGIC;
      reset: in std_logic;
      btn : in STD_LOGIC_VECTOR (4 downto 0);
      PCSrc: in std_logic;
      jump: in std_logic;
      jump_adress : in STD_LOGIC_VECTOR (31 downto 0);
      branch_adress: in STD_LOGIC_VECTOR (31 downto 0);
      instruction : out STD_LOGIC_VECTOR (31 downto 0);
      PCplusPatru: out STD_LOGIC_VECTOR (31 downto 0)
      );
      
end component;

component UC is
Port(
instr : in std_logic_vector(31 downto 26);
MemtoReg: out std_logic;
MemWrite: out std_logic;
Jump: out std_logic;
Branch: out std_logic;
Branch_gt: out std_logic;
ALUSrc: out std_logic;
ALUOp: out std_logic_vector(2 downto 0);
RegWrite: out std_logic;
RegDst: out std_logic;
ExtOp: out std_logic
);
end component;

component ID is
Port (
clk: in std_logic;
en: in std_logic;
RegWrite: in std_logic;
Instr: in std_logic_vector(25 downto 0);
--RegDst: in std_logic;
wa: in std_logic_vector(4 downto 0);
ExtOP: in std_logic;
RD1: out std_logic_vector(31 downto 0);
RD2: out std_logic_vector(31 downto 0);
WD: in std_logic_vector(31 downto 0);
rt: out std_logic_vector(4 downto 0);
rd: out std_logic_vector(4 downto 0);
Ext_Imm: out std_logic_vector(31 downto 0);
func : out std_logic_vector(5 downto 0);
sa : out std_logic_vector(4 downto 0)
); 
end component;

component EX is
port(RD1: in std_logic_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2: in  std_logic_vector(31 downto 0);
    rt: in std_logic_vector( 4 downto 0);
    rd: in std_logic_vector (4 downto 0);
    regdst: in std_logic;
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector(4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    PCplusPatru: in std_logic_vector(31 downto 0);
    Zero: out std_logic;
    NotZero: out std_logic;
    ALURes: out std_logic_vector(31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0);
    rwa: out std_logic_vector(4 downto 0)
);
end component;


component MEM is
  Port (
MemWrite: in STD_LOGIC;--
ALUResIn: in STD_LOGIC_VECTOR (31 downto 0);--
WriteData: in STD_LOGIC_VECTOR (31 downto 0);
clk: in STD_LOGIC;--
En: in STD_LOGIC;--
ReadData : out STD_LOGIC_VECTOR (31 downto 0);
ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;


signal REG_IF_ID: std_logic_vector(63 downto 0):= (others=>'0');
signal REG_ID_EX: std_logic_vector(158 downto 0):= (others=>'0');
signal REG_EX_MEM: std_logic_vector(107 downto 0):= (others=>'0');
signal REG_MEM_WB: std_logic_vector(70 downto 0):= (others=>'0');



signal jumpAddress: std_logic_vector(31 downto 0);
signal PCplusPatru: std_logic_vector(31 downto 0);
signal instruction: std_logic_vector(31 downto 0);
signal PCSrc: std_logic;
signal branch: std_logic;
signal zero: std_logic;
signal reset: std_logic;
signal jump: STD_LOGIC;
signal branch_adress: Std_logic_vector(31 downto 0);
signal rez: std_logic;
signal digits : STD_LOGIC_VECTOR(31 downto 0);
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal MemWrite: std_logic;
signal ALUSrc: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal RD1: std_logic_vector(31 downto 0):=(others=>'0');
signal RD2: std_logic_vector(31 downto 0):=(others=>'0');
signal WD: std_logic_vector(31 downto 0);
signal Ext_Imm: std_logic_vector(31 downto 0);
signal func : std_logic_vector(5 downto 0);
signal sa : std_logic_vector(4 downto 0); 
signal ALURes: std_logic_vector(31 downto 0);
signal ALUResOut: std_logic_vector(31 downto 0);
signal MemData: std_logic_vector(31 downto 0);
signal swit: std_logic_vector(2 downto 0);
signal not_zero: std_logic;
signal branch_gt: std_logic;
signal enable: std_logic;

signal rt: std_logic_vector(4 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal rwa: std_logic_vector(4 downto 0);

begin


IFetch1: IFetch port map(
    clk => clk,
    btn => btn,---nu sunt sigurrr
    reset => enable,
    jump =>jump,
    PCSrc =>PCSrc,
    instruction => instruction,
    PCplusPatru => PCplusPatru,
    jump_adress => jumpAddress,
    branch_adress => Reg_EX_MEM(31 downto 0)
);
process(clk, enable)
    begin
    if rising_edge(clk)and enable = '1' then
    Reg_IF_ID(31 downto 0) <= instruction;
    Reg_IF_ID(63 downto 32) <= PCplusPatru;
    end if;  
end process;



mpg1: MPG port map
(
    btn=>btn(0),
    clk=>clk,
    enable=>enable
);

ssd1: SSD port map(
    clk => clk,
    cat => cat,
    an=> an,
    --schimba => sw(15),
    digits => digits
);

UnitateControl: UC port map(
    instr => Reg_IF_ID(31 downto 26),
    MemtoReg => MemtoReg,
    MemWrite => MemWrite,
    Jump => Jump,
    Branch => Branch,
    Branch_gt => branch_gt,
    ALUSrc => ALUSrc,
    ALUOp => ALUOp,
    RegWrite => RegWrite,
    RegDst => RegDst,
    ExtOp => ExtOp
 
);
IDecode: ID port map(
    clk => clk,
    en => enable,
    RegWrite => Reg_MEM_WB(70),
    Instr => Reg_IF_ID(25 downto 0),--instruction(25 downto 0),
    --RegDst => RegDst, nu e la pipe
    rd => rd,--
    rt => rt,--
    ExtOP => ExtOp,
    RD1 => RD1,
    RD2 => RD2,
    WD => WD,
    wa => Reg_MEM_WB(68 downto 64),
    Ext_Imm => Ext_Imm,
    func => func,
    sa => sa
);
process(clk,enable)
    begin
    if rising_edge(clk) and enable = '1' then
    
    Reg_ID_Ex(31 downto 0) <= Reg_IF_ID(63 downto 32);
    --RegDst => RegDst, nu e la pipe
    Reg_ID_Ex(63 downto 32) <= RD1;--
    Reg_ID_Ex(95 downto 64) <= RD2;--
    Reg_ID_Ex(100 downto 96) <= rd;
    Reg_ID_Ex(105 downto 101) <= Rt;
    Reg_ID_Ex(137 downto 106) <= Ext_Imm;
    Reg_ID_EX(143 downto 138) <= func;
    Reg_ID_EX(148 downto 144) <= sa;
    Reg_ID_EX(149) <= RegDst;
    Reg_ID_EX(150) <= ALUsrc;
    Reg_ID_EX(151) <= Branch;
    Reg_ID_EX(152) <= Branch_gt;
    Reg_ID_EX(155 downto 153) <= ALUOp;
    Reg_ID_EX(156) <= MemWrite;
    Reg_ID_EX(157) <= MEMtoReg;
    Reg_ID_EX(158) <= RegWrite;
   
    end if;  
end process;


UnitateExec: EX port map(
RD1 => Reg_ID_Ex(63 downto 32),--RD1,
RD2 => Reg_ID_Ex(95 downto 64),--RD2,
rt => Reg_ID_Ex(105 downto 101),
rd => Reg_ID_Ex(100 downto 96),
regdst => Reg_ID_EX(149),
rwa => rwa,
ALUSrc =>Reg_ID_EX(150),--ALU
Ext_Imm => Reg_ID_Ex(137 downto 106),--ext_IMM
sa => Reg_ID_EX(148 downto 144),--sa,
func => Reg_ID_EX(143 downto 138),
ALUOp => Reg_ID_EX(155 downto 153),
PCplusPatru => Reg_ID_Ex(31 downto 0),
Zero => Zero,
Notzero => not_zero,
ALURes => ALURes,
BranchAddress => branch_adress
);


process(clk,enable)
    begin
    if rising_edge(clk) and enable ='1' then
    
    Reg_EX_MEM(31 downto 0) <= Branch_Adress;
    --RegDst => RegDst, nu e la pipe
    Reg_EX_MEM(63 downto 32) <= ALURes;--
    Reg_EX_MEM(68 downto 64) <= rwa;--
    Reg_EX_MEM(69) <= ZERO;
    Reg_EX_MEM(101 downto 70) <= Reg_ID_Ex(95 downto 64);--rd2
    Reg_EX_MEM(102) <= Reg_ID_EX(151);--branch
    Reg_EX_MEM(103) <= Reg_ID_EX(152);--branch_gt
    Reg_EX_MEM(104) <= Reg_ID_EX(156);-- MemWrite;
    Reg_EX_MEM(105) <= Reg_ID_EX(157);-- MEMtoReg;
    Reg_EX_MEM(106) <= Reg_ID_EX(158);-- RegWrite;
    Reg_EX_mem(107) <= not_Zero;
    end if;  
end process;

process(clk, enable)
    begin
    if rising_edge(clk) and enable = '1' then
    
    Reg_MEM_WB(31 downto 0) <= ALUResOut;
    Reg_MEM_WB(63 downto 32) <= MemData;--
    Reg_MEM_WB(68 downto 64) <= Reg_EX_MEM(68 downto 64);--wa
    Reg_MEM_WB(69) <= Reg_ID_EX(157);-- MEMtoReg;
    Reg_MEM_WB(70) <= Reg_ID_EX(158);-- RegWrite;
    end if;  
end process;

Mem1: MEM port map(
    clk => clk,
    En => enable,
    memWrite=> Reg_ID_EX(156),
    ALUResIn => Reg_EX_MEM(63 downto 32),
    ReadData => MemData,
    ALUResOut => ALUResOut,
    WriteData => Reg_EX_mem(101 downto 70)
);

jumpAddress<=Reg_IF_ID(63 downto 60)&Reg_IF_ID(25 downto 0)& "00";
--pcsrc <= '0';
pcsrc <= (Reg_EX_MEM(102) and Reg_EX_mem(69)) or (Reg_EX_MEM(103) and Reg_EX_mem(107));

process(Reg_MEM_WB(69))
begin
     if(Reg_MEM_WB(69)='1') then 
        WD<=MemData;
     else
         WD<=ALUresout;
     end if;   
end process;


led(15 downto 13) <="000";
led(12 downto 0)<=enable & ALUOp & RegDst & ExtOp & ALUSrc & branch & branch_gt & jump & MemWrite & MemtoReg & RegWrite;

swit<=sw(2 downto 0);

process(swit, instruction, RD1, RD2, PCplusPatru, ext_imm, ALUResout, MemData, WD)
begin
case swit is
    when "000" => digits<=instruction;
    when "001" => digits<=RD1;--instruction(25 downto 21)&X"000000"&"000";--
    --when "001" => digits<=X"000000"&"000"&instruction(25 downto 21);
    --when "010" => digits<=X"000000"&"000"&instruction(20 downto 16);
    when "010" => digits<=RD2;--instruction(20 downto 16)&X"000000"&"000";
    when "011" => digits<=PCplusPatru;
    when "100" => digits<=ext_imm;
    when "101" => digits<=ALUResout;
    when "110" => digits<=MemData;
    when others => digits<=WD;
    
  end case;

end process;

end Behavioral;