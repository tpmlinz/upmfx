package com.bjb.upmfx.wire

import java.nio.ByteBuffer
import static extension com.bjb.upmfx.common.Util.*


interface Encoder {
	def byte[] encode(Message msg)	
}


abstract class AbstractEncoder implements Encoder{
	
	protected def ByteBuffer getByteBuffer(Message msg){
		val byteBuffer = ByteBuffer::allocateDirect(msg.size.toInt + 1)
		byteBuffer.put(msg.size)
		byteBuffer.put(msg.id)
		byteBuffer
	}
}
