package com.bjb.upmfx.wire

import java.nio.ByteBuffer

interface Decoder {
	def Message decode(byte[] bytes)

}

abstract class AbstractDecoder implements Decoder{
	
	protected def ByteBuffer getByteBuffer(byte id, byte[] bytes){
		val byteBuffer = ByteBuffer::wrap(bytes)
		if(byteBuffer.get() != id)
			throw new IllegalArgumentException
		byteBuffer
	}
}