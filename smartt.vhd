library ieee;
use ieee.std_logic_1164.all;

entity smartt is
port(LEDR:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--KEY1: in std_logic;
KEY: in std_logic_vector(0 downto 0);
SW: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
CLOCK_50: IN STD_LOGIC;
CLK: OUT STD_LOGIC;
HEX0,HEX1,HEX2,HEX3,HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

);
end smartt;

architecture beh of smartt is

type state_type is (S0,S1,S2,S3,S4,E4,E1,E2,E3,L1,L2,L3,L4);
signal present_state,next_state: state_type;
SIGNAL FAIL,PASS: STD_LOGIC;
SIGNAL H: INTEGER RANGE 0 TO 13:=0;
signal swi: std_logic_vector(9 downto 0);
signal count:integer range 0 to 3:=0;

 SIGNAL COUNTER: INTEGER:= 0;
 SIGNAL DIVIDER:STD_LOGIC:='0';
begin
LEDR <= SW(4 DOWNTO 1);

process(CLOCK_50,SW(0))
begin

if(SW(0)='1') then
          present_state<= S0;

elsif CLOCK_50' event and CLOCK_50='1' then
          COUNTER<= COUNTER +1;
          present_state<= next_state;
  IF (COUNTER =49999999) THEN
  DIVIDER<= NOT DIVIDER;
  COUNTER<=0;
  END IF;
end if;
CLK<= DIVIDER;
end process;


process(SW,present_state)
begin

case present_state is
when S0 =>
         
         H<=0;  
           
        if (SW(1)= '1' and count<3)then
             next_state<= S1;
          
           elsif(count>= 3) then
              next_state <=L1;
        else 
           next_state<=E1;
             end if;
 
when  S1 =>
               H<=1;
               --swi<="0000000000";
            if SW(2)= '1' then
               next_state<= S2;
           else
               next_state <=E2;
           end if;
when  S2 =>
               H<=2;
           if SW(3)= '1' then
              next_state<= S3;
           else
             next_state <=E3;
          end if;
 when S3 =>
            H<=3;
          if SW(4)= '1' then
             next_state<= S4;
          else
             next_state <=E4;
          end if;
when S4 =>
            H<=4;
         if SW(1)= '1' then
         
            next_state<= S0;
         else
           next_state <=S0;
         end if;
        -- swi<=sw;
when E1=>
            H<=5;
        next_state<= E2;
when E2=>
          H<=6;
        next_state<= E3;

when E3=>
             H<=7;
        next_state<= E4;

when E4=>
           H<=8;
        --if SW(1)= '1' then
          --next_state<= S0;
        --else
          next_state <=S0;
        --end if;
when  L1 =>
         H<=10;
         if SW(6)= '1' then
              next_state<= L2;
           else
             next_state <=E1;
          end if;
when  L2 =>
           H<=11;
            if SW(7)= '1' then
              next_state<= L3;
           else
             next_state <=E2;
          end if;
when  L3 =>
           H<=12;   
           if SW(8)= '1' then
              next_state<= L4;
           else
             next_state <=E3;
          end if;
when  L4 =>
           H<=13;   
           if SW(9)= '1' then
              next_state<= S4;
           else
             next_state <=E4;
          end if;       
when others =>
          next_state<= S0;
 
 end case;
 end process;
 
 process(present_state)
 begin
 
  if present_state=S4 then
      PASS<='1';
      --count<=0;
 else 
        PASS<='0';
 end if;
 
 if present_state=E4 then
        FAIL<='1';
        count<=count+1;
 else
        FAIL<='0';
 end if;
 end process;
 PROCESS(PASS,FAIL,H,SW)
 BEGIN
 if(SW(0)='1') THEN 
  HEX4<= "1111111";
     HEX3<= "0111111";
     HEX2<= "0111111";
     HEX1<= "0111111";
     HEX0<= "0111111";
  elsIF (SW(9 DOWNTO 0)="0000000000") THEN 
     HEX4<= "1111111";
     HEX3<= "0111111";
     HEX2<= "0111111";
     HEX1<= "0111111";
     HEX0<= "0111111";
       
 ELSIF(H=0 OR H=10 ) THEN
     case (SW(9 DOWNTO 0)) IS
     when "0000000010" => HEX3<= "1111001";
    when "0000000100" => HEX3<= "0101000";
    when "0000001000" => HEX3<= "1001111";
    when "0000010000" => HEX3<= "0011001";
    when "0000100000" => HEX3<= "0010010";
    when "0001000000" => HEX3<= "0000010";
    when "0010000000" => HEX3<= "0110000";
    when "0100000000" => HEX3<= "0000000";
    when "1000000000" => HEX3<= "0010000";
    WHEN OTHERS=> NULL ;
        END CASE;
 ELSIF(H=1 OR H=5 OR H=11) then
     case (SW(9 DOWNTO 0)) IS
     when "0000000000" => HEX2<= "0111111";
     when "0000000010" => HEX2<= "0101000";
    when "0000000100" => HEX2<= "1001111";
    when "0000001000" => HEX2<= "1001111";
    when "0000010000" => HEX2<= "0011001";
    when "0000100000" => HEX2<= "0010010";
    when "0001000000" => HEX2<= "0000010";
    when "0010000000" => HEX2<= "0111000";
    when "0100000000" => HEX2<= "0000000";
    when "1000000000" => HEX2<= "0010000";
   
    WHEN OTHERS=> NULL ;
        END CASE;
  ELSIF(H=2 OR H=6 OR H=12) then
     case (SW(9 DOWNTO 0)) IS
    when "0000000000" => HEX2<= "0111111";
     when "0000000010" => HEX1<= "1111001";
    when "0000000100" => HEX1<= "0101000";
    when "0000001000" => HEX1<= "1001111";
    when "0000010000" => HEX1<= "0011001";
    when "0000100000" => HEX1<= "0010010";
    when "0001000000" => HEX1<= "0000010";
    when "0010000000" => HEX1<= "0110000";
    when "0100000000" => HEX1<= "0000000";
    when "1000000000" => HEX1<= "0010000";
    WHEN OTHERS=> NULL ;
        END CASE;
 ELSIF(H=3 OR H=7 OR H=13) then
     case (SW(9 DOWNTO 0)) IS
    when "0000000000" => HEX2<= "0111111";
     when "0000000010" => HEX0<= "1111001";
    when "0000000100" => HEX0<= "0101000";
    when "0000001000" => HEX0<= "1001111";
    when "0000010000" => HEX0<= "0011001";
    when "0000100000" => HEX0<= "0010010";
    when "0001000000" => HEX0<= "0000010";
    when "0010000000" => HEX0<= "0110000";
    when "0100000000" => HEX0<= "0000000";
    when "1000000000" => HEX0<= "0010000";
    WHEN OTHERS=> NULL ;
        END CASE;
          
ELSIF(PASS='1') THEN
      HEX3<= "0001100";
       HEX2<= "0001000";
      HEX1<= "0010010";
      HEX0<= "0010010";
ELSIF(FAIL='1') THEN
      HEX3<= "0001110";
      HEX2<= "0001000";
      HEX1<= "1111001";
      HEX0<= "1000111";
ELSIF(count>=3) THEN
      HEX4<= "1000111";
      HEX3<= "1000000";
      HEX2<= "1000110";
      HEX1<= "0000110";
      HEX0<= "0100001";



ELSE 
      HEX3<= "0111111";
       HEX2<= "0111111";
       HEX1<= "0111111";
       HEX0<= "0111111";
     HEX4<= "1111111";
   
  END IF;
  END PROCESS;
 
 
 end beh;