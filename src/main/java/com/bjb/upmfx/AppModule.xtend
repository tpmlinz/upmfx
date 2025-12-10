package com.bjb.upmfx

import com.bjb.upmfx.view.MainView
import com.google.inject.AbstractModule
import com.google.inject.Singleton

class AppModule extends AbstractModule{
	
	protected override configure(){
		
		//bind(SerialPortThread).in(Singleton)
		bind(MainView).in(Singleton)		
		
		//install(new ViewModule)
		//install(new WireModule)
	}		
	//org.apache.log4j.Logger
}