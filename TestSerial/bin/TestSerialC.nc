#include "Timer.h"
#include "TestSerial.h"

module TestSerialC @safe()
{
	uses {
	    interface Boot;
	    interface SplitControl as SerialControl;
	    interface SplitControl as RadioControl;
	
	    interface AMSend as SerialSend[am_id_t id];
	    interface Receive as SerialReceive[am_id_t id];
	    interface Packet as SerialPacket;
	    interface AMPacket as SerialAMPacket;
	    
	    interface AMSend as RadioSend[am_id_t id];
	    interface Receive as RadioReceive[am_id_t id];
	    interface Receive as RadioSnoop[am_id_t id];
	    interface Packet as RadioPacket;
	    interface AMPacket as RadioAMPacket;
	
	    interface Leds;
  	}
}
implementation
{
	uint16_t localSeqNumber = 0; ///< stores the msg sequence number
	bool radioBusy	=FALSE;
	bool serialBusy	=FALSE;
	message_t sndSerial; ///< strores the current sent message over serial
	message_t rcvSerial; ///< strores the current received message over serial
	message_t sndRadio; ///< strores the current sent message over radio
	message_t rcvRadio; ///< strores the current received message over radio
	
	void serialSendTask();
  	void radioSendTask(TestSerialMsg* msgToSend);
  
  	event void Boot.booted() {
    	call RadioControl.start();
    	if(TOS_NODE_ID == 0){
    		call SerialControl.start();
    	}
  	}

  	event void RadioControl.startDone(error_t error) {
    	if (error == SUCCESS) {
    		//dbg("TestSerialC","start done\n");
    	}
  	}

  	event void SerialControl.startDone(error_t error) {
    	if (error == SUCCESS) {
    		//dbg("TestSerialC","start done\n");
    	}
  	}

  	event void SerialControl.stopDone(error_t error) {}
  	event void RadioControl.stopDone(error_t error) {}
  
  	/*
  	*	This function receives messages where the current node is not targeted for
  	*/
  	event message_t *RadioSnoop.receive[am_id_t id](message_t *msg, void *payload, uint8_t len) 
  	{
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg)){
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvRadio,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvRadio;
    		
    		radioSendTask(msgReceived);
  		}
  		return msg;
 	
  	
  	
  	
  	/*
    
		if (!radioBusy)
  		{
      		
      		radioBusy = TRUE;
  		}
    	return msg;
    	*/
    	
    	/*
    	// check sequence number to avoid sending of duplicates
    		if(msgReceived->seqNum > localSeqNumber){
    			//dbg("TestSerialC", "Node %d Received SnoopMessage from %d with id: %d seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,id,msgReceived->seqNum,msgReceived->ledNum);
    			dbg("TestSerialC","Node %d received SnoopMessage: forward\n",TOS_NODE_ID);
    			call Leds.set(msgReceived->ledNum);
    			localSeqNumber=msgReceived->seqNum;
    			
    			// is radio unused?
    			if(!radioBusy){
    				    			
					TestSerialMsg* msgToSend = (TestSerialMsg*)(call RadioPacket.getPayload(&sndRadio, sizeof (TestSerialMsg)));
					msgToSend->sender = TOS_NODE_ID;
					msgToSend->seqNum = msgReceived->seqNum;
					msgToSend->ledNum = msgReceived->ledNum;
					msgToSend->receiver = msgReceived->receiver;
					
					// forward message
					if(call RadioSend.send[AM_TESTSERIALMSG](msgReceived->receiver,&sndRadio, sizeof(TestSerialMsg)) == SUCCESS){
						//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
						radioBusy = TRUE;
					}
				}
    		}else{
    			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,msgReceived->seqNum,msgReceived->ledNum);
    		}
    	*/
  	}
  
  	/*
  	*	This function receives messages targeted to the node
  	*/
  	event message_t *RadioReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len)
  	{
  		am_id_t idr = call RadioAMPacket.type(msg);
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg))
  		{
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvRadio,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvRadio;
    		
    		if(msgReceived->seqNum > localSeqNumber){
    			dbg("TestSerialC","Finished Node %d: received message on RadioChannel %d seqNum: %d\n",TOS_NODE_ID,idr,msgReceived->seqNum);
    			localSeqNumber = msgReceived->seqNum;
    		}
    		else
    			dbg("TestSerialC","Node %d:duplicate message received\n",TOS_NODE_ID);
		}
    
    	return msg;
  	}
  
  	void serialSendTask() 
  	{
	  /*  uint8_t len;
	    am_id_t id;
	    am_addr_t addr, src;
	    message_t* msg;
	    atomic
	    
	    if (serialBusy)
		{
		  dbg("TestSerialC","error node %d currently busy on serial\n",TOS_NODE_ID);
		  return;
		}

	    msg = (TestSerialMsg*)&rcvSerial;
	    tmpLen = len = call RadioPacket.payloadLength(msg);
	    id = call RadioAMPacket.type(msg);
	    //addr = call RadioAMPacket.destination(msg);
	    addr = msg->receiver;
	    src = call RadioAMPacket.source(msg);
	    call SerialPacket.clear(msg);
	    call SerialAMPacket.setSource(msg, src);
	
	    if (call SerialSend.send[id](addr, serialQueue[serialOut], len) == SUCCESS)
	    {
	    }
	    else
	    {
      	}*/
  	}

  	event void SerialSend.sendDone[am_id_t id](message_t* msg, error_t error)
  	{
	    if (error != SUCCESS)
	    {
	      	if(&sndSerial == msg)
	      	{
	      		dbg("TestSerialC", "successfully sent message over serial\n");
	      		serialBusy = FALSE;
	      		return;
	      	}
	    }
  		dbg("TestSerialC", "error on message pointer\n");
  	}

  	event message_t *SerialReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len)
  	{
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg)){
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvSerial,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvSerial;
    		
    		// check sequence number to avoid sending of duplicates
    		if(msgReceived->seqNum > localSeqNumber){
    			dbg("TestSerialC", "Node %d Received Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,msgReceived->seqNum,msgReceived->ledNum);
    			call Leds.set(msgReceived->ledNum);
    			localSeqNumber=msgReceived->seqNum;
    			
    			// is radio unused?
    			if(!radioBusy){
    				    			
					TestSerialMsg* msgToSend = (TestSerialMsg*)(call RadioPacket.getPayload(&sndRadio, sizeof (TestSerialMsg)));
					msgToSend->sender = msgReceived->sender;
					msgToSend->seqNum = msgReceived->seqNum;
					msgToSend->ledNum = msgReceived->ledNum;
					msgToSend->receiver = msgReceived->receiver;
					
					// forward message
					if(call RadioSend.send[AM_TESTSERIALMSG](msgToSend->receiver,&sndRadio, sizeof(TestSerialMsg)) == SUCCESS){
						//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
						radioBusy = TRUE;
					}
				}
    		}else{
    			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,msgReceived->seqNum,msgReceived->ledNum);
    		}
  		}
  		return msg;
  	
    	/*TestSerialMsg *msgReceived;
  		memcpy(&rcvSerial,payload,len);
    	msgReceived = (TestSerialMsg*)&rcvSerial;
    	
		dbg("TestSerialC","Node %d received message on SerialChannel\n",TOS_NODE_ID);
		dbg("TestSerialC","receiver: %d, sender: %d\n",msgReceived->receiver,msgReceived->sender);
    
		if (!radioBusy)
  		{
      		//radioSendTask(msgReceived);
      		radioBusy = TRUE;
  		}
    	return msg;*/
  	}

  	void radioSendTask(TestSerialMsg *receivedMsgToSend)
  	{
    	// check sequence number to avoid sending of duplicates
		if(receivedMsgToSend->seqNum > localSeqNumber)
		{
			//dbg("TestSerialC", "Node %d Received SnoopMessage from %d with sender: %d id: %d seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,id,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
			dbg("TestSerialC","Node %d received SnoopMessage (sender: %d): forward\n",TOS_NODE_ID,receivedMsgToSend->sender);
			call Leds.set(receivedMsgToSend->ledNum);
			localSeqNumber=receivedMsgToSend->seqNum;
			
			// is radio unused?
			if(!radioBusy){
				    			
				TestSerialMsg* msgToSend = (TestSerialMsg*)(call RadioPacket.getPayload(&sndRadio, sizeof (TestSerialMsg)));
				msgToSend->sender = receivedMsgToSend->sender;
				msgToSend->seqNum = receivedMsgToSend->seqNum;
				msgToSend->ledNum = receivedMsgToSend->ledNum;
				msgToSend->receiver = receivedMsgToSend->receiver;
				
				// forward message
				if(call RadioSend.send[AM_TESTSERIALMSG](msgToSend->receiver,&sndRadio, sizeof(TestSerialMsg)) == SUCCESS){
					//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
					radioBusy = TRUE;
				}
			}
		}else{
			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
		}
  	}

  	event void RadioSend.sendDone[am_id_t id](message_t* msg, error_t error)
  	{
    	if (error != SUCCESS)
    	{
    		dbg("TestSerialC","Error: Node %d couldnt send message on RadioChannel\n",TOS_NODE_ID);
    	}
    	else
    	{
 			radioBusy = FALSE;
  		}
  	}
} 
