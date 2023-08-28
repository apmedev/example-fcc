var express = require('express');
var cors = require('cors');
const http = require('http');
const api = require('./routes/routes');
require('dotenv').config()
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
var multer = require('multer');
var upload = multer({ dest: 'uploads/' });

const connection = mongoose.connection;
connection.on('error', console.error.bind(console, 'Conecction error:'))
connection.once('open', () => {
  console.log('MongoDB database connection established with success!')
})

var app = express();

app.use(cors());
app.use(bodyParser.urlencoded({extended: false}));
app.use(express.json());
app.use('/public', express.static(process.cwd() + '/public'));

app.get('/', function (req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

app.post('/api/fileanalyse', upload.single('upfile'), (req, res) => {
  try {
    res.json({
      "name": req.file.originalname,
      "type": req.file.mimetype,
      "size": req.file.size
    });
  } catch (err) {
    res.send(400);
  }
});

const port = process.env.PORT || 3000;
app.listen(port, function () {
  console.log('Your app is listening on port ' + port)
});
