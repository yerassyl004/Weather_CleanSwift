// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WelcomeDayly: Codable {
    let data: [Datum]
    let count: Int
}

let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday"]

// MARK: - Datum
struct Datum: Codable {
    let appTemp: Double
    let aqi: Int
    let cityName: String
    let clouds: Int
    let countryCode, datetime: String
    let dewpt, dhi, dni, elevAngle: Double
    let ghi: Double
    let gust: JSONNull?
    let hAngle: Int
    let lat, lon: Double
    let obTime, pod: String
    let precip: Int
    let pres: Double
    let rh, slp, snow: Int
    let solarRAD: Double
    let sources: [String]
    let stateCode, station, sunrise, sunset: String
    let temp: Int
    let timezone: String
    let ts: Int
    let uv: Double
    let vis: Int
    let weather: Weather
    let windCdir, windCdirFull: String
    let windDir, windSpd: Int

    enum CodingKeys: String, CodingKey {
        case appTemp = "app_temp"
        case aqi
        case cityName = "city_name"
        case clouds
        case countryCode = "country_code"
        case datetime, dewpt, dhi, dni
        case elevAngle = "elev_angle"
        case ghi, gust
        case hAngle = "h_angle"
        case lat, lon
        case obTime = "ob_time"
        case pod, precip, pres, rh, slp, snow
        case solarRAD = "solar_rad"
        case sources
        case stateCode = "state_code"
        case station, sunrise, sunset, temp, timezone, ts, uv, vis, weather
        case windCdir = "wind_cdir"
        case windCdirFull = "wind_cdir_full"
        case windDir = "wind_dir"
        case windSpd = "wind_spd"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let description: String
    let code: Int
    let icon: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
