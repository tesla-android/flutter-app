class GpsEstimator {
  constructor() {
    this._lastLatitude = 0;
    this._lastLongitude = 0;
    this._lastTime = 0;
    this._lastHeading = 0;
  }

  estimate(source) {
    const latitude = source.latitude;
    const longitude = source.longitude;
    const updateTime = source.timestamp

    // Lat and Lon are in degrees, so first go to radians
    const lon1 = this._degToRad(longitude);
    const lon2 = this._degToRad(this._lastLongitude);
    const lat1 = this._degToRad(latitude);
    const lat2 = this._degToRad(this._lastLatitude);

    // Bearing
    // At low speeds <1m/s this is probably wrong due to jitter in the GPS signal.
    // Possibly calculate second only if speed is faster
    const diffLon = this._degToRad(longitude - this._lastLongitude);
    const x = Math.cos(lat1) * Math.sin(diffLon);
    const y =
      Math.cos(lat2) * Math.sin(lat1) - Math.sin(lat2) * Math.cos(lat1) * Math.cos(diffLon);
    const r = Math.atan2(x, y);
    const heading = this._radToDeg(r);

    // Straight line distance
    // There are about a dozen variants of this, all produce slightly
    // different results, some don't even work... this one seems pretty accurate
    const earthRadius = 6378137.0;
    const dLat = Math.sin(lat2 - lat1) / 2;
    const dLon = Math.sin(lon2 - lon1) / 2;
    const flatDistance =
      2000 * earthRadius * Math.asin(Math.sqrt(dLat * dLat + Math.cos(lat1) * Math.cos(lat2) * dLon * dLon));

    // Corner/Bearing compensation	
    const change = Math.abs(this._lastHeading - heading);
    const theta = this._degToRad(change);
    const distance = flatDistance / Math.cos(theta);

    const speed = distance / (updateTime - this._lastTime);

    this._lastLatitude = latitude;
    this._lastLongitude = longitude;
    this._lastTime = updateTime;
    this._lastHeading = heading; 

    return {
      speed: speed,
      heading: heading,
    };
  }

  _radToDeg(radians) {
    const deg = (radians * 180) / Math.PI;
    return deg >= 0 ? deg : 360 + deg;
  }

  _degToRad(degrees) {
    return (degrees * Math.PI) / 180;
  }
}