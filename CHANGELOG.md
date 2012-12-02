## 0.1.0 (December 2nd, 2012)

* Added the passenger standalone configuration option path
* Update dependency of capistrano to newest version

## 0.0.7 (April 4th, 2012)

* Added recipe without database support
* Add version number and date to the init.trd scripts file
* Don't let the init.rd script crash on multi-app operations if one of them fails
* Fix the location of the passenger pid in init.rd

## 0.0.6 (February 1st, 2012)

* Updated initrd script for passenger to nog log
* Added custom ERB template handler so it works in ruby 1.9.x and 1.8.x

## 0.0.5 (January 25th, 2012)

* Don't depend on highline, let the environment decide

## 0.0.4 (January 25th, 2012)

* Don't fail if a certain config isn't set, just ignore it.

## 0.0.3 (January 24th, 2012)

* Added directories module

## 0.0.2 (January 24th, 2012)

* Added license
* Improved documentation
* Added a default recipe using a database
* New and improved initrd script (list/info commands)
* Add capistrano as a gem dependency
* Removed support for Bundler 0.7.x


## 0.0.1 (January 22nd, 2012)

Initial public release of Deployable gem.