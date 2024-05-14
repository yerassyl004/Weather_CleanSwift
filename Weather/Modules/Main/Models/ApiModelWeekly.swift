import Foundation


struct WelcomeWeekly: Codable {
    let cityName, countryCode: String
    let data: [DatumWeekly]
//    let lat, lon: LatLon
    let stateCode, timezone: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case countryCode = "country_code"
        case data
        case stateCode = "state_code"
        case timezone
    }
}

enum LatLon: Codable, CustomStringConvertible {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(LatLon.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode LatLon"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }

    var description: String {
        switch self {
        case .double(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}

// MARK: - Datum
struct DatumWeekly: Codable {
    let appMaxTemp, appMinTemp: Double
    let clouds, cloudsHi, cloudsLow, cloudsMid: Int
    let datetime: String
    let dewpt, highTemp, lowTemp: Double
    let maxTemp, minTemp, moonPhase, moonPhaseLunation: Double
    let moonriseTs, moonsetTs: Int
    let ozone: Double
    let pop: Int
    let precip, pres: Double
    let rh: Int
    let slp, snow, snowDepth: Double
    let sunriseTs, sunsetTs: Int
    let temp: Double
    let ts: Int
    let uv: Double
    let validDate: String
    let vis: Double
    let weather: Weather
    let windCdir, windCdirFull: String
    let windDir: Int
    let windGustSpd, windSpd: Double
    
    enum CodingKeys: String, CodingKey {
        case appMaxTemp = "app_max_temp"
        case appMinTemp = "app_min_temp"
        case clouds
        case cloudsHi = "clouds_hi"
        case cloudsLow = "clouds_low"
        case cloudsMid = "clouds_mid"
        case datetime, dewpt
        case highTemp = "high_temp"
        case lowTemp = "low_temp"
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case moonPhase = "moon_phase"
        case moonPhaseLunation = "moon_phase_lunation"
        case moonriseTs = "moonrise_ts"
        case moonsetTs = "moonset_ts"
        case ozone, pop, precip, pres, rh, slp, snow
        case snowDepth = "snow_depth"
        case sunriseTs = "sunrise_ts"
        case sunsetTs = "sunset_ts"
        case temp, ts, uv
        case validDate = "valid_date"
        case vis, weather
        case windCdir = "wind_cdir"
        case windCdirFull = "wind_cdir_full"
        case windDir = "wind_dir"
        case windGustSpd = "wind_gust_spd"
        case windSpd = "wind_spd"
    }
}

// MARK: - Weather
struct WeatherWeekly: Codable {
    let icon, description: String
    let code: Int
}
