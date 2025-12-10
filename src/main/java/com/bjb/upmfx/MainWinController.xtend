package com.bjb.upmfx

import com.bjb.upmfx.data.BAUD
import com.bjb.upmfx.data.DATABITS
import com.bjb.upmfx.data.PARITY
import com.bjb.upmfx.data.STOPBITS
import com.bjb.upmfx.view.MainView
import com.bjb.upmfx.wire.SetCelcius
import com.bjb.upmfx.wire.SetPumpSpeed
import com.fazecast.jSerialComm.SerialPort
import java.util.function.Consumer
import javafx.collections.FXCollections
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.control.ChoiceBox
import javafx.scene.control.Label
import javafx.scene.control.ListView
import javafx.scene.control.Slider
import javafx.scene.layout.VBox
import com.google.inject.Inject
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.Logger
import com.bjb.upmfx.data.DefaultPortParameters

class MainWinController {
	
    @Inject MainView mainView
    
    static val Logger logger = LogManager::getLogger(MainWinController)		
    
	
	@FXML
	var VBox connectingVBox
	
	@FXML
	var VBox connectedVBox
	
	@FXML
	var ChoiceBox<SerialPort> portChoiceBox
	 	
	@FXML
	var ChoiceBox<BAUD> baudrateChoiceBox
		
	@FXML
	var ChoiceBox<PARITY> parityChoiceBox
		
	
	@FXML
	var ChoiceBox<STOPBITS> stopBitsChoiceBox
	
	@FXML
	var ChoiceBox<DATABITS> dataBitsChoiceBox	
	
	@FXML
	var Button connectButton
	
	@FXML
	var Button disconnectButton
	
	@FXML
	var ListView<String> messageListView
	
	@FXML
	var Slider pumpSpeedSlider	
	
	@FXML
	var Slider celsiusSlider
	
	@FXML
	var Label dutyCycleLabel
	
	@FXML
	var Label pwmEnabledLabel
	
	@FXML
	var Label celsiusLabel
	
	@FXML
	var Label pumpSpeedLabel
	
	@FXML
	var Label connectionStatusLabel
	
	@FXML
	var Label systemStatusLabel
	
	
	@FXML
	def void onConnect(){
		
		if(mainView.connect){	
			info('''connected to «port.systemPortName»''')									
			logger.info('''connected to «port.systemPortName»''')		
			connectingVBox.visible = false
			connectedVBox.visible = true			
		}
		else{
			val str = port?.systemPortName ?: "null"
			logger.info('''failed to connect to «str»''')			
		}						
	}
	
	
	@FXML
	def void onDisconnect(){
		if(mainView.disconnect){
			info('''disconnected from «port.systemPortName»''')
			logger.info('''disconnected from «port.systemPortName»''')			
		}					
		connectedVBox.visible = false
		connectingVBox.visible = true		
	}
	
	
	@FXML
    def void initialize() { 
    	
    	logger.debug("MainWinController initialize")   	 
    	
    	messageListView.items = mainView.infoEntries    	   	   
    	    	
    	portChoiceBox.setItems(mainView.serialPorts)
    	if(!portChoiceBox.items.empty){ portChoiceBox.value = portChoiceBox.items.get(0) }    	
    	
    	baudrateChoiceBox.setItems(FXCollections.observableArrayList(BAUD.values))
    	baudrateChoiceBox.setValue(DefaultPortParameters::PARAMETERS.baudRate);
    	    	    	
    	parityChoiceBox.setItems(FXCollections.observableArrayList(PARITY.values))
    	parityChoiceBox.setValue(DefaultPortParameters::PARAMETERS.parity)
    	    	
    	stopBitsChoiceBox.setItems(FXCollections.observableArrayList(STOPBITS.values))
    	stopBitsChoiceBox.setValue(DefaultPortParameters::PARAMETERS.stopBits) 
    	
    	dataBitsChoiceBox.setItems(FXCollections.observableArrayList(DATABITS.values))
    	dataBitsChoiceBox.setValue(DefaultPortParameters::PARAMETERS.dataBits)  
		
		
		mainView.pumpSpeedProperty.addListener[obs, oldVal, newVal |
			if(newVal !== null)									
				serialThread.sendMessage(new SetPumpSpeed(newVal))]

		
		mainView.celsiusProperty.addListener[obs, oldVal, newVal | 
			if(newVal !== null)				
				serialThread.sendMessage(new SetCelcius(newVal))]	
		
		
		mainView.serialPortProperty.bind(portChoiceBox.valueProperty)
		mainView.celsiusDoubleProperty.bind(celsiusSlider.valueProperty)
		mainView.pumpSpeedDoubleProperty.bind(pumpSpeedSlider.valueProperty)
		
		celsiusLabel.textProperty.bind(mainView.celsiusLabelProperty)
		pumpSpeedLabel.textProperty.bind(mainView.pumpSpeedLabelProperty)	 
		dutyCycleLabel.textProperty.bind(mainView.dutyCycleLabelProperty)	
		pwmEnabledLabel.textProperty.bind(mainView.enabledPWMLabelProperty)			
		connectionStatusLabel.textProperty.bind(mainView.connectionStatusLabelProperty)
		systemStatusLabel.textProperty.bind(mainView.systemStatusLabelProperty)
		
		connectButton.disableProperty.bind(mainView.connectedProperty.or(mainView.serialPortProperty.isNull))
		disconnectButton.disableProperty.bind(connectButton.disableProperty.not)
    }           
    
    //private def getMainView(){ MainView::instance }        
    private def getPort(){ mainView.serialPort }         
    private def getSerialThread(){ mainView.serialThread }        
    private def info(String text){ mainView.info(text) }
}