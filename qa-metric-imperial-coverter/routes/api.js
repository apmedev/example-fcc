'use strict';

const expect = require('chai').expect;
const ConvertHandler = require('../controllers/convertHandler.js');

module.exports = function (app) {
  
  let convertHandler = new ConvertHandler();

  app.route("/api/convert").get((req, res) =>  {
    const input = req.body["input"] || req.params.input || req.query.input;

    const regex = /^([\d.\/]+)?(gal|l|lbs|kg|mi|km)$/i;
    const match = input.match(regex);

    if (!match) {
      return { error: 'Invalid input format' };
    }

    const [_, value, unit] = match;
    
    var initNum = convertHandler.getNum(value);
    var initUnit = unit.toLowerCase();
    var returnUnit = convertHandler.getReturnUnit(initUnit);
    var returnNum = convertHandler.convert(initNum, initUnit);
    var returnUnitLong = convertHandler.spellOutUnit(returnUnit)
    var returnInitUnitLong = convertHandler.spellOutUnit(initUnit)
    var returnString = convertHandler.getString(initNum, returnInitUnitLong, returnNum, returnUnitLong);

    const result = {
      initNum: initNum,
      initUnit: initUnit,
      returnNum: returnNum,
      returnUnit: returnUnit,
      string: returnString
    };
    
    res.json(result);
  });

};
