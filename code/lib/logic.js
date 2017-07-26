

/**
 * Sample transaction processor function.
 */



function onSetSensorTemp(setSensorTemp) {
    setSensorTemp.sensor.sensorTemp = setSensorTemp.newSensorValue; 
    return getAssetRegistry('org.acme.sample.Sensor')
      .then(function (assetRegistry) {
          return assetRegistry.update(setSensorTemp.sensor);
      });
}

function onChangeThermostatTemp(changeThermostat) {
  var diff = Math.abs(changeThermostat.sensor.sensorTemp - changeThermostat.newThermostatValue);
    if (diff < 3) {
      changeThermostat.sensor.thermostatTemp = changeThermostat.newThermostatValue;
      return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(changeThermostat.sensor);
      });
    } else {
      //reject transaction
      throw new Error("You do not have permission to change the temperature.");
    }
}

function onCompareWeather(compareWeather) {
  //Make life easier. Put all values for this function in vars.
  var outsideTemp = compareWeather.outsideTemp;
  var feelsLike = compareWeather.feelsLike;
  var thermostatTemp = compareWeather.sensor.thermostatTemp;
  
  if (outsideTemp == feelsLike){
     //If the temps are the same then create req's
    
    //It's HOT
    if (outsideTemp >= 26) {
      if (thermostatTemp != 22) {
        compareWeather.sensor.recommendation = "Boy! It is HOT! The recommended thermostat " +
          "setting is 22 C. The thermostat is being adjusted from " + thermostatTemp + ".";
        compareWeather.sensor.thermostatTemp = 22;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "Boy! It is HOT! The recommended thermostat " +
          "setting is 22 C. Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    //Temperate weather  
    } else if (outsideTemp >= 20 && outsideTemp < 26) {
      if (thermostatTemp != 20) {
        compareWeather.sensor.recommendation = "Nice weather you're having! The recommended" 
          + " thermostat setting is 20 C. The thermostat is being adjusted from " + thermostatTemp +
          ".";
        compareWeather.sensor.thermostatTemp = 20;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "Great weather! The recommended thermostat " +
          "setting is 20 C.Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    //Cooler temps
    } else {
      if (thermostatTemp != 19) {
        compareWeather.sensor.recommendation = "Getting chilly! The recommended" 
          + " thermostat setting is 19 C. The thermostat is being adjusted from " + thermostatTemp +
          ".";
        compareWeather.sensor.thermostatTemp = 19;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "It's getting chilly! The recommended thermostat " +
          "setting is 19 C.Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Team')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    }
  }
  else {
    //Set the req's off of what it feelsLike and not what the actual temp is
    
    //It's HOT
    if (feelsLike >= 26) {
      if (thermostatTemp != 22) {
        compareWeather.sensor.recommendation = "Boy! It feels HOT! The recommended thermostat " +
          "setting is 22 C. The thermostat is being adjusted from " + thermostatTemp + ".";
        compareWeather.asset.thermostatTemp = 22;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "Boy! It feels HOT! The recommended thermostat " +
          "setting is 22 C. Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    //Temperate weather  
    } else if (feelsLike >= 20 && feelsLike < 26) {
      if (thermostatTemp != 20) {
        compareWeather.sensor.recommendation = "It feels quite nice! The recommended" 
          + " thermostat setting is 20 C. The thermostat is being adjusted from " + thermostatTemp +
          ".";
        compareWeather.sensor.thermostatTemp = 20;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "It feels nice out! The recommended thermostat " +
          "setting is 20 C.Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    //Cooler temps
    } else {
      if (feelsLike != 19) {
        compareWeather.sensor.recommendation = "Brr! Where is my jacket? The recommended" 
          + " thermostat setting is 19 C. The thermostat is being adjusted from " + thermostatTemp +
          ".";
        compareWeather.sensor.thermostatTemp = 19;
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
      });
      } else {
        compareWeather.sensor.recommendation = "Brr! Where is the heat? The recommended thermostat "
          + "setting is 19 C.Way to go! Your thermostat is already optimally set.";
        return getAssetRegistry('org.acme.sample.Sensor')
        .then(function (assetRegistry) {
          return assetRegistry.update(compareWeather.sensor);
        });
      }
    }
  }
}