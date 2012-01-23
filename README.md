# Deployable: A collection of handy capistrano tasks and recipes

After years of copying our deploy script from one application to another it was time to consolidate all these variants into one authoritive source for all our deploy (and capistrano) related tasks. This library contains commonly used capistrano tasks, a couple of default recipes and example configurations.

## Usage

1. Add the `deployable` gem to your gemfile:

        group :development do
          gem "deployable", ">=0.0.2", :require => false
        end

2. Config your deploy script (see the `examples/config` directory for some inspiration)


## License

Deployable is released under the [MIT license](http://www.opensource.org/licenses/MIT)