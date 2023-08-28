const express = require('express')
const app = express()
const cors = require('cors')
const bodyParser = require('body-parser');
require('dotenv').config()
const mongoose = require('mongoose');
const mySecret = process.env['MONGO_URI'];
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.json());

mongoose.connect( mySecret,{ useNewUrlParser: true, useUnifiedTopology: true });

const connection = mongoose.connection;

connection.on('error', console.error.bind(console, 'Conecction error:'))
connection.once('open', () => {
  console.log('MongoDB database connection established with success!')
})

// Import models
const User = require('./models/user');
const Exercise = require('./models/exercise');

app.use(cors())
app.use(express.static('public'))
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html')
});

// Print to the console information about each request made
app.use((req, res, next) => {
  console.log("method: " + req.method + "  |  path: " + req.path + "  |  IP - " + req.ip + "  |  body: " + req.body.username);
  next();
});

app.route('/api/users').get(async (req, res) => {
  try {
    const users = await User.find({});
    res.json(users);
  } catch (error) {
    res.json({ error: 'An error occurred' });
  }
}).post(async (req, res) => {
  try {
    const potentialUsername = req.body.username;
    console.log("potential username:", potentialUsername);

    const existingUser = await User.findOne({ username: potentialUsername });
    if (existingUser) {
      res.send(`Username ${potentialUsername} already exists.`);
      console.log(`Username ${potentialUsername} already exists.`);
    } else {
      const newUser = new User({
        username: potentialUsername
      });

      const savedUser = await newUser.save();
      const userObject = {
        "username": savedUser.username,
        "_id": savedUser._id
      };
      res.json(userObject);
      console.log(userObject);
    }
  } catch (error) {
    res.json({ error: 'An error occurred' });
  }
});

// PATH /api/users/:_id/exercises
// POST: Store new exercise in the Exercise model 
app.post('/api/users/:_id/exercises', async (req, res) => {
  try {
    const userID = req.body[":_id"] || req.params._id;
    const descriptionEntered = req.body.description;
    const durationEntered = req.body.duration;
    const dateEntered = req.body.date;

    console.log(userID, descriptionEntered, durationEntered, dateEntered);

    if (!userID || !descriptionEntered || !durationEntered) {
      res.json({ error: 'Required fields missing' });
      return;
    }

    const user = await User.findOne({ "_id": userID });
    if (!user) {
      res.json({ error: 'Invalid userID' });
      return;
    }

    const newExercise = new Exercise({
      username: user.username,
      description: descriptionEntered,
      duration: durationEntered
    });

    if (dateEntered) {
      newExercise.date = dateEntered;
    }

    const savedExercise = await newExercise.save();
    const exerciseObject = {
      "_id": userID,
      "username": savedExercise.username,
      "date": savedExercise.date.toDateString(),
      "duration": savedExercise.duration,
      "description": savedExercise.description
    };

    res.json(exerciseObject);
  } catch (error) {
    res.json({ error: 'An error occurred' });
  }
});

// PATH /api/users/:_id/logs?[from][&to][&limit]
app.get('/api/users/:_id/logs', async (req, res) => {
  try {
    const id = req.body["_id"] || req.params._id;
    var fromDate = req.query.from;
    var toDate = req.query.to;
    var limit = req.query.limit;

    console.log(id, fromDate, toDate, limit);

    // Validate the query parameters
    if (fromDate) {
      fromDate = new Date(fromDate);
      if (isNaN(fromDate)) {
        res.json({ error: 'Invalid Date Entered' });
        return;
      }
    }

    if (toDate) {
      toDate = new Date(toDate);
      if (isNaN(toDate)) {
        res.json({ error: 'Invalid Date Entered' });
        return;
      }
    }

    if (limit) {
      limit = Number(limit);
      if (isNaN(limit)) {
        res.json({ error: 'Invalid Limit Entered' });
        return;
      }
    }

    const user = await User.findOne({ "_id": id });
    if (!user) {
      res.json({ error: 'Invalid UserID' });
      return;
    }

    const usernameFound = user.username;

    var objToReturn = { "_id": id, "username": usernameFound };

    var findFilter = { "username": usernameFound };
    var dateFilter = {};

    if (fromDate) {
      objToReturn["from"] = fromDate.toDateString();
      dateFilter["$gte"] = fromDate;
      if (toDate) {
        objToReturn["to"] = toDate.toDateString();
        dateFilter["$lt"] = toDate;
      } else {
        dateFilter["$lt"] = new Date();
      }
    }

    if (toDate) {
      objToReturn["to"] = toDate.toDateString();
      dateFilter["$lt"] = toDate;
      dateFilter["$gte"] = new Date("1960-01-01");
    }

    if (toDate || fromDate) {
      findFilter.date = dateFilter;
    }

    const exerciseCount = await Exercise.countDocuments(findFilter);

    var count = exerciseCount;
    if (limit && limit < count) {
      count = limit;
    }
    objToReturn["count"] = count;

    const exercises = await Exercise.find(findFilter).limit(limit);
    const logArray = exercises.map(val => {
      return {
        description: val.description,
        duration: val.duration,
        date: val.date.toDateString()
      };
    });
    objToReturn["log"] = logArray;

    res.json(objToReturn);
  } catch (error) {
    res.json({ error: 'An error occurred' });
  }
});

const listener = app.listen(process.env.PORT || 3000, () => {
  console.log('Your app is listening on port ' + listener.address().port)
})
