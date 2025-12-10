package com.bjb.upmfx.data

import org.eclipse.xtend.lib.annotations.Accessors

class PortParameters {
	
	@Accessors
	var STOPBITS stopBits = STOPBITS::ONE
	
	@Accessors	
	var DATABITS dataBits = DATABITS::DATABITS_8
	
	@Accessors
	var PARITY parity = PARITY::NO_PARITY
	
	@Accessors	
	var BAUD baudRate = BAUD::BR_115200
}