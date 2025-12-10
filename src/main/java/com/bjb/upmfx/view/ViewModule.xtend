package com.bjb.upmfx.view

import com.google.inject.AbstractModule
import com.google.inject.Singleton
import com.bjb.upmfx.wire.SerialPortThread

class ViewModule extends AbstractModule {
	
	protected override configure(){
		bind(MainView).in(Singleton)
		//bind(SerialPortThread).in(Singleton)
	}
}
