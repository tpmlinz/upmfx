package com.bjb.upmfx.wire

import com.google.inject.AbstractModule
import com.google.inject.Singleton

class WireModule extends AbstractModule {	
	protected override configure(){
		bind(SerialPortThread).in(Singleton)		
	}
}