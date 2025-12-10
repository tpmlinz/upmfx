package com.bjb.upmfx.view

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.function.Consumer
import javafx.beans.property.SimpleObjectProperty
import com.fazecast.jSerialComm.SerialPort
import javafx.beans.property.SimpleStringProperty
import javafx.beans.property.SimpleDoubleProperty
import javafx.beans.property.SimpleBooleanProperty
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import com.bjb.upmfx.data.DATABITS
import com.bjb.upmfx.data.PARITY
import com.bjb.upmfx.data.STOPBITS
import com.bjb.upmfx.data.BAUD
import javafx.beans.binding.Bindings
import com.bjb.upmfx.wire.SerialPortThread
import com.bjb.upmfx.wire.MessageID
import com.bjb.upmfx.wire.UPM3Status
import com.bjb.upmfx.wire.Message
import com.bjb.upmfx.wire.MessageRecorder
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import com.google.inject.Singleton
import com.google.inject.Inject
import java.util.function.Supplier

@Singleton
class MainView {
	
	//@Inject 
	val SerialPortThread serialThread
	
	
	static val Logger logger = LogManager::getLogger(MainView)		
	
		
	static val NOT_CONNECTED_STRING = "not connected"
	static val MAX_INFO_MSGS = 10
	
	//@Accessors(PUBLIC_GETTER)
	//val serialThread = new SerialPortThread	
	
	def getSerialThread(){ serialThread }	
	
	// Derivd connected property
	val connectedProperty = new SimpleBooleanProperty(false)
	def final getConnected(){ connectedProperty.get }
	def final setConnected(boolean flag){ connectedProperty.value = flag }
	def final connectedProperty(){ connectedProperty }
	
	// Serial port property
	val serialPortProperty = new SimpleObjectProperty<SerialPort>
	def final getSerialPort(){ serialPortProperty.get }
	def final setSerialPort(SerialPort port){ serialPortProperty.value = port }
	def final serialPortProperty(){ serialPortProperty }
	
	// Info handler property
	val infoHandlerProperty = new SimpleObjectProperty<Consumer<String>>	
	def final getInfoHandler(){ infoHandlerProperty.get }
	def final setInfoHandler(Consumer<String> handler){ infoHandlerProperty.value = handler }
	def final infoHandlerProperty(){ infoHandlerProperty }	
	
	def final info(String text){ infoHandler?.accept(text) }
	
	// Celsius as a double property bound to sliders
	val celsiusDoubleProperty = new SimpleDoubleProperty(0.0)
	def final getCelsiusDouble(){ celsiusDoubleProperty.get }
	def final setCelsiusDouble(double value){ celsiusDoubleProperty.value = value }
	def final celsiusDoubleProperty(){ celsiusDoubleProperty }
	
	// Celsius as a byte property bound to celsiusDoubleProperty
	val celsiusProperty = new SimpleObjectProperty<Byte>	
	def final getCelsius(){ celsiusProperty.get }
	def final setCelsius(byte celsius){ celsiusProperty.value = celsius }
	def final celsiusProperty(){ celsiusProperty }
	
	// Celsius as a String property
	val celsiusLabelProperty = new SimpleStringProperty	
	def final getCelsiusLabel(){ celsiusLabelProperty.get }
	def final setCelsiusLabel(String str){ celsiusLabelProperty.value = str }
	def final celsiusLabelProperty(){ celsiusLabelProperty }
	
	
	// Pump speed as a double property bound to slider
	val pumpSpeedDoubleProperty = new SimpleDoubleProperty(0.0)	
	def final getPumpSpeedDouble(){ pumpSpeedDoubleProperty.get }
	def final setPumpSpeedDouble(double speed){ pumpSpeedDoubleProperty.value = speed }
	def final pumpSpeedDoubleProperty(){ pumpSpeedDoubleProperty }
	
	// Pump speed as byte bound to pumpSpeedDoubleProperty
	val pumpSpeedProperty = new SimpleObjectProperty<Byte>	
	def final getPumpSpeed(){ pumpSpeedProperty.get }
	def final setPumpSpeed(byte speed){ pumpSpeedProperty.value = speed }
	def final pumpSpeedProperty(){ pumpSpeedProperty }
	
	// PumpSpeed as a string property
	val pumpSpeedLabelProperty = new SimpleStringProperty
	def final getPumpSpeedLabel(){ pumpSpeedLabelProperty.get }
	def final setPumpSpeedLabel(String str){ pumpSpeedLabelProperty.value = str }
	def final pumpSpeedLabelProperty(){ pumpSpeedLabelProperty }
	
	// PWM enabled boolean property
	val enabledPWMProperty = new SimpleObjectProperty<Boolean>
	def final getEnabledPWM(){ enabledPWMProperty.get }
	def final setEnabledPWM(boolean state){ enabledPWMProperty.value = state }
	def final enabledPWMProperty(){ enabledPWMProperty }
	
	// PWM enabled as a string property bound to enabledPWMProperty
	val enabledPWMLabelProperty = new SimpleStringProperty
	def final getEnabledPWMLabel(){ enabledPWMLabelProperty.get }
	def final setEnabledPWMLabel(String text){ enabledPWMLabelProperty.value = text }
	def final enabledPWMLabelProperty(){ enabledPWMLabelProperty }
	
	// PWM duty cycle as a byte property
	val dutyCyclePWMProperty = new SimpleObjectProperty<Byte>
	def final getDutyCyclePWM(){ dutyCyclePWMProperty.get }
	def final setDutyCyclePWM(byte duty){ dutyCyclePWMProperty.value = duty }
	def final dutyCyclePWMProperty(){ dutyCyclePWMProperty }	
	
