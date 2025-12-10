package com.bjb.upmfx.data;

import java.util.Arrays;

import com.fazecast.jSerialComm.SerialPort;

public enum STOPBITS {

	ONE(SerialPort.ONE_STOP_BIT, "1 stop bit"),
	TWO(SerialPort.TWO_STOP_BITS, "2 stop bits");
	
	private final int value;
	private final String text;
	
	private STOPBITS(int value, String text){
		this.value = value;
		this.text = text;
	}
	
	@Override
	public String toString() { return text; }
	
	public int getValue() { return value; }
	
	 public static STOPBITS fromValue(int value) {
		return Arrays.stream(STOPBITS.values()).filter(b -> b.value == value).findFirst().orElse(null);	
	 }	
}
