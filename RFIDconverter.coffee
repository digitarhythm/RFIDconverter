#============================================================================
# RFIDconverter - RFID code decoder (SGTIN96 only)
#============================================================================

class RFIDconverter

  decode:(epc)->
    jancodedigit = (digitseed)->
      arr = Array.from(digitseed)
      odd = 0
      mod = 0
      for i in [0...arr.length]
        if ((i + 1) % 2 == 0)
          mod += parseInt(arr[i])
        else
          odd += parseInt(arr[i])
      a = (mod*3+odd).toString()
      cd = 10 - parseInt(((mod * 3+odd).toString()).substr(-1))
      return if (cd == 10) then 0 else cd

    epc2 = (epc.toString(16).match(/[0-9A-Fa-f]*/))[0].length
    if (epc2 != 24)
      return undefined

    bitrate_a = [8, 3, 3]
    bitrate_b1 = [30, 14, 38]
    bitrate_b2 = [24, 20, 38]
    epcstr = epc.toString()
    codearr = epcstr.match(/[\s\S]{1,2}/g) || []
    #codearr = Array.from(epcstr)

    bitcode = ""
    for num in codearr
      bit = ("00000000"+(parseInt(num, 16).toString(2))).slice(-8)
      bitcode += bit

    start = 0
    result = []

    for num, cnt in bitrate_a
      ret = parseInt(bitcode.substr(start, num), 2).toString(10)
      result[cnt] = ret
      start += num

    if (result[2] == 3)
      bitrate = bitrate_b1
    else
      bitrate = bitrate_b2

    for num, cnt in bitrate
      ret = parseInt(bitcode.substr(start, num), 2).toString(10)
      result[parseInt(cnt+bitrate_a.length)] = ret
      start += num

    jancode = result[3]+result[4]+jancodedigit(result[3]+result[4])

    epcdecode =
      Header      : result[0].toString()
      Filter      : result[1].toString()
      Partition   : result[2].toString()
      GS1Code     : result[3].toString()
      ItemCode    : result[4].toString()
      SerialNumber: result[5].toString()
      JanCode     : jancode.toString()

    return epcdecode

module.exports = new RFIDconverter()

