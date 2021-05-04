LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity debouncer is
    port (
        rst             : in std_logic;
        clk             : in std_logic;
        x               : in std_logic;
        x_deb            : out std_logic;
        x_deb_falling_edge : out std_logic;
        x_deb_rising_edge  : out std_logic
    );
end debouncer;

architecture debouncerArch of debouncer is

    SIGNAL xSync                : std_logic;
    SIGNAL startTimer, timerEnd : std_logic;
  
BEGIN

    synchronizer:
    PROCESS (rst, clk)
        VARIABLE aux1: std_logic;
    BEGIN
        IF (rst='0') THEN
            aux1  := '1';
            xSync <= '1';
        ELSIF (clk'EVENT AND clk='1') THEN
            xSync <= aux1;
            aux1  := x;           
        END IF;
    END PROCESS synchronizer;

    timer:
    PROCESS (rst, clk)
        CONSTANT timeOut : std_logic_vector (19 DOWNTO 0) := "10011000100101101000";
        VARIABLE count   : std_logic_vector (19 DOWNTO 0);
    BEGIN
        IF (count=timeOut) THEN
            timerEnd <= '1';
        ELSE 
            timerEnd <= '0';
        END IF;
        IF (rst='0') THEN
            count := timeOut;
        ELSIF (clk'EVENT AND clk='1') THEN
            IF (startTimer='1') THEN
                count := (OTHERS=>'0');
            ELSIF (timerEnd='0') THEN
                count := count + 1;
            END IF;
        END IF;
    END PROCESS timer;
    
    controller:
    PROCESS (xSync, rst, clk)
        TYPE states IS (waitingPression, pressionDebouncing, waitingDepression, depressionDebouncing); 
        VARIABLE state: states;
    BEGIN 
        x_deb            <= '1';
        x_deb_falling_edge <= '0';
        x_deb_rising_edge  <= '0';
        startTimer      <= '0';
        CASE state IS
            WHEN waitingPression    =>
                IF (xSync='0') THEN
                    x_deb_falling_edge <= '1';
                    startTimer      <= '1';
            END IF;
            WHEN pressionDebouncing =>
                x_deb <= '0';
            WHEN waitingDepression  =>
                x_deb <= '0';
                IF (xSync='1') THEN
                    x_deb_rising_edge <= '1';
                    startTimer     <= '1';
                END IF;
            WHEN depressionDebouncing =>
                NULL;
            END CASE;
        IF (rst='0') THEN
            state := waitingPression;
        ELSIF (clk'EVENT AND clk='1') THEN
            CASE state IS
                WHEN waitingPression      =>
                    IF (xSync='0') THEN
                        state := pressionDebouncing;
                    END IF;
                WHEN pressionDebouncing   =>
                    IF (timerEnd='1') THEN
                        state := waitingDepression;
                    END IF;
                WHEN waitingDepression    =>
                    IF (xSync='1') THEN
                        state := depressionDebouncing;
                    END IF;
                WHEN depressionDebouncing =>
                    IF (timerEnd='1') THEN
                        state := waitingPression;
                    END IF;
            END CASE;
        END IF;
    END PROCESS controller;  

END debouncerArch;
