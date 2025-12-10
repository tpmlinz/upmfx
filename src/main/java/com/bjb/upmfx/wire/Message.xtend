package com.bjb.upmfx.wire

import org.eclipse.xtend.lib.annotations.Accessors
import java.nio.ByteBuffer
//import java.nio.ByteOrder
import static extension com.bjb.upmfx.common.Util.*

class Message {
	
	@Accessors(PUBLIC_GETTER)
	val byte id
	
	@Accessors(PUBLIC_GETTER)
	val byte size
	
	
	new(byte id, byte size){ 
		this.id = id 
		this.size = size
	}
	
}

class SetPumpSpeed extends Message {
	
	@Accessors(PUBLIC_GETTER)
	val byte dutyCycle
		
	new(byte dutyCycle){
		super(MessageID::SET_PUMP_SPEED, 2 as byte)
		this.dutyCycle = dutyCycle		
	}
	
	override String toString(){
		'''SetPumpSpeed[size: «size.toInt», id:«id.toInt», dutyCycle«dutyCycle.toInt»]'''
	}
}

class SetCelcius extends Message {
	
	@Accessors(PUBLIC_GETTER)
	val byte celcius
		
	new(byte celcius){
		super(MessageID::SET_CELSIUS, 2 as byte)
		this.celcius = celcius		
	}
	
	override String toString(){
		'''SetCelcius[size:«size.toInt», id:«id.toInt», celcius:«celcius.toInt»]'''
	}
}

class SetAll extends Message {
	
	@Accessors(PUBLIC_GETTER)
	val byte dutyCycle
	
	@Accessors(PUBLIC_GETTER)
	val byte celcius
		
	new(byte dutyCycle, byte celcius){
		super(MessageID::SET_ALL, 3 as byte)
		this.dutyCycle = dutyCycle				
		this.celcius = celcius		
	}	
	
	
	override String toString(){
		'''SetAll[size:«size.toInt», id:«id», dutyCycle:«dutyCycle.toInt», celcius:«celcius.toInt»]'''
	}
}

class UPM3Status extends Message {
	
	@Accessors(PUBLIC_GETTER)
	val byte dutyCycle
	
	@Accessors(PUBLIC_GETTER)
	val byte pwmEnable
		
	new(byte dutyCycle, byte pwmEnable){
		super(MessageID::UPM3_STATUS, 3 as byte)
		this.dutyCycle = dutyCycle				
		this.pwmEnable = pwmEnable		
	}
	
	override String toString(){
		'''UPM3Status[size:«size.toInt», id:«id», dutyCycle:«dutyCycle.toInt», pwmEnable:«pwmEnable.toInt»]'''
	}	
}


class SetPumpSpeedEncoder extends AbstractEncoder{
	override byte[] encode(Message msg){				
		if(msg instanceof SetPumpSpeed)
			msg.byteBuffer.put(msg.dutyCycle).array					
		else
			throw new IllegalArgumentException
		
	}
}

class SetCelsiusEncoder extends AbstractEncoder{
	override byte[] encode(Message msg){
		if(msg instanceof SetCelcius)	
			msg.byteBuffer.put(msg.celcius).array				
		else
			throw new IllegalArgumentException	
	}
}

class SetAllEncoder extends AbstractEncoder{
	override byte[] encode(Message msg){
		if(msg instanceof SetAll)		
			msg.byteBuffer.put(msg.dutyCycle).put(msg.celcius).array			
		else
			throw new IllegalArgumentException
	}
}

class UPM3StatusDecoder extends AbstractDecoder{
	
	override Message decode(byte[] bytes){		
		val byteBuffer = MessageID::UPM3_STATUS.getByteBuffer(bytes)
		val dutyCycle = byteBuffer.get()
		val pwmEnable = byteBuffer.get()
		new UPM3Status(dutyCycle, pwmEnable)
	}
}
