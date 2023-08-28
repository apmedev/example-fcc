require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const dns = require('dns');
const urlparser = require('url');
const cors = require('cors');
var validUrl = require('valid-url');
const shortId = require('shortid');

const app = express();
var router = express.Router;
const port = process.env.PORT || 3000;
const mySecret = process.env['MONGO_DB'];

mongoose.connect( mySecret,{ useNewUrlParser: true, useUnifiedTopology: true });
//console.log(mongoose.connection.readyState);

app.use(cors());
app.use(bodyParser.urlencoded({extended: false}));
app.use(express.json());

const connection = mongoose.connection;
connection.on('error', console.error.bind(console, 'Conecction error:'))
connection.once('open', () => {
  console.log('MongoDB database connection established with success!')
})

const Schema = mongoose.Schema;
const urlSchema = new Schema({
  original_url: String,
  short_url: String
})

const URL = mongoose.model("URL", urlSchema);

app.use('/public', express.static(`${process.cwd()}/public`));

app.get('/', function(req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

// Your first API endpoint
app.get('/api/hello', function(req, res) {
  res.json({ greeting: 'hello API' });
});

app.post('/api/shorturl', async function (req, res) {
  console.log('Received body:', req.body.url);
  console.log('Received body 2:', req.body.url_input);
  
  const { url } = req.body;
  const urlCode = shortId.generate();
  
  console.log('Received URL:', url); 

  if (!validUrl.isWebUri(url)) {
    console.log('Invalid:', url);
    
    res.json({
      error: 'invalid url'
    })
  } else {
    try {
      let findOne = await URL.findOne({
        original_url: url
      });
      if (findOne) {
        res.json({
          original_url: findOne.original_url,
          short_url: findOne.short_url
        });
      } else {
        findOne = new URL({
          original_url: url,
          short_url: urlCode
        });
        await findOne.save();
        res.json({
          original_url: findOne.original_url,
          short_url: findOne.short_url
        });
      }
    } catch (err) {
      console.error(err);
      res.status(500).json('Server error...');
    }
  }
});

app.get('/api/shorturl/:short_url?', async function (req, res) {
  const shortUrl = req.params.short_url;
  try {
    const findOne = await URL.findOne({
      short_url: shortUrl
    });

    if (findOne) {
      res.redirect(findOne.original_url);
    } else {
      res.status(404).json({
        error: 'short url not found'
      });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json('Server error...');
  }
});

app.listen(port, function() {
  console.log(`Listening on port ${port}`);
});