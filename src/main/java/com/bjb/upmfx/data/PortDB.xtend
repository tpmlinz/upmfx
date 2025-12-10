package com.bjb.upmfx.data

import com.fazecast.jSerialComm.SerialPort
import org.eclipse.xtend.lib.annotations.Accessors

class PortDB {
	
//	static val ports = <String, PortParameters>newHashMap()
//	
//	def get(String systemName){ ports.get(systemName) }
//	def put(String systemName, PortParameters parameters){ ports.put(systemName, parameters) }
	@Accessors
	var SerialPort port
	
	static def getInstance(){ return instance }
	
	private new(){}	
	private static val instance = new PortDB
}