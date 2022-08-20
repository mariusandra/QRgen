import std/unittest
import QRgen/private/[QRCode, EncodedQRCode, qrTypes]

test "charCountIndicatorLen()":
  let qr1 = newQRCode("0123", version = 28)
  check charCountIndicatorLen(qr1.mode, qr1.version) == 14

  let qr2 = newQRCode("0 TEST ALPHANUMERIC 9", version = 15)
  check charCountIndicatorLen(qr2.mode, qr2.version) == 11

  let qr3 = newQRCode("012 Tésting byté modé 789", version = 6)
  check charCountIndicatorLen(qr3.mode, qr3.version) == 8

test "encodeOnly()":
  let qr1 = encodeOnly newQRCode("8675309")

  check qr1.encodedData.data[0..18] == @[0b00010000'u8,0b00011111,0b01100011,0b10000100,0b10100100,0b00000000,0b11101100,0b00010001,0b11101100,0b00010001,0b11101100,0b00010001,0b11101100,0b00010001,0b11101100,0b00010001,0b11101100,0b00010001,0b11101100]

  let qr2 = encodeOnly newQRCode("HELLO WORLD", eccLevel = qrEccQ)

  check qr2.encodedData.data[0..12] == @[0b00100000'u8,0b01011011,0b00001011,0b01111000,0b11010001,0b01110010,0b11011100,0b01001101,0b01000011,0b01000000,0b11101100,0b00010001,0b11101100]

  let qr3 = encodeOnly newQRCode("Hello, world!")

  check qr3.encodedData.data[0..18] == @[0b01000000'u8,0b11010100,0b10000110,0b01010110,0b11000110,0b11000110,0b11110010,0b11000010,0b00000111,0b01110110,0b11110111,0b00100110,0b11000110,0b01000010,0b00010000,0b11101100,0b00010001,0b11101100,0b00010001]

test "interleaveData()":
  var qr1 = newEncodedQRCode(5, eccLevel = qrEccQ)

  qr1.encodedData.data = @[67'u8,85,70,134,87,38,85,194,119,50,6,18,6,103,38,246,246,66,7,118,134,242,7,38,86,22,198,199,146,6,182,230,247,119,50,7,118,134,87,38,82,6,134,151,50,7,70,247,118,86,194,6,151,50,16,236,17,236,17,236,17,236]

  qr1.interleaveData qrEccQ

  check qr1.encodedData.data == @[67'u8,246,182,70,85,246,230,247,70,66,247,118,134,7,119,86,87,118,50,194,38,134,7,6,85,242,118,151,194,7,134,50,119,38,87,16,50,86,38,236,6,22,82,17,18,198,6,236,6,199,134,17,103,146,151,236,38,6,50,17,7,236]

test "interleaveData() not touching ecc codewords":
  var qr1 = encodeOnly newQRCode("Hello, world!", version = 3, eccLevel = qrEccQ)
  qr1.interleaveData qrEccQ

  check qr1.encodedData.data == @[64'u8,236,212,17,134,236,86,17,198,236,198,17,242,236,194,17,7,236,118,17,247,236,38,17,198,236,66,17,16,236,236,17,17,236,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
