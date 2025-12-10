package com.bjb.upmfx.wire

class CodecRegistry {	
	
	val codecs = <Byte, Codec>newHashMap
	
	static val instance = new CodecRegistry	
	
	private new(){
		register(MessageID::SET_PUMP_SPEED, new SetPumpSpeedEncoder, null)
		register(MessageID::SET_CELSIUS, new SetCelsiusEncoder, null)
		register(MessageID::SET_ALL, new SetAllEncoder, null)		
		register(MessageID::UPM3_STATUS, null, new UPM3StatusDecoder)
	}
	
	static def getInstance(){ return instance }
	
	def Message decode(byte[] bytes){
		if(bytes.size > 0)			
			codecs.get(bytes.get(0))?.decoder?.decode(bytes)					
	}
	
	def byte[] encode(Message message){
		codecs.get(message.id)?.encoder?.encode(message)
	}
	
	def void register(byte id, Encoder encoder, Decoder decoder){
		codecs.put(id, new Codec(encoder, decoder))
	}
	
	def isRegistered(byte id){ codecs.get(id) !== null }
}

