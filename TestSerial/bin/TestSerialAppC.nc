#include "TestSerial.h"

configuration TestSerialAppC {}
implementation {
  components TestSerialC as App, LedsC, MainC;
  components SerialActiveMessageC as AMSerial;
  components ActiveMessageC as AMRadio;

  App.Boot -> MainC.Boot;
  
  App.SerialControl  -> AMSerial;
  App.SerialSend 	 -> AMSerial;
  App.SerialReceive  -> AMSerial.Receive;
  App.SerialPacket 	 -> AMSerial;
  App.SerialAMPacket -> AMSerial;
  
  App.RadioControl 	-> AMRadio;
  App.RadioSend 	-> AMRadio;
  App.RadioReceive 	-> AMRadio.Receive;
  App.RadioSnoop 	-> AMRadio.Snoop;
  App.RadioPacket 	-> AMRadio;
  App.RadioAMPacket -> AMRadio;
  
  App.Leds 	-> LedsC;
}