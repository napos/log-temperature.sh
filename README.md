# log-temperature.sh

Copyright 2013, 2014 Siim Orasmäe.

A little Bash script which polls and outputs [Raspberry Pi](http://www.raspberrypi.org)'s [SoC](http://en.wikipedia.org/wiki/System_on_a_chip) temperature and any [1-Wire](http://en.wikipedia.org/wiki/1-Wire) temperature sensors which are connected to said RPi.
The order of output is: SoC first, then all of the 1-Wire stuff which it finds (in alphabetical order, based on directory names/unique id's).

Tested with RPi model A (v.2), RPi model B (v.2) and DS18B20 sensors on [Raspbian](http://www.raspbian.org).

### Requirements

Raspbian does not come with a CLI calculator(?), so use `sudo apt-get install bc` first.

1-Wire modules with `modprobe w1-gpio`, `modprobe w1-therm` or stick them in `/etc/modules`.

**NOTICE:** This script does not work without any 1-Wire sensors attached!

### Usage

```
	./log-temperature.sh [-i SECONDS] [-1] [-f] [-h]
```

* `-i`	interval of readings (in seconds)
* `-1`	poll once and exit
* `-f`	display temperature in Fahrenheit
* `-h`	print help

### Notes

* Since the 1-Wire interface is quite slow, the interval between polls is dependent on it's speed. Meaning, that the interval which you set, is *actually* the time between the last 1-Wire signal arriving and a new query being made. It is **not**, as one would expect, the time between the start of the first query until the start of the next query. If that makes sense.

* I don't know how this will behave if there are other sensors/stuff/things attached to the 1-Wire line. Don't have any to test with. If you do, let me know!

### TO-DO

* Add output to file with -o
* Add quiet mode with -q
* Test with other 1-Wire sensors
* Make it work without 1-Wire sensors (why?)

### Contact

Visit [serenity.ee](http://www.serenity.ee)

---

### Licence

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).