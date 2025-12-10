package com.bjb.upmfx.data

interface DefaultPortParameters {	
	public static val PARAMETERS = new PortParameters(BAUD::BR_115200, DATABITS::DATABITS_8, STOPBITS::ONE, PARITY::NO_PARITY)
}