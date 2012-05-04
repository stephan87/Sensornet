#include "Timer.h"
#include "TestSerial.h"
//#include "printf.h"

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
	    
	    interface Timer<TMilli> as Timer0;
	
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
	am_addr_t addr;
	
	void serialSendTask(TestSerialMsg* msgToSend);
  	void radioSendTask(TestSerialMsg* msgToSend);
  
  	event void Boot.booted() {
  		//printf("Hi I am writing to you from my TinyOS application!!\n");
  		//printfflush();
    	call RadioControl.start();
    	if(TOS_NODE_ID == 0){
    		call SerialControl.start();
    		//call Leds.led2Toggle();
    	}
    	else
    	{
    		//call Leds.led2Toggle();
    	}
  	}
  	
  	event void Timer0.fired()
	{
	    //call Leds.led0Toggle();
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
  		//call Leds.led0Toggle();
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg)){
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvRadio,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvRadio;
    		
    		radioSendTask(msgReceived);
  		}
  		return msg;
  	}
  
  	/*
  	*	This function receives messages targeted to the node
  	*/
  	event message_t *RadioReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len)
  	{
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg))
  		{
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvRadio,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvRadio;
    		if(msgReceived->receiver == TOS_NODE_ID){
	    		if(msgReceived->seqNum > localSeqNumber){
	    			dbg("TestSerialC","Finished Node %d: received message on RadioChannel seqNum: %d\n",TOS_NODE_ID,msgReceived->seqNum);
	    			localSeqNumber = msgReceived->seqNum;
	    			call Leds.set(msgReceived->ledNum);
	    		}
	    		else
	    			dbg("TestSerialC","Node %d:duplicate message received\n",TOS_NODE_ID);
	    	}
	    	else{
    			radioSendTask(msgReceived);
    		}
		}
    	return msg;
  	}
  
  	void serialSendTask(TestSerialMsg *receivedMsgToSend) 
  	{
      	// check sequence number to avoid sending of duplicates
		//if(receivedMsgToSend->seqNum > localSeqNumber)
		{
			//dbg("TestSerialC", "Node %d Received SnoopMessage from %d with sender: %d id: %d seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,id,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
			dbg("TestSerialC","Node %d received SnoopMessage (sender: %d): forward\n",TOS_NODE_ID,receivedMsgToSend->sender);
			//call Leds.set(receivedMsgToSend->ledNum);
			//localSeqNumber=receivedMsgToSend->seqNum;
			
			// is radio unused?
			if(!serialBusy){
				    			
				TestSerialMsg* msgToSend = (TestSerialMsg*)(call SerialPacket.getPayload(&sndSerial, sizeof (TestSerialMsg)));
				msgToSend->sender = receivedMsgToSend->sender;
				msgToSend->seqNum = receivedMsgToSend->seqNum;
				msgToSend->ledNum = receivedMsgToSend->ledNum;
				msgToSend->receiver = receivedMsgToSend->receiver;
				
				// forward message
				if(call SerialSend.send[AM_TESTSERIALMSG](AM_BROADCAST_ADDR,&sndSerial, sizeof(TestSerialMsg)) == SUCCESS){
					//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
					serialBusy = TRUE;
				}
			}
		}/*else{
			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
		}*/
  	}

  	event void SerialSend.sendDone[am_id_t id](message_t* msg, error_t error)
  	{
	    if (error == SUCCESS)
	    {
	      	if(&sndSerial == msg)
	      	{
	      		dbg("TestSerialC", "successfully sent message over serial\n");
	      		serialBusy = FALSE;
	      		call Leds.led1Toggle();
	      		return;
	      	}
	    }
  		dbg("TestSerialC", "error on message pointer\n");
  	}

  	event message_t *SerialReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len)
  	{
  		//localSeqNumber++;
  		
  		//call Leds.set(localSeqNumber);
  		//call Leds.led1Toggle();
  		
  		// got the right message to cast ?	
  		if (len == sizeof(TestSerialMsg))
  		{
    		TestSerialMsg *msgReceived;
  			memcpy(&rcvSerial,payload,len);
    		msgReceived = (TestSerialMsg*)&rcvSerial;
    		    		
    		// check sequence number to avoid sending of duplicates
    		//if(msgReceived->seqNum > localSeqNumber)
    		{
    			dbg("TestSerialC", "Node %d Received Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,msgReceived->seqNum,msgReceived->ledNum);
    			//call Leds.set(msgReceived->ledNum);
    			//localSeqNumber=msgReceived->seqNum;
    			//call Leds.led0Toggle();
    			// is radio unused?
    			if(!radioBusy)
    			{   			
					TestSerialMsg* msgToSend = (TestSerialMsg*)(call RadioPacket.getPayload(&sndRadio, sizeof (TestSerialMsg)));
					msgToSend->sender = msgReceived->sender;
					msgToSend->seqNum = msgReceived->seqNum;
					msgToSend->ledNum = msgReceived->ledNum;
					msgToSend->receiver = msgReceived->receiver;
					
					// forward message
					if(call RadioSend.send[AM_TESTSERIALMSG](AM_BROADCAST_ADDR,&sndRadio, sizeof(TestSerialMsg)) == SUCCESS)
					{
						//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
						radioBusy = TRUE;
						serialSendTask((TestSerialMsg*)msgReceived);
					}
				}
    		}
    		/*else{
    			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,msgReceived->sender,msgReceived->seqNum,msgReceived->ledNum);
    		}*/
  		}	  		
	  	
  		return msg;
  	}

  	void radioSendTask(TestSerialMsg *receivedMsgToSend)
  	{
    	// check sequence number to avoid sending of duplicates
		//if(receivedMsgToSend->seqNum > localSeqNumber)
		{
			//dbg("TestSerialC", "Node %d Received SnoopMessage from %d with sender: %d id: %d seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,id,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
			dbg("TestSerialC","Node %d received SnoopMessage (sender: %d): forward\n",TOS_NODE_ID,receivedMsgToSend->sender);
			//call Leds.set(receivedMsgToSend->ledNum);
			//localSeqNumber=receivedMsgToSend->seqNum;
			
			// is radio unused?
			if(!radioBusy){
				    			
				TestSerialMsg* msgToSend = (TestSerialMsg*)(call RadioPacket.getPayload(&sndRadio, sizeof (TestSerialMsg)));
				msgToSend->sender = receivedMsgToSend->sender;
				msgToSend->seqNum = receivedMsgToSend->seqNum;
				msgToSend->ledNum = receivedMsgToSend->ledNum;
				msgToSend->receiver = receivedMsgToSend->receiver;
				
				// forward message
				if(call RadioSend.send[AM_TESTSERIALMSG](AM_BROADCAST_ADDR,&sndRadio, sizeof(TestSerialMsg)) == SUCCESS){
					//dbg("BlinkToRadio", "message sent - busy set to true @ %s.\n", sim_time_string());
					radioBusy = TRUE;
				}
			}
		}/*else{
			dbg("BlinkToRadio", "Node %d Received duplicate Message from %d with seqNum: %d ledNum: %d\n",TOS_NODE_ID,receivedMsgToSend->sender,receivedMsgToSend->seqNum,receivedMsgToSend->ledNum);
		}*/
  	}

  	event void RadioSend.sendDone[am_id_t id](message_t* msg, error_t error)
  	{
    	if (error != SUCCESS)
    	{
    		dbg("TestSerialC","Error: Node %d couldnt send message on RadioChannel\n",TOS_NODE_ID);
    	}
    	else
    	{
    		if(TOS_NODE_ID == 0)
    		{
    			call Leds.led0Toggle();
    		}
 			radioBusy = FALSE;
  		}
  	}
} 
