//
//  PlaceDetails.swift
//  GooglePlaces
//
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation
import CoreLocation

/**
 PlaceDetails response, JSON payload

 Per: https://developers.google.com/places/web-service/details#PlaceDetailsResponses
 */
public struct PlaceDetailsResponse: Decodable {
    public let status: StatusCode
    public var errorMessage: String?
    let htmlAttributions: [String]

    public let result: PlaceDetails
}


/**
 PlaceDetails, JSON payload

 Per: https://developers.google.com/places/web-service/details#PlaceDetailsResults

 There are a lot of possible information being returned here,
 we only need the addresses and location
 */
public struct PlaceDetails: Decodable {
    /**
     String containing the human-readable address of this place.

     Often this address is equivalent to the postal address. Note that some countries, such as the United Kingdom, do not allow distribution of true postal addresses due to licensing restrictions.

     The formatted address is logically composed of one or more address components. For example, the address "111 8th Avenue, New York, NY" consists of the following components: "111" (the street number), "8th Avenue" (the route), "New York" (the city) and "NY" (the US state).

     Do not parse the formatted address programmatically. Instead you should use the individual address components, which the API response includes in addition to the formatted address field.
     */
    public let formattedAddress: String

    ///	Representation of the place's address in the [adr microformat](http://microformats.org/wiki/adr).
    let adrAddress: String

    /**
     Contains the geocoded location of the `PlaceDetails`.

     `location` contains the geocoded latitude,longitude value for this place.

     `viewport` contains the preferred viewport when displaying this place on a map as a LatLngBounds if it is known.
     (Note: this is ignored in Annanow)
     */
    public let geometry: Geometry

    public let addressComponents: [AddressComponent]
}

public struct Geometry: Decodable {
    public let location: Location
}

public struct Location: Decodable {
    public let lat: Double
    public let lng: Double

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

public struct AddressComponent: Decodable {
    public let longName: String
    public let shortName: String
    public let types: [String]
}

extension AddressComponent {
    public var placeTypes: [PlaceType] {
        return types.compactMap({ PlaceType(rawValue:$0) })
    }
}


/**
Example:
-------

{
   "html_attributions" : [],
   "result" : {
      "address_components" : [
         {
            "long_name" : "5",
            "short_name" : "5",
            "types" : [ "floor" ]
         },
         {
            "long_name" : "48",
            "short_name" : "48",
            "types" : [ "street_number" ]
         },
         {
            "long_name" : "Pirrama Road",
            "short_name" : "Pirrama Rd",
            "types" : [ "route" ]
         },
         {
            "long_name" : "Pyrmont",
            "short_name" : "Pyrmont",
            "types" : [ "locality", "political" ]
         },
         {
            "long_name" : "Council of the City of Sydney",
            "short_name" : "Sydney",
            "types" : [ "administrative_area_level_2", "political" ]
         },
         {
            "long_name" : "New South Wales",
            "short_name" : "NSW",
            "types" : [ "administrative_area_level_1", "political" ]
         },
         {
            "long_name" : "Australia",
            "short_name" : "AU",
            "types" : [ "country", "political" ]
         },
         {
            "long_name" : "2009",
            "short_name" : "2009",
            "types" : [ "postal_code" ]
         }
      ],
      "adr_address" : "5, \u003cspan class=\"street-address\"\u003e48 Pirrama Rd\u003c/span\u003e, \u003cspan class=\"locality\"\u003ePyrmont\u003c/span\u003e \u003cspan class=\"region\"\u003eNSW\u003c/span\u003e \u003cspan class=\"postal-code\"\u003e2009\u003c/span\u003e, \u003cspan class=\"country-name\"\u003eAustralia\u003c/span\u003e",
      "formatted_address" : "5, 48 Pirrama Rd, Pyrmont NSW 2009, Australia",
      "formatted_phone_number" : "(02) 9374 4000",
      "geometry" : {
         "location" : {
            "lat" : -33.866651,
            "lng" : 151.195827
         },
         "viewport" : {
            "northeast" : {
               "lat" : -33.8653881697085,
               "lng" : 151.1969739802915
            },
            "southwest" : {
               "lat" : -33.86808613029149,
               "lng" : 151.1942760197085
            }
         }
      },
      "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png",
      "id" : "4f89212bf76dde31f092cfc14d7506555d85b5c7",
      "international_phone_number" : "+61 2 9374 4000",
      "name" : "Google",
      "place_id" : "ChIJN1t_tDeuEmsRUsoyG83frY4",
      "rating" : 4.5,
      "reference" : "CmRSAAAAjiEr2_A4yI-DyqGcfsceTv-IBJXHB5-W3ckmGk9QAYk4USgeV8ihBcGBEK5Z1w4ajRZNVAfSbROiKbbuniq0c9rIq_xqkrf_3HpZzX-pFJuJY3cBtG68LSAHzWXB8UzwEhAx04rgN0_WieYLfVp4K0duGhTU58LFaqwcaex73Kcyy0ghYOQTkg",
      "reviews" : [
         {
            "author_name" : "Robert Ardill",
            "author_url" : "https://www.google.com/maps/contrib/106422854611155436041/reviews",
            "language" : "en",
            "profile_photo_url" : "https://lh3.googleusercontent.com/-T47KxWuAoJU/AAAAAAAAAAI/AAAAAAAAAZo/BDmyI12BZAs/s128-c0x00000000-cc-rp-mo-ba1/photo.jpg",
            "rating" : 5,
            "relative_time_description" : "a month ago",
            "text" : "Awesome offices. Great facilities, location and views. Staff are great hosts",
            "time" : 1491144016
         }
      ],
      "scope" : "GOOGLE",
      "types" : [ "point_of_interest", "establishment" ],
      "url" : "https://maps.google.com/?cid=10281119596374313554",
      "utc_offset" : 600,
      "vicinity" : "5, 48 Pirrama Road, Pyrmont",
      "website" : "https://www.google.com.au/about/careers/locations/sydney/"
   },
   "status" : "OK"
}

*/
