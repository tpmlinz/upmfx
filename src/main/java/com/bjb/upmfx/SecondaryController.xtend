package com.bjb.upmfx

import com.bjb.upmfx.data.PortDB
import com.bjb.upmfx.wire.Message
import com.bjb.upmfx.wire.SerialPortThread
import com.bjb.upmfx.wire.SetCelcius
import com.bjb.upmfx.wire.SetPumpSpeed
import java.io.IOException
import javafx.beans.value.ObservableValue
import javafx.fxml.FXML
import javafx.scene.control.Label
import javafx.scene.control.Slider

import static extension com.bjb.upmfx.data.Util.*

public class SecondaryController {
	
	var dutyCycle = 10 as byte
	var celsius = 10 as byte
	
	@FXML
	var Slider pumpSpeedSlider
	
	@FXML
	var Slider celsiusSlider
	
	@FXML
	var Label enabledLabel
	
	@FXML
	var Label pwmLabel
	
	@FXML
	private def onPumpSpeedSliderChange(ObservableValue<Number> ovn, Number before, Number after){
		println('''after:«after»''')
	}
	
	@FXML
	private def onCelsiusSliderChange(ObservableValue<Number> ovn, Number before, Number after){
		println('''after:«after»''')
	}
	
	

	
	private def getPort(){ PortDB::instance.port } 
	
	//injected
	val SerialPortThread serialThread = null//new SerialPortThread	
	
	val receiver = [Message msg |
			println(msg)	
			//serialThread.celsius = celsius
			serialThread.sendMessage(new SetCelcius(celsius))			
			serialThread.sendMessage(new SetPumpSpeed(dutyCycle))
			//serialThread.dutyCycle = dutyCycle			
			dutyCycle = ((dutyCycle.toInt + 10) % 100) as byte
			celsius = ((celsius.toInt + 8) % 100) as byte					
//			if(msg instanceof UPM3Status)
		
		]
			

    @FXML
    private def switchToPrimary() throws IOException { 
//    	serialThread.setCancelled
//    	serialThread.port = null  	
//    	port.closePort    	
        App.setRoot("primary")
    }
    
    @FXML
    def void initialize() {
//    	if(port.isOpen)
//    		println('''port «port.systemPortName» is open''')
//    	else
//    	    println('''port «port.systemPortName» is closed''')  
//    	    
//		serialThread.daemon = true    	
//    	serialThread.start    
//		serialThread.port = port
//		serialThread.receiver = receiver    	    
    	
    	//pumpSpeedSlider.valueProperty.addListener
    }
}