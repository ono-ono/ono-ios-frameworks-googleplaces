import Foundation

///	Possible place types to use in autocomplete requests.
///
///	[Source](https://developers.google.com/places/web-service/autocomplete#place_types).
///	[Full list](https://developers.google.com/places/supported_types).
public enum PlaceType: String, Decodable {
    ///	instructs the Place Autocomplete service to return only geocoding results, rather than business results.
    ///	Generally, you use this request to disambiguate results where the location specified may be indeterminate.
    case geocode

    ///	instructs the Place Autocomplete service to return only geocoding results with a precise address. Generally, you use this request when you know the user will be looking for a fully specified address.
    case address

    ///	 instructs the Place Autocomplete service to return only business results.
    case establishment

    /**
     type collection instructs the Places service to return any result matching the following types:
     * locality
     * sublocality
     * postal_code
     * country
     * administrative_area_level_1
     * administrative_area_level_2
     */
    case regions = "(regions)"

    ///	type collection instructs the Places service to return results that match
    ///
    ///	* locality
    ///	* administrative_area_level_3.
    case cities = "(cities)"

    case political
    case route

    case country
    case floor
    case subpremise
    case streetAddress = "street_address"
    case streetNumber = "street_number"
    case neighborhood
    case postBox = "post_box"
    case postalCode = "postal_code"
    case postalCodePrefix = "postal_code_prefix"
    case postalCodeSuffix = "postal_code_suffix"

    case locality
    case sublocality
    case sublocalityLevel1 = "sublocality_level_1"
    case sublocalityLevel2 = "sublocality_level_2"
    case sublocalityLevel3 = "sublocality_level_3"
    case sublocalityLevel4 = "sublocality_level_4"
    case sublocalityLevel5 = "sublocality_level_5"

    case administrativeAreaLevel1 = "administrative_area_level_1"
    case administrativeAreaLevel2 = "administrative_area_level_2"
    case administrativeAreaLevel3 = "administrative_area_level_3"
    case administrativeAreaLevel4 = "administrative_area_level_4"
    case administrativeAreaLevel5 = "administrative_area_level_5"
}
