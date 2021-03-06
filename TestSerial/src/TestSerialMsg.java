/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'TestSerialMsg'
 * message type.
 */

public class TestSerialMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 8;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 6;

    /** Create a new TestSerialMsg of size 8. */
    public TestSerialMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new TestSerialMsg of the given data_length. */
    public TestSerialMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg with the given data_length
     * and base offset.
     */
    public TestSerialMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg using the given byte array
     * as backing store.
     */
    public TestSerialMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public TestSerialMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public TestSerialMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg embedded in the given message
     * at the given base offset.
     */
    public TestSerialMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new TestSerialMsg embedded in the given message
     * at the given base offset and length.
     */
    public TestSerialMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <TestSerialMsg> \n";
      try {
        s += "  [seqNum=0x"+Long.toHexString(get_seqNum())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [ledNum=0x"+Long.toHexString(get_ledNum())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [sender=0x"+Long.toHexString(get_sender())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [receiver=0x"+Long.toHexString(get_receiver())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: seqNum
    //   Field type: int, unsigned
    //   Offset (bits): 0
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'seqNum' is signed (false).
     */
    public static boolean isSigned_seqNum() {
        return false;
    }

    /**
     * Return whether the field 'seqNum' is an array (false).
     */
    public static boolean isArray_seqNum() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'seqNum'
     */
    public static int offset_seqNum() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'seqNum'
     */
    public static int offsetBits_seqNum() {
        return 0;
    }

    /**
     * Return the value (as a int) of the field 'seqNum'
     */
    public int get_seqNum() {
        return (int)getUIntBEElement(offsetBits_seqNum(), 16);
    }

    /**
     * Set the value of the field 'seqNum'
     */
    public void set_seqNum(int value) {
        setUIntBEElement(offsetBits_seqNum(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'seqNum'
     */
    public static int size_seqNum() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'seqNum'
     */
    public static int sizeBits_seqNum() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: ledNum
    //   Field type: int, unsigned
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'ledNum' is signed (false).
     */
    public static boolean isSigned_ledNum() {
        return false;
    }

    /**
     * Return whether the field 'ledNum' is an array (false).
     */
    public static boolean isArray_ledNum() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'ledNum'
     */
    public static int offset_ledNum() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'ledNum'
     */
    public static int offsetBits_ledNum() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'ledNum'
     */
    public int get_ledNum() {
        return (int)getUIntBEElement(offsetBits_ledNum(), 16);
    }

    /**
     * Set the value of the field 'ledNum'
     */
    public void set_ledNum(int value) {
        setUIntBEElement(offsetBits_ledNum(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'ledNum'
     */
    public static int size_ledNum() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'ledNum'
     */
    public static int sizeBits_ledNum() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: sender
    //   Field type: int, unsigned
    //   Offset (bits): 32
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'sender' is signed (false).
     */
    public static boolean isSigned_sender() {
        return false;
    }

    /**
     * Return whether the field 'sender' is an array (false).
     */
    public static boolean isArray_sender() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'sender'
     */
    public static int offset_sender() {
        return (32 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'sender'
     */
    public static int offsetBits_sender() {
        return 32;
    }

    /**
     * Return the value (as a int) of the field 'sender'
     */
    public int get_sender() {
        return (int)getUIntBEElement(offsetBits_sender(), 16);
    }

    /**
     * Set the value of the field 'sender'
     */
    public void set_sender(int value) {
        setUIntBEElement(offsetBits_sender(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'sender'
     */
    public static int size_sender() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'sender'
     */
    public static int sizeBits_sender() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: receiver
    //   Field type: int, unsigned
    //   Offset (bits): 48
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'receiver' is signed (false).
     */
    public static boolean isSigned_receiver() {
        return false;
    }

    /**
     * Return whether the field 'receiver' is an array (false).
     */
    public static boolean isArray_receiver() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'receiver'
     */
    public static int offset_receiver() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'receiver'
     */
    public static int offsetBits_receiver() {
        return 48;
    }

    /**
     * Return the value (as a int) of the field 'receiver'
     */
    public int get_receiver() {
        return (int)getUIntBEElement(offsetBits_receiver(), 16);
    }

    /**
     * Set the value of the field 'receiver'
     */
    public void set_receiver(int value) {
        setUIntBEElement(offsetBits_receiver(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'receiver'
     */
    public static int size_receiver() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'receiver'
     */
    public static int sizeBits_receiver() {
        return 16;
    }

}