	// PWM duty cycle as a String property bound to dutyCyclePWMProperty
	val dutyCycleLabelProperty = new SimpleStringProperty
	def final getDutyCycleLabel(){ dutyCycleLabelProperty.get }
	def final setDutyCycleLabel(String text){ dutyCycleLabelProperty.value = text }
	def final dutyCycleLabelProperty(){ dutyCycleLabelProperty }
	
	val connectionStatusLabelProperty = new SimpleStringProperty(NOT_CONNECTED_STRING)
	def final getConnectionStatusLabel(){ connectionStatusLabelProperty.get }
	def final setConnectionStatusLabel(String text){ connectionStatusLabelProperty.value = text }
	def final connectionStatusLabelProperty(){ connectionStatusLabelProperty }
	
	val systemStatusLabelProperty = new SimpleStringProperty
	def final getSystemStatusLabel(){ systemStatusLabelProperty.get }
	def final setSystemStatusLabel(String str){ systemStatusLabelProperty.value = str }
	def final systemStatusLabelProperty(){ systemStatusLabelProperty }
	
	
	@Accessors(PUBLIC_GETTER)
	val ObservableList<SerialPort> serialPorts
	
	@Accessors(PUBLIC_GETTER)	
	val infoEntries = FXCollections.<String>observableArrayList
	
	//FIXME inject this
	@Accessors(PUBLIC_GETTER)		
	val messageRecoder = new MessageRecorder
			
	def refreshSerialPorts(){ serialPorts.setAll(SerialPort::commPorts) }
	
	def boolean connect(){ 
		val state =	serialPort !== null && serialPort.open 
		connected = state
		state
	}
	
	
	def boolean disconnect(){ 
		val state = if(serialPort !== null && serialPort.isOpen) serialPort.closePort else false
		connected = false		
		state
	}
	
		
	new(){
		
		//	Supplier<SerialPort> portProvider, 
//			Consumer<Message> messageRecorder, 
//			Consumer<String> infoHandler,
//			Consumer<Message> receiver
		
//		val Supplier<SerialPort> pp = [getSerialPort]
//		val Consumer<Message> mr = [msg | messageRecoder.recordMessage(msg)]
//		val Consumer<Message> rx = [msg | onReceivedMessage(msg)]							
		
		logger.info("MainView constructor")
				
		serialPorts = FXCollections.observableArrayList(SerialPort::commPorts)
		
		infoHandler = [text |
			if(infoEntries.size >= MAX_INFO_MSGS)
    			infoEntries.removeFirst
    		infoEntries.add(text)]
    		
		
		{
			val binding = Bindings::createStringBinding([String::valueOf(enabledPWM)], enabledPWMProperty)
			enabledPWMLabelProperty.bind(binding)
		}
		
		{
			val binding = Bindings::createStringBinding([String::valueOf(dutyCyclePWM)], dutyCyclePWMProperty)
			dutyCycleLabelProperty.bind(binding)
		}
			
		{
			val binding = Bindings::createObjectBinding([Math::round(pumpSpeedDouble) as byte], pumpSpeedDoubleProperty)
			pumpSpeedProperty.bind(binding) 	
		}
		
		{
			val binding = Bindings::createObjectBinding([String::valueOf(pumpSpeed)], pumpSpeedProperty)
			pumpSpeedLabelProperty.bind(binding)
		}
		
		
		{
			val binding = Bindings::createObjectBinding([Math::round(celsiusDouble) as byte], celsiusDoubleProperty)
			celsiusProperty.bind(binding)
		}
		
		{
			val binding = Bindings::createStringBinding([String::valueOf(celsius)], celsiusProperty)
			celsiusLabelProperty.bind(binding)
		}
		
		{
			val binding = Bindings::createStringBinding([createConnectionStatusString], connectedProperty)
			connectionStatusLabelProperty.bind(binding)
		
		}
		
		{
			val binding = Bindings::createStringBinding([createSystemStatusString], enabledPWMProperty, dutyCyclePWMProperty, pumpSpeedProperty, celsiusProperty)		
			systemStatusLabelProperty.bind(binding)		
		}
		
		this.serialThread = new SerialPortThread(
			[getSerialPort],
			[msg | messageRecoder.recordMessage(msg)],
			infoHandler,
			[msg | onReceivedMessage(msg)]
		)		
		
		serialThread.start
		
	}	
	
	private def dispatch onReceivedMessage(Void none){ logger.warn("null Message") }			
	private def dispatch onReceivedMessage(Object obj){ logger.fatal("unknown object received as message") }				
	private def dispatch onReceivedMessage(Message msg){ logger.warn('''unhandled Message with id:«msg.id»''') }
		
	private def dispatch onReceivedMessage(UPM3Status msg){
		dutyCyclePWM = msg.dutyCycle
    	enabledPWM = if(msg.pwmEnable != 0) true else false 
	}
	
	
	private def String createSystemStatusString(){
		val enableStr = String::valueOf(enabledPWM)
		val dutyStr = String::valueOf(dutyCyclePWM)
		val celsiusStr = String::valueOf(celsius)
		val pumpSpeedStr = String::valueOf(pumpSpeed)
		
		'''E:«enableStr»    D:«dutyStr»    S:«pumpSpeedStr»    C:«celsiusStr»'''
	}
	
	
	private def String createConnectionStatusString(){
		if(serialPort !== null){
			val name = serialPort.systemPortName
			val baud = BAUD::fromValue(serialPort.baudRate)
			val stopbits = STOPBITS::fromValue(serialPort.numStopBits)
			val databits = DATABITS::fromValue(serialPort.numDataBits)
			val parity = PARITY::fromValue(serialPort.parity)
			'''«name» «baud» «databits» «parity» «stopbits»'''
		}
		else
			NOT_CONNECTED_STRING		
	}
}


