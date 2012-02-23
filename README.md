# Ruby wrapper for ExifTool

This gem is the simplest thing that could possibly work that
reads the output of [exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool)
and renders it into a ruby hash, with correctly typed values and symbolized keys.

## Want constitutes "correct"?

* GPS latitude and longitude are rendered as signed floats,
  where north and east are positive, and west and south are negative.
* Values like shutter speed and exposure time are rendered as Rationals,
  which lets the caller show them as fractions (1/250) or as comparable.
* String values like "interop" and "serial number" are kept as strings
  (which preserves zero prefixes)

## Installation

You'll want to [install ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/install.html), then

```
gem install exiftoolr
```

or add to your Gemfile:

```
gem 'exiftoolr'
```

## Usage

```ruby
require 'exiftoolr'
e = Exiftoolr.new("path/to/iPhone 4S.jpg")
e.to_hash
# => {:make => "Apple", :gps_longitude => -122.47566667, …
e.to_display_hash
# => {"Make" => "Apple", "GPS Longitude" => -122.47566667, …
```

### Multiple file support

Supply an array to the Exiftoolr initializer, then use ```.result_for```:

```ruby
require 'exiftoolr'
e = Exiftoolr.new(Dir["**/*.jpg"])
result = e.result_for("path/to/iPhone 4S.jpg")
result.to_hash
# => {:make => "Apple", :gps_longitude => -122.47566667, …

e.files_with_results
# => ["/full/path/to/iPhone 4S.jpg", "/full/path/to/Droid X.jpg", …
```

### When things go wrong

* ```Exiftoolr::NoSuchFile``` is raised if the provided filename doesn't exist.
* ```Exiftoolr::ExiftoolNotInstalled``` is raised if ```exiftool``` isn't in your ```PATH```.
* If ExifTool has a problem reading EXIF data, no exception is raised, but ```#errors?``` will return true:

```ruby
Exiftoolr.new("Gemfile").errors?
#=> true
```

## Change history

### 0.0.4

Added support for multiple file fetching (which is *much* faster for large directories)
