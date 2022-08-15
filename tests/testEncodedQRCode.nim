import std/unittest
import QRgen/private/[QRCode, EncodedQRCode, qrTypes]

test "Interleaving":
  var encodedQr1 = newEncodedQRCode(5)

  encodedQr1.encodedData.data = @[
    67'u8,85,70,134,87,38,85,194,119,50,6,18,6,103,38,246,246,66,7,118,134,242,
    7,38,86,22,198,199,146,6,182,230,247,119,50,7,118,134,87,38,82,6,134,151,
    50,7,70,247,118,86,194,6,151,50,16,236,17,236,17,236,17,236
  ]

  encodedQr1.interleaveData qrEccQ

  check encodedQr1.encodedData.data == @[
    67'u8,246,182,70,85,246,230,247,70,66,247,118,134,7,119,86,87,118,50,194,
    38,134,7,6,85,242,118,151,194,7,134,50,119,38,87,16,50,86,38,236,6,22,82,
    17,18,198,6,236,6,199,134,17,103,146,151,236,38,6,50,17,7,236
  ]
