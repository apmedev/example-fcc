require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const dns = require('dns');
const urlparser = require('url');
const cors = require('cors');
const app = express();
var router = express.Router;
// Basic Configuration
const port = process.env.PORT || 3000;
mongoose.connect(process.env.MONGO_DB,{ useNewUrlParser: true, useUnifiedTopology: true });
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

app.post('/api/shorturl/new', async function (req, res) {

  const url = req.body.url_input
  const urlCode = shortId.generate()
  
  if (!validUrl.isWebUri(url)) {
    res.status(401).json({
      error: 'invalid URL'
    })
  } else {
    try {
      let findOne = await URL.findOne({
        original_url: url
      })
      if (findOne) {
        res.json({
          original_url: findOne.original_url,
          short_url: findOne.short_url
        })
      } else {
        findOne = new URL({
          original_url: url,
          short_url: urlCode
        })
        await findOne.save()
        res.json({
          original_url: findOne.original_url,
          short_url: findOne.short_url
        })
      }
    } catch (err) {
      console.error(err)
      res.status(500).json('Server erorr...')
    }
  }
})

app.use('/public', express.static(`${process.cwd()}/public`));

app.get('/', function(req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

// Your first API endpoint
app.get('/api/hello', function(req, res) {
  res.json({ greeting: 'hello API' });
});

app.listen(port, function() {
  console.log(`Listening on port ${port}`);
});
