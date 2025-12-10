package com.bjb.upmfx.wire

interface MessageID {
		
	public static val byte SET_PUMP_SPEED	= 1 as byte
	public static val byte SET_CELSIUS		= 2 as byte
	public static val byte SET_ALL			= 3 as byte
	public static val byte UPM3_STATUS		= 128 as byte			
}