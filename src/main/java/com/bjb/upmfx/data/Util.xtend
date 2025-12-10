package com.bjb.upmfx.data

class Util {	
	static def final toInt(byte value){ (value as int).bitwiseAnd(0xff) }	
}