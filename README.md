The Carbon Diet
---------------

http://www.carbondiet.org
Copyright (C) 2007-13 James Smith (james@floppy.org.uk)

[![Build Status](https://travis-ci.org/Floppy/carbon-diet.png?branch=master)](https://travis-ci.org/Floppy/carbon-diet)
[![Coverage Status](https://coveralls.io/repos/Floppy/carbon-diet/badge.png)](https://coveralls.io/r/Floppy/carbon-diet)
[![Dependency Status](https://gemnasium.com/Floppy/carbon-diet.png)](https://gemnasium.com/Floppy/carbon-diet)
[![Code Climate](https://codeclimate.com/github/Floppy/carbon-diet.png)](https://codeclimate.com/github/Floppy/carbon-diet)

About
-----

The Carbon Diet is a web application designed to facilitate accurate social
carbon footprinting. The master version of the site is at http://www.carbondiet.org,
but you are free to install your own copies elsewhere, as long as:

1. You leave the "powered by" notice in the footer intact.
2. You leave the existing content in the "help/about" section. You may add your
   own, but please leave the existing stuff intact.
3. You rebrand the site so it does not look the same as http://www.carbondiet.org.

You can change the source code, but you must make the modified source code
available to users of your modified site. See the license section below for
details. If you do change the code, please inform the developers through github
so we can integrate your improvements!

Requirements
------------

Ruby on Rails 3.2.13

Installation
------------

Copy database.example.yml to database.yml, and edit to set the correct details.
Copy settings.example.yml to settings.yml, and add your own details.
Run rake db:migrate to set up the database
Run script/server and go to http://localhost:3000 for more details.

License
-------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program (see the COPYING file).  If not, see
http://www.gnu.org/licenses/.

Exceptions:

You may not use the look and feel of http://www.carbondiet.org on your
own installation, including the Carbon Diet logo. You may not call your
installation "The Carbon Diet", you need another name. Derivates are OK though
("Bob's Carbon Diet").

Subcomponents
-------------

Most of the icons used on the site are from the [Silk icon set](http://www.famfamfam.com/lab/icons/silk/)

Most of the larger images are from the [Tango project](http://tango.freedesktop.org/).

Flash-based charting functionality is done with [amCharts](http://www.amcharts.com/)

See the websites of these projects for license details for the relevant content.