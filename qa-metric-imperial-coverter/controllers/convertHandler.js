function ConvertHandler() {
  
  this.getNum = function(input) {
    let result;
    result = input ? eval(input) : 1;
    return result;
  };
  
  this.getUnit = function(input) {
    let result;
    
    return result;
  };
  
  this.getReturnUnit = function(initUnit) {
    let result;
    
    switch (initUnit) {
      case 'gal':
        result = 'l';
        break;
      case 'l':
        result = 'gal';
        break;
      case 'lbs':
        result = 'kg';
        break;
      case 'kg':
        result = 'lbs';
        break;
      case 'mi':
        result = 'km';
        break;
      case 'km':
        result = 'mi';
        break;
      default:
        return { error: 'Invalid unit' };
    }
    
    return result;
  };

  this.spellOutUnit = function(unit) {
    let result;

    switch (unit.toLowerCase()) {
      case 'gallons':
        result = 'gallons';
        break;
      case 'l':
        result = 'liters';
        break;
      case 'lbs':
        result = 'pounds';
        break;
      case 'kg':
        result = 'kilograms';
        break;
      case 'mi':
        result = 'miles';
        break;
      case 'km':
        result = 'kilometers';
        break;
      default:
        return { error: 'Invalid unit' };
    }
    
    
    return result;
  };
  
  this.convert = function(initNum, initUnit) {
    const galToL = 3.78541;
    const lbsToKg = 0.453592;
    const miToKm = 1.60934;
    let result;

    switch (initUnit.toLowerCase()) {
      case 'gal':
        initUnit = 'gal';
        returnUnit = 'l';
        returnNum = initNum * galToL;
        string = `${initNum} gallons converts to ${returnNum} liters`;
        break;
      case 'l':
        initUnit = 'l';
        returnUnit = 'gal';
        returnNum = initNum / galToL;
        string = `${initNum} liters converts to ${returnNum} gallons`;
        break;
      case 'lbs':
        initUnit = 'lbs';
        returnUnit = 'kg';
        returnNum = initNum * lbsToKg;
        string = `${initNum} pounds converts to ${returnNum} kilograms`;
        break;
      case 'kg':
        initUnit = 'kg';
        returnUnit = 'lbs';
        returnNum = initNum / lbsToKg;
        string = `${initNum} kilograms converts to ${returnNum} pounds`;
        break;
      case 'mi':
        initUnit = 'mi';
        returnUnit = 'km';
        returnNum = initNum * miToKm;
        string = `${initNum} miles converts to ${returnNum} kilometers`;
        break;
      case 'km':
        initUnit = 'km';
        returnUnit = 'mi';
        returnNum = initNum / miToKm;
        string = `${initNum} kilometers converts to ${returnNum} miles`;
        break;
      default:
        return { error: 'Invalid unit' };
    }
    result = returnNum;
    return result;
  };
  
  this.getString = function(initNum, initUnit, returnNum, returnUnit) {
    let result;

    result = `${initNum} ${initUnit} converts to ${returnNum} ${returnUnit}`;

    return result;
  };
  
}

module.exports = ConvertHandler;
