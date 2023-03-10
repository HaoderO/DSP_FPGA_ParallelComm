LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
ENTITY  READ1 IS
PORT
	(
		CLK	    	: IN 	STD_LOGIC;
		EN 	    	: IN    STD_LOGIC;
		CONVENT1  	: IN    STD_LOGIC;
		BUSY      	: IN	STD_LOGIC;
		FIRSTDATA 	: IN	STD_LOGIC;
		INDATA	 	: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		RD    	 	: OUT   STD_LOGIC;
		OUTDATA	 	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		STARTREAD1	: OUT 	STD_LOGIC;
		ADDRESS	 	: OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY READ1;

ARCHITECTURE ART OF READ1 IS

SIGNAL FLAG  		:	STD_LOGIC:='0'; --开始读取标志
SIGNAL RD1   		:	STD_LOGIC:='1'; --读取标志
SIGNAL READFLAG		:	STD_LOGIC:='0'; --一个通道读取完成标志
SIGNAL STARTREAD	:	STD_LOGIC:='0';--开始下一个通道读取
SIGNAL CQI   		: 	STD_LOGIC_VECTOR(3 DOWNTO 0):="0000"; --数据通道
SIGNAL DATA  		:	STD_LOGIC_VECTOR(15 DOWNTO 0):="0000000000000000"; --保存读取的数据
SIGNAL CNT   		: 	STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";--通道数据保持计数器
SIGNAL CNTRD 		: 	STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";--RD延时计数信号

BEGIN

PROCESS(EN,CLK) ---AD7606开始转换和读取AD7606信号标志
BEGIN 
	IF(CLK'EVENT AND CLK='1')THEN 
		IF(CQI="1000" AND RD1='1')THEN
			FLAG<='0';
		END IF;
		IF (EN='1')THEN
			IF(CONVENT1='1' AND BUSY='0')THEN
				FLAG<='1';
			END IF;
		ELSE
			FLAG<='0';
		END IF;
	END IF;
END PROCESS;	
	
PROCESS(EN,CLK) ---开始读取下一通道
BEGIN 
	IF(CLK'EVENT AND CLK='1')THEN 
		IF (EN='1')THEN
			IF(FLAG='1')THEN
				IF(BUSY='0')THEN
					RD1<='0';
				END IF;
			END IF;
			IF(FLAG='1')THEN
				IF(STARTREAD = '1')THEN
					RD1<='0';
				END IF;
			END IF;
			IF(READFLAG='1')THEN
				RD1<='1';
			END IF;
		ELSE
			RD1<='1';
		END IF;
	END IF;
END PROCESS;
	
PROCESS(CLK,EN)--AD7606的16位采样信号读取
BEGIN
	IF(CLK'EVENT AND CLK='1')THEN
		IF(RD1='0' AND CNTRD="0010")THEN
			DATA<=INDATA;
			READFLAG<='1';
			----------------通道计数器
			IF(CQI="1000")THEN
				CQI<="0000";
			ELSE
				CQI <= CQI + '1';
			END IF;          
			----------------通道计数器
		END IF;
		IF(STARTREAD='1')THEN
			READFLAG<='0';
		END IF;
	END IF;
END PROCESS;
	
	
PROCESS(CLK,EN)--采样保持计数器
BEGIN
	IF(CLK'EVENT AND CLK='1')THEN
		IF(EN='1' AND READFLAG='1')THEN
			IF(CNT="0011")THEN
				CNT<="0000";
				STARTREAD<='1';
			ELSE
				CNT <= CNT + '1';
			END IF;
		END IF;
		IF(EN='1' AND RD1='0')THEN
			STARTREAD<='0';
		END IF;
	END IF;
END PROCESS;
	
PROCESS(CLK,EN)--RD转换等待计数器
BEGIN
	IF(CLK'EVENT AND CLK='1')THEN
		IF(EN='1' AND RD1='0')THEN
			IF(CNTRD="0011")THEN
				CNTRD<="0000";
			ELSE
				CNTRD <= CNTRD + '1';
			END IF;
		END IF;
		IF(EN='1' AND RD1='1')THEN
			CNTRD<="0000";
		END IF;
	END IF;
END PROCESS;

RD			<=	RD1;
OUTDATA		<=	DATA;
STARTREAD1	<=	STARTREAD;
ADDRESS		<=	CQI;

END ARCHITECTURE ART;