#!/usr/bin/python
import sys
import time

from TOSSIM import *
from TestSerialMsg import *

t = Tossim([])
m = t.mac()
r = t.radio()
sf = SerialForwarder(9002)
throttle = Throttle(t, 10)

t.addChannel("Serial", sys.stdout);
t.addChannel("TestSerialC", sys.stdout);

for i in range(0, 1):
  m = t.getNode(i);
  m.turnOn();
  
print "node "+str(i)+" is on: "+str(m.isOn())

sf.process();
throttle.initialize();

for i in range(0, 60):
  throttle.checkThrottle();
  t.runNextEvent();
  sf.process();

msg = TestSerialMsg()
msg.set_counter(7);

serialpkt = t.newSerialPacket();
serialpkt.setData(msg.data)
serialpkt.setType(msg.get_amType())
serialpkt.setDestination(0)
serialpkt.deliver(0, t.time() + 3)

pkt = t.newPacket();
pkt.setData(msg.data)
pkt.setType(msg.get_amType())
pkt.setDestination(0)
pkt.deliver(0, t.time() + 10)

for i in range(0, 20):
  throttle.checkThrottle();
  t.runNextEvent();
  sf.process();

throttle.printStatistics()


