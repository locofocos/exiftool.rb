require 'test_helper'

describe Exiftool::Parser do
  it 'creates snake-case symbolic keys properly' do
    p = Exiftool::Parser.new('HyperfocalDistance', '')
    p.sym_key.must_equal :hyperfocal_distance
  end

  it 'creates display keys properly' do
    p = Exiftool::Parser.new('InternalSerialNumber', '')
    p.display_key.must_equal 'Internal Serial Number'
  end

  it 'parses date flags without warnings' do
    p = Exiftool::Parser.new('DateStampMode', 'Off')
    p.value.must_equal 'Off'
  end

  it 'leaves dates without timezones as strings' do
    p = Exiftool::Parser.new('CreateDate', '2004:09:19 12:25:20')
    p.value.must_equal '2004:09:19 12:25:20'
  end

  it 'parses sub-second times' do
    p = Exiftool::Parser.new('SubSecDateTimeOriginal', '2011:09:25 20:08:09.234-08:00')
    p.value.must_equal Time.parse('2011-09-25 20:08:09.234-08:00')
  end

  it 'parses dates with timezones' do
    p = Exiftool::Parser.new('FileAccessDate', '2013:07:14 10:50:33-07:00')
    p.value.must_equal Time.parse('2013-07-14 10:50:33-07:00')
  end

  it 'parses fractions properly' do
    p = Exiftool::Parser.new('ShutterSpeedValue', '1/6135')
    p.value.must_equal Rational(1, 6135)
  end

  it 'parses N GPS coords' do
    p = Exiftool::Parser.new('GPSLatitude', '37.50233333 N')
    p.value.must_be_close_to 37.50233333
  end

  it 'parses S GPS coords' do
    p = Exiftool::Parser.new('GPSLatitude', '37.50233333 S')
    p.value.must_be_close_to -37.50233333
  end

  it 'parses E GPS coords' do
    p = Exiftool::Parser.new('GPSLongitude', '122.47566667 E')
    p.value.must_be_close_to 122.47566667
  end

  it 'parses W GPS coords' do
    p = Exiftool::Parser.new('GPSLongitude', '122.47566667 W')
    p.value.must_be_close_to -122.47566667
  end
end
