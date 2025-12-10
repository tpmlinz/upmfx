package com.bjb.upmfx.common

class Util {	
	static def final toInt(byte value){ (value as int).bitwiseAnd(0xff) }	
}
