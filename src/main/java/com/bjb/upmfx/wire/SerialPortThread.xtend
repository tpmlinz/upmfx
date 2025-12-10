package com.bjb.upmfx.wire

import com.fazecast.jSerialComm.SerialPort
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import java.util.function.Consumer
import java.util.function.Supplier
import javafx.application.Platform
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.Logger

import static extension com.bjb.upmfx.data.Util.*

class SerialPortThread extends Thread{
		
	
	static val Logger logger = LogManager::getLogger(SerialPortThread)		
	
	enum STATE_ID{
		WAITING_FOR_SIZE,
		WAITING_FOR_PAYLOAD
	}
	
	val scheduler = Executors::newSingleThreadScheduledExecutor
	val futures = <Byte, ScheduledFuture<?>>newHashMap	
	
	val cancelled = new AtomicBoolean(false)	
	val reset = new AtomicBoolean(false)
	
	val Supplier<SerialPort> portProvider	
	val Consumer<Message> messageRecorder	
	val Consumer<String> infoHandler
	val Consumer<Message> receiver 	
	
	
			
	def getPort(){ portProvider.get }
	
	def void setReset(){ reset.set(true) }
	def void setCancelled(){ cancelled.set(true) }

			
	static val int BUFFSIZE = 255
	val byte[] buffer = newByteArrayOfSize(BUFFSIZE)
	var currentMessageSize = 0
	var state = STATE_ID::WAITING_FOR_SIZE
	
	new(	Supplier<SerialPort> portProvider, 
			Consumer<Message> messageRecorder, 
			Consumer<String> infoHandler,
			Consumer<Message> receiver
	){
		this.portProvider = portProvider
		this.messageRecorder = messageRecorder
		this.infoHandler = infoHandler
		this.receiver = receiver
		
		if(portProvider === null)
			throw new NullPointerException("portProvider")
			
		if(messageRecorder === null)
			throw new NullPointerException("messageRecorder")
		
		if(infoHandler === null)
			throw new NullPointerException("infoHandler")
		
		if(receiver === null)
			throw new NullPointerException("receiver")
		
	}		
	
	override void run(){
		
		logger.info("SerialPortThread starting...")
		
		while(!cancelled.get){
			try{

				if(isReset) handleReset
				
				var rxed = 					
				switch(state){
					case WAITING_FOR_SIZE: readSize			
					case WAITING_FOR_PAYLOAD: readPayload	
				}
				if(!rxed)
					sleep(50)
			}
			catch (InterruptedException ex) {
				// Just stop on interrupt.
          		cancelled.set(true);          		
          	}
//			catch(Exception ex){
//				ex.printStackTrace
//				cancelled = true
//			}
		}
		logger.info("SerialPortThread finished")		
	}
	
	def void sendMessage(Message msg){
		logger.info('''SendMessag: «msg»''')		
		futures.get(msg.id)?.cancel(true)			
		futures.put(msg.id, scheduler.schedule([transmit(msg)], 200, TimeUnit::MILLISECONDS))			
	}
	
		
	
	private def handleReset(){
		currentMessageSize = 0
		state = STATE_ID::WAITING_FOR_SIZE
		reset.set(false)
	}
	
	private def readSize(){
		var rv = false
		val p = port
		if(p !== null && p.isOpen && p.bytesAvailable >= 1 && p.readBytes(buffer, 1) == 1){
			currentMessageSize = buffer.get(0).toInt
			state = STATE_ID::WAITING_FOR_PAYLOAD
			rv = true			
		}
		rv
	}
	
	private def readPayload(){
		var rv = false;
		val p = port
		if(p !== null && p.isOpen && p.bytesAvailable >= currentMessageSize && p.readBytes(buffer, currentMessageSize) == currentMessageSize){
			
			val msg = CodecRegistry::instance.decode(buffer)
			
			if(msg === null)
				info("unable to decode message")			
			else
				dispatchMessage(msg)
																		
			state = STATE_ID::WAITING_FOR_SIZE
			currentMessageSize = 0
			rv = true					
		}
		rv
	}
			
	private def dispatchMessage(Message msg){
		logger.info(msg)
		info('''rx:«msg»''')
		recordMessage(msg)					
		Platform.runLater[receiver.accept(msg)]						
		
	}
	
	private def recordMessage(Message msg){ messageRecorder.accept(msg) }
	
	
//	private def void processQueue(){
//		
//		val qitem = queue.poll(200, TimeUnit::MILLISECONDS)
//		
//		if(qitem !== null){
//			val value = qitem.value
//			
////			switch(qitem.key){
////				//case QUEUE_ID::SET_CANCELLED: cancelled = true
////				case QUEUE_ID::SET_PORT: serialPort = value as SerialPort
////				//case QUEUE_ID::SET_RECEIVER: receiver = value as MessageReceiver
////			}		
//		}				
//	}
	
	private def isReset(){ reset.get }
	
	
	private def transmit(Message msg){
		//println('''transmit(«msg»)''')
		val p = port							
		if(p !== null && p.isOpen){
			val byte[] bytes = CodecRegistry::instance.encode(msg)
			if(bytes !== null){
				info('''tx: «msg»''')								
				println(bytes)
				recordMessage(msg)									
				//p.writeBytes(bytes, bytes.size)
			}
		}
	}			
	
	
	private def void info(String text){
		Platform::runLater[infoHandler?.accept(text)] 
	}
}