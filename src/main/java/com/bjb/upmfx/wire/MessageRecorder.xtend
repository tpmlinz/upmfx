package com.bjb.upmfx.wire

import javafx.collections.FXCollections
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalTime
import javafx.application.Platform

//FIXME class should be replaced with logger

class MessageRecorder {
	
	static val MAX_MSG_ENTRIES = 10000
	
	@Accessors(PUBLIC_GETTER)	
	val messages = FXCollections.<MessageRecord>observableArrayList
	
	def recordMessage(Message msg){ recordMessage(LocalTime::now, msg) }	
	
	def recordMessage(LocalTime time, Message msg){
		Platform::runLater
		[
			if(messages.size >= MAX_MSG_ENTRIES)
				messages.removeFirst
			messages.add(new MessageRecord(time, msg))
		]
	}
	
}