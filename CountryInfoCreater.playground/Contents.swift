import UIKit
import MapKit
import Foundation

func countryFlag(countryCode: String) -> String {
    return String(String.UnicodeScalarView(
        countryCode.unicodeScalars.compactMap(
            { UnicodeScalar(127397 + $0.value) }
        )
    ))
}


var countries = [CountryInfo]()
let regions = Locale.Region.isoRegions
let geocoder = CLGeocoder()
for region in regions {
    let regionIdentifier = region.identifier
    guard region.subRegions.isEmpty &&
            regionIdentifier != "CQ" else { continue }  // There is no standard flag for "CQ": "Sark"
    
    var canContinue = false
    geocoder.geocodeAddressString(regionIdentifier) { placemarks, error in
        defer { canContinue = true }
        guard let coordinate = placemarks?.first?.location?.coordinate else { return }
        
        let flag = countryFlag(countryCode: regionIdentifier)
        let countryInfo = CountryInfo(regionIdentifier: regionIdentifier,
                                      flag: flag,
                                      centerCoordinate: coordinate)
        countries.append(countryInfo)
    }
    repeat {
        RunLoop.current.run(until: .init(timeIntervalSinceNow: 2))
    } while !canContinue
}

countries
let encoder = JSONEncoder()
let data = try? encoder.encode(countries)

//if let data,
//    let string = String(data: data, encoding: .utf8) {
//    print(string)
//}
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
print(documentDirectory)
let fileURL = documentDirectory.appending(path: "CountryInfos").appendingPathExtension("txt")
//try? data?.write(to: fileURL)


