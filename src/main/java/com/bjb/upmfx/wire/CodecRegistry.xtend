package com.bjb.upmfx.wire

/*
 * A registry (hash map) mapping ids to Codecs
 */
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
	
	def void register(byte id, Codec codec){
		if(codec.encoder === null && codec.decoder === null)
			throw new IllegalArgumentException
		codecs.put(id, codec)			
	}
	
	def void register(byte id, Encoder encoder, Decoder decoder){					
		register(id, new Codec(encoder, decoder))
	}
	
	def void unregister(byte id){ codecs.remove(id) }
	
	def isRegistered(byte id){ codecs.get(id) !== null }
}

