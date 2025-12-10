package com.bjb.upmfx.data

import javafx.util.StringConverter
import com.fazecast.jSerialComm.SerialPort

class SerialPortNameConverter extends StringConverter<SerialPort>{
	
	override fromString(String string) {
		throw new UnsupportedOperationException("Not supported")
	}
	
	override toString(SerialPort port) {
		return port?.systemPortName ?: "none"
	}
	
}
