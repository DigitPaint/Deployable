Deployable: A collection of handy capistrano tasks and recipes
==============================================================

**Homepage**:  [http://github.com/digitpaint/deployable](http://github.com/digitpaint/deployable)   
**Git**:       [git@github.com:digitpaint/deployable.git](git@github.com:digitpaint/deployable.git)   
**Author**:    Digitpaint  
**License**:   [MIT license](http://www.opensource.org/licenses/MIT)

Synopsis
--------

After years of copying our deploy script from one application to another it was time to consolidate all these variants into one authoritive source for all our deploy (and capistrano) related tasks. This library contains commonly used capistrano tasks, a couple of default recipes and example configurations.

Usage
-----

1. Add the `deployable` gem to your gemfile:

        group :development do
          gem "deployable", :require => false
        end

2. Config your deploy script (see the `examples/config` directory for some inspiration)


Source
------
 
deployable's git repo is available on GitHub, which can be browsed at:
 
    http://github.com/digitpaint/deployable
   
and cloned from:
   
    git://github.com/digitpaint/deployable.git


Copyright
---------

Deployable &copy; 2012 by [Digitpaint](mailto:info@digitpaint.nl). Licensed under the MIT
license. Please see the {file:LICENSE} for more information.