package com.bjb.upmfx.data;

import java.util.Arrays;

public enum BAUD {

	BR_9600(9600), 
	BR_19200(19200), 
	BR_28800(28800), 
	BR_38400(38400), 
	BR_57600(57600), 
	BR_76800(76800), 
	BR_115200(115200), 
	BR_230400(230400), 
	BR_460800(460800), 
	BR_576000(576000), 
	BR_921600(921600);	

	private final int value;
	
	private BAUD(int value){ this.value = value; }
	
	@Override
	public String toString() { return Integer.toString(value); }
	
	public int getValue() { return value; }
	
	static public BAUD fromValue(int value) {
		return Arrays.stream(BAUD.values()).filter(b -> b.value == value).findFirst().orElse(null);	
	}
	
}
