import Foundation

/**
 Autocomplete response, JSON payload

 Per: https://developers.google.com/places/web-service/autocomplete#place_autocomplete_responses
 */
public struct AutocompleteResponse: Decodable {
    public let status: StatusCode
    public var errorMessage: String?

    public let predictions: [AutocompletePrediction]
}

public struct AutocompletePrediction: Decodable {
//    public let id: String

    ///	`description` contains the human-readable name for the returned result. For `establishment` results, this is usually the business name.
    public let description: String

    ///	`distance_meters` contains an integer indicating the straight-line distance between the predicted place,
    ///	and the specified `origin` point, in meters. This field is only returned when the `origin` point is specified in the request. This field is not returned in predictions of type `route`
    public let distanceMeters: Int?

    ///	`place_id` is a textual identifier that uniquely identifies a place.
    ///	To retrieve information about the place, pass this identifier in the `placeId` field of a Places API request.
    public let placeId: String

    ///	`terms` contains an array of `AutocompleteTerm` identifying each section of the returned description
    ///	(a section of the description is generally terminated with a comma).
    public let terms: [AutocompleteTerm]

    //	TODO: this should be [PlaceType] but it needs to have entire possible list of PlaceType cases added
    public let types: [String]
}

///	Specific term found in `AutocompletePrediction.description`
public struct AutocompleteTerm: Decodable {
    ///	`offset` field defines the start position of this term in the `description`, measured in Unicode characters
    public let offset: Int

    ///	`value` field, contains the text of the term
    public let value: String
}



/**
Example:
-------
{
  "status": "OK",
  "predictions" : [
      {
         "description" : "Paris, France",
         "distance_meters" : 8030004,
         "id" : "691b237b0322f28988f3ce03e321ff72a12167fd",
         "matched_substrings" : [
            {
               "length" : 5,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
         "reference" : "CjQlAAAA_KB6EEceSTfkteSSF6U0pvumHCoLUboRcDlAH05N1pZJLmOQbYmboEi0SwXBSoI2EhAhj249tFDCVh4R-PXZkPK8GhTBmp_6_lWljaf1joVs1SH2ttB_tw",
         "terms" : [
            {
               "offset" : 0,
               "value" : "Paris"
            },
            {
               "offset" : 7,
               "value" : "France"
            }
         ],
         "types" : [ "locality", "political", "geocode" ]
      },
      {
         "description" : "Paris-Madrid Grocery (Spanish Table Seattle), Western Avenue, Seattle, WA, USA",
         "distance_meters" : 12597,
         "id" : "f4231a82cfe0633a6a32e63538e61c18277d01c0",
         "matched_substrings" : [
            {
               "length" : 5,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJHcYlZ7JqkFQRlpy-6pytmPI",
         "reference" : "ChIJHcYlZ7JqkFQRlpy-6pytmPI",
         "structured_formatting" : {
            "main_text" : "Paris-Madrid Grocery (Spanish Table Seattle)",
            "main_text_matched_substrings" : [
               {
                  "length" : 5,
                  "offset" : 0
               }
            ],
            "secondary_text" : "Western Avenue, Seattle, WA, USA"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Paris-Madrid Grocery (Spanish Table Seattle)"
            },
            {
               "offset" : 46,
               "value" : "Western Avenue"
            },
            {
               "offset" : 62,
               "value" : "Seattle"
            },
            {
               "offset" : 71,
               "value" : "WA"
            },
            {
               "offset" : 75,
               "value" : "USA"
            }
         ],
         "types" : [
            "grocery_or_supermarket",
            "food",
            "store",
            "point_of_interest",
            "establishment"
         ]
      },
      {
         "description" : "Paris, TX, USA",
         "distance_meters" : 2712292,
         "id" : "518e47f3d7f39277eb3bc895cb84419c2b43b5ac",
         "matched_substrings" : [
            {
               "length" : 5,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJmysnFgZYSoYRSfPTL2YJuck",
         "reference" : "ChIJmysnFgZYSoYRSfPTL2YJuck",
         "structured_formatting" : {
            "main_text" : "Paris",
            "main_text_matched_substrings" : [
               {
                  "length" : 5,
                  "offset" : 0
               }
            ],
            "secondary_text" : "TX, USA"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Paris"
            },
            {
               "offset" : 7,
               "value" : "TX"
            },
            {
               "offset" : 11,
               "value" : "USA"
            }
         ],
         "types" : [ "locality", "political", "geocode" ]
      },

	...additional results ...
*/

