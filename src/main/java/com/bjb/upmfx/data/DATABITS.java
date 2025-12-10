package com.bjb.upmfx.data;

import java.util.Arrays;

public enum DATABITS {
	
	DATABITS_5(5),
	DATABITS_6(6),
	DATABITS_7(7),
	DATABITS_8(8);


	private final int value;
	
	private DATABITS(int value) { 
		this.value = value;
	}
	
	@Override
	public String toString() { return Integer.toString(value) + " bits"; }
	
	public int getValue() { return value; }
	
	static public DATABITS fromValue(int value) {
		return Arrays.stream(DATABITS.values()).filter(b -> b.value == value).findFirst().orElse(null);	
	}	
}
