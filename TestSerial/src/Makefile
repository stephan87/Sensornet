COMPONENT=TestSerialAppC
BUILD_EXTRA_DEPS += TestSerial.class
CLEAN_EXTRA = *.class TestSerialMsg.java
DEFAULT_LOCAL_GROUP = 0x06

CFLAGS += -I$(TOSDIR)/lib/printf
CFLAGS += -I$(TOSDIR)/lib/T2Hack
CFLAGS += -DNEW_PRINTF_SEMANTICS
CFLAGS += -DCC2420_DEF_RFPOWER=1


TestSerial.class: $(wildcard *.java) TestSerialMsg.java
	javac -target 1.4 -source 1.4 *.java

TestSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=TestSerialMsg TestSerial.h test_serial_msg -o $@


include $(MAKERULES)

