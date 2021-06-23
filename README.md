# CountryCodePicker

## Requirements
Getting Current Location Country Name, Dial Code and Flag
Change CountryPicker

## Steps
'1. didFinishLaunchingWithOptions 

assign CLLocationMaganer to get current lattitude and longitude
by CLLocationMaganer Delegate and CLPlaceMarker get Country Code 

2. didupdateLocation
Pass dictionary by using NotificationCenter to Viewcontroller to update current country details'

## CountryCodeVC

SearchBar - to search counrty
Image ,country name and dial code 

protocol is used to pass details to viewcontroller 


## Resources
Country.json is Json file contain list country with name, code and dial code

## Usage

* Easy to customize CounrtyCodeVC 
* get Current country Details 



## Author

Imran, Syedrazackimran@gmail.com

## License

CountryCodePicker is available under the MIT license. See the LICENSE file for more info.
