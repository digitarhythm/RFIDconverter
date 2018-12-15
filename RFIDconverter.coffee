#============================================================================
# RFIDconverter - RFID code decoder (SGTIN96 only)
#============================================================================

class RFIDconverter
  decode:(epc)->
    epc2 = (epc.toString(16).match(/[0-9A-Fa-f]*/))[0].length
    if (epc2 != 24)
      return undefined

    bitrate = [8, 3, 3, 24, 20, 38]
    epcstr = epc.toString()
    codearr = epcstr.match(/[\s\S]{1,2}/g) || []

    bitcode = ""
    for num in codearr
      bit = ("00000000"+(parseInt(num, 16).toString(2))).slice(-8)
      bitcode += bit

    console.table bitcode

    start = 0
    result = []
    for num, cnt in bitrate
      ret = parseInt(bitcode.substr(start, num), 2).toString(10)
      result[cnt] = ret
      start += num

    epcdecode =
      Header      : parseInt(result[0], 10)
      Filter      : parseInt(result[1], 10)
      Partition   : parseInt(result[2], 10)
      GS1Code     : parseInt(result[3], 10)
      ItemCode    : parseInt(result[4], 10)
      SerialNumber: parseInt(result[5], 10)

    return epcdecode

module.exports = new RFIDconverter()
