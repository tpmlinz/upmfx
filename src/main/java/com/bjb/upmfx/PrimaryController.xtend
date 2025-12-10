package com.bjb.upmfx

import java.io.IOException

import javafx.collections.FXCollections
import javafx.fxml.FXML
import javafx.scene.control.ChoiceBox

import com.fazecast.jSerialComm.SerialPort
import com.bjb.upmfx.data.PARITY
import com.bjb.upmfx.data.STOPBITS
import com.bjb.upmfx.data.BAUD
import com.bjb.upmfx.data.DATABITS
import com.bjb.upmfx.data.PortDB

public class PrimaryController {
	
	private static val DEFAULT_STOPBITS = STOPBITS::ONE;
	private static val DEFAULT_PARITY = PARITY::NO_PARITY;
	private static val DEFAULT_BAUDRATE = BAUD::BR_115200;
	private static val DEFAULT_DATABITS = DATABITS::DATABITS_8;
	
	
	
	@FXML
	var ChoiceBox<SerialPort> serialPortsChoiceBox
	 	
	@FXML
	var ChoiceBox<BAUD> baudrateChoiceBox
		
	@FXML
	var ChoiceBox<PARITY> parityChoiceBox
		
	
	@FXML
	var ChoiceBox<STOPBITS> stopBitsChoiceBox
	
	@FXML
	var ChoiceBox<DATABITS> dataBitsChoiceBox
	
	
	@FXML
    def void onSerialPortsShowing() {    	
//    	println("onSerialPortsShowing")    	
//    	serialPortsChoiceBox.getItems().setAll(serialPorts)
//    	serialPortsChoiceBox.setValue(port)
    }	
    
    @FXML
    def void onSerialPortAction(){
    	val p = serialPortsChoiceBox.value
    	if(p !== null){
    		baudrateChoiceBox.value = BAUD::fromValue(p.baudRate)
    		parityChoiceBox.value = PARITY::fromValue(p.parity)
    		stopBitsChoiceBox.value = STOPBITS::fromValue(p.numStopBits)
    		dataBitsChoiceBox.value = DATABITS::fromValue(p.numDataBits)		 		
    	}	
    }
    
    @FXML
    def void onBaudrateAction(){ baudRate = baudrateChoiceBox.value }
    
    @FXML
    def void onParityAction(){ parity = parityChoiceBox.value }
     
    @FXML
    def void onStopBitsAction(){ stopBits = stopBitsChoiceBox.value }
	
	@FXML
	def void onDataBitsAction(){ dataBits = dataBitsChoiceBox.value }

    @FXML
    def void switchToSecondary() throws IOException {
    	
//    	if(port !== null)
//    		println('''opening «port.systemPortPath» b:«port.baudRate» d:«port.numDataBits» p:«port.parity» s:«port.numStopBits»''')
//    	else
//    		return;
//    	
//		if(port.openPort(500)){
//			PortDB::instance.port = port;
//        	App.setRoot("secondary")        	
//        }
//        else{
//        	println('''failed to open «port.systemPortName»''')
//        }
		App.setRoot("secondary")        	

    }
     
   
    //static val DB = new PortDB;              
    //private def PortParameters getPortParameters(){ DB.get(serialPortsChoiceBox.value?.systemPortName); }
    def getPort(){ serialPortsChoiceBox.value }
    
    
    private def getBaudRate(){ if(port !== null) BAUD::fromValue(port.baudRate) else DEFAULT_BAUDRATE }
    private def setBaudRate(BAUD baud){ if(port !== null) port.baudRate = baud.value }
    
    private def getParity(){ if(port !== null) PARITY::fromValue(port.parity) else DEFAULT_PARITY }
    private def setParity(PARITY parity){ if(port !== null) port.parity = parity.value }
        
    private def getStopBits(){ if(port !== null) STOPBITS::fromValue(port.numStopBits) else DEFAULT_STOPBITS }
    private def setStopBits(STOPBITS stopbits){ if(port !== null) port.numStopBits = stopbits.value }
    
	private def getDataBits(){ if(port !== null) DATABITS::fromValue(port.numDataBits) else DEFAULT_DATABITS }
	private def setDataBits(DATABITS databits){ if(port !== null) port.numDataBits = databits.value }
    
    
    
    @FXML
    def void initialize() {        	
    	    	
    	serialPortsChoiceBox.setItems(FXCollections.observableArrayList(SerialPort::commPorts))
    	serialPortsChoiceBox.setValue(port)    	
    	
    	baudrateChoiceBox.setItems(FXCollections.observableArrayList(BAUD.values))
    	baudrateChoiceBox.setValue(baudRate);
    	    	    	
    	parityChoiceBox.setItems(FXCollections.observableArrayList(PARITY.values))
    	parityChoiceBox.setValue(parity)
    	    	
    	stopBitsChoiceBox.setItems(FXCollections.observableArrayList(STOPBITS.values))
    	stopBitsChoiceBox.setValue(stopBits) 
    	
    	dataBitsChoiceBox.setItems(FXCollections.observableArrayList(DATABITS.values))
    	dataBitsChoiceBox.setValue(DEFAULT_DATABITS)       	
    }    
}