LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FPGAWR_DSPRE_tb IS 
END FPGAWR_DSPRE_tb;

ARCHITECTURE TESTBENCH_ARCH OF FPGAWR_DSPRE_tb IS

COMPONENT FPGAWR_DSPRE_CTRL
PORT (
        SYS_CLK     : IN     STD_LOGIC;
--		SYS_RST_N   : IN     STD_LOGIC;
        XA          : IN     STD_LOGIC_VECTOR(11 DOWNTO 0);
        XZCS_7      : IN     STD_LOGIC;
        XRD         : IN     STD_LOGIC;
 
        WREN_A      : BUFFER STD_LOGIC := '0';
        RDEN_A      : BUFFER STD_LOGIC := '0';
        ADDRESS_A   : BUFFER STD_LOGIC_VECTOR(11 DOWNTO 0);

        RAMA_FULL   : BUFFER STD_LOGIC
    );
END COMPONENT;

SIGNAL SYS_CLK     : STD_LOGIC;
--SIGNAL SYS_RST_N   : STD_LOGIC := '1';
SIGNAL XA          : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
SIGNAL XZCS_7      : STD_LOGIC := '1';
SIGNAL XRD         : STD_LOGIC := '1';
SIGNAL RDEN_A      : STD_LOGIC := '0';
SIGNAL WREN_A      : STD_LOGIC := '0';
SIGNAL ADDRESS_A   : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
SIGNAL RAMA_FULL   : STD_LOGIC := '0';

SIGNAL COUNTER_A   : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";

CONSTANT CLK_PERIOD : TIME := 33 NS;
BEGIN

INSTANT: FPGAWR_DSPRE_CTRL PORT MAP
	(
        SYS_CLK     =>SYS_CLK,
--        SYS_RST_N   =>SYS_RST_N,
		XA          =>XA,
		XZCS_7		=>XZCS_7,
		XRD			=>XRD,
        RDEN_A		=>RDEN_A,
        WREN_A	    =>WREN_A,
        ADDRESS_A   =>ADDRESS_A,
        RAMA_FULL	=>RAMA_FULL
	);
									 
CLK_IN: PROCESS
BEGIN
    SYS_CLK <= '0';
	WAIT FOR CLK_PERIOD/2;
    SYS_CLK <= '1';
	WAIT FOR CLK_PERIOD/2;
END PROCESS;

--RESET_IN: PROCESS
--BEGIN
--    SYS_RST_N <= '0';
--	WAIT FOR 500 NS;
--    SYS_RST_N <= '1';
--	WAIT FOR 999999999 NS;
--END PROCESS;

PROCESS
BEGIN
    XZCS_7 <= '1';
    XRD    <= '1';
	WAIT FOR 200 NS;
    XZCS_7 <= '0';
    XRD    <= '0';
	WAIT FOR 200 NS;
END PROCESS;

--PROCESS(SYS_CLK)
--BEGIN
----    IF(SYS_RST_N='0') THEN 
----        XZCS_7 <= '1';
----        XRD    <= '1';
--    IF(XZCS_7'EVENT AND XZCS_7='0') THEN
----    	IF((COUNTER_A>="100000000000")AND(COUNTER_A<="111111111111")) THEN
--    	IF(COUNTER_A="111111111111") THEN
--            COUNTER_A <= "000000000000";
--    	ELSE
--            COUNTER_A <= COUNTER_A + '1';
--    	END IF;
--    END IF;
--END PROCESS;

PROCESS(XRD)
BEGIN
--    IF(XZCS_7='0') THEN
		IF(XRD'EVENT AND XRD = '0') THEN
    	    IF(XA="011111111111") THEN
                XA <= "000000000000";
    	    ELSE
                XA <= XA + '1';
            END IF;
		END IF;
--	END IF;
END PROCESS;


--PROCESS(XZCS_7)
--BEGIN
----    IF(SYS_RST_N='0') THEN 
----        XA <= "000000000000";
----    IF(SYS_CLK'EVENT AND SYS_CLK='1') THEN
----        IF((XZCS_7='0')AND(XRD='0')) THEN
--    IF((COUNTER_A>="100000000000")AND(COUNTER_A<="111111111111")) THEN
--		IF(XZCS_7'EVENT AND XZCS_7='0') THEN
--    	    IF(XA="011111111111") THEN
--                XA <= "000000000000";
--    	    ELSE
--                XA <= XA + '1';
--            END IF;
--    	END IF;
--    END IF;
--END PROCESS;


END TESTBENCH_ARCH;
