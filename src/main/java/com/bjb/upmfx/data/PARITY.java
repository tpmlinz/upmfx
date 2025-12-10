package com.bjb.upmfx.data;

import java.util.Arrays;

import com.fazecast.jSerialComm.SerialPort;


public enum PARITY {
	
	NO_PARITY(SerialPort.NO_PARITY, "no parity"),
	ONE(SerialPort.EVEN_PARITY, "even parity"),
	TWO(SerialPort.ODD_PARITY, "odd parity");
	
	private final int value;
	private final String text;
	
	private PARITY(int value, String text){
		this.value = value;
		this.text = text;
	}
	
    @Override
	public String toString() { return text; }
    
    public int getValue() { return value; }
    
    public static PARITY fromValue(int value) {
		return Arrays.stream(PARITY.values()).filter(b -> b.value == value).findFirst().orElse(null);	
    }
}
