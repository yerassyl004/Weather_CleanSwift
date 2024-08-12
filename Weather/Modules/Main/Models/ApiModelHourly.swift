import Foundation

// MARK: - WelcomeHourly
struct WelcomeHourly: Codable {
    let cityName, countryCode: String
    let data: [DatumHourly]
    let stateCode, timezone: String
//    let lat, lon: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case countryCode = "country_code"
        case data
        case stateCode = "state_code"
        case timezone
    }
}

// MARK: - Datum
struct DatumHourly: Codable {
    let appTemp: Double
    let clouds, cloudsHi, cloudsLow, cloudsMid: Int
    let datetime: String
    let dewpt, dhi, dni, ghi: Double
    let ozone: Double
    let pod: Pod
    let pop: Int
    let precip, pres: Double
    let rh: Int
    let slp: Double
    let snow: Double
    let snowDepth, solarRAD, temp: Double
    let timestampLocal, timestampUTC: String
    let ts: Int
    let uv, vis: Double
    let weather: WeatherHourly
    let windCdir, windCdirFull: String
    let windDir: Int
    let windGustSpd, windSpd: Double

    enum CodingKeys: String, CodingKey {
        case appTemp = "app_temp"
        case clouds
        case cloudsHi = "clouds_hi"
        case cloudsLow = "clouds_low"
        case cloudsMid = "clouds_mid"
        case datetime, dewpt, dhi, dni, ghi, ozone, pod, pop, precip, pres, rh, slp, snow
        case snowDepth = "snow_depth"
        case solarRAD = "solar_rad"
        case temp
        case timestampLocal = "timestamp_local"
        case timestampUTC = "timestamp_utc"
        case ts, uv, vis, weather
        case windCdir = "wind_cdir"
        case windCdirFull = "wind_cdir_full"
        case windDir = "wind_dir"
        case windGustSpd = "wind_gust_spd"
        case windSpd = "wind_spd"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct WeatherHourly: Codable {
    let icon: String
    let description: String
    let code: Int
}

enum Description: String, Codable {
    case drizzle = "Drizzle"
    case fewClouds = "Few clouds"
    case mixSnowRain = "Mix snow/rain"
    case overcastClouds = "Overcast clouds"
    case heavyRain = "Heavy rain"
}

enum Icon: String, Codable {
    case c02D = "c02d"
    case c04D = "c04d"
    case c04N = "c04n"
    case d02D = "d02d"
    case s04D = "s04d"
    case r03N = "r03n"
    case r02N = "r02n"
}
