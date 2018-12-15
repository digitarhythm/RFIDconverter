# RFIDconverter
RFID code converter

## Frontend
write to HTML file.

```
<script type="text/javascript" src="RFIDconverter.min.js"></script>
```

Usage(CoffeeScript)
```
rfid = new RFIDconverter()  
epcdecode = rfid.decode([EPC code(length 24)])  
```

## Backend
import module from npm
```
$ npm i --save rfidconverter
```

require module
```
rfid = require("RFIDconverter")
epcdecode = rfid.decode([EPC code(length 24)])

```
