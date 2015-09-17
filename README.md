# Praxis New Relic Support

New Relic instrumentation for Praxis, Praxis Blueprints, and Praxis Mapper.


## Getting Started

Add the gem to your Gemfile:

    gem 'newrelic-praxis'

Add a simple initializer like `config/initializers/init_newrelic.rb`:

    require 'newrelic_rpm'
    require 'newrelic-praxis'

    NewRelic::Agent.manual_start


## What Is Instrumented

This gem provides separate instrumentation for Praxis, Praxis Blueprints, and Praxis Mapper. It uses existing `ActiveSupport::Notifications`  where available, and injects additional New Relic-specific instrumentation to Praxis Mapper.

### Praxis

This gem adds a trace for *just* the action code in a Controller by subscribing to the `'praxis.request_stage.execute'` event with `ActiveSupport::Notifications`. This will appear in New Relic with a name along the lines of `ControllerClass#action_method`.

In addition to the above, New Relic's default Rack instrumentation provides traces for:
  * `Praxis::Router#call` -- trace for the request handling inside Praxis. This will include not just the controller action logic, but also any `before`, `after` and `around` callbacks.
  * `Praxis::Application#call` -- trace for your full Praxis app. This includes  any Rack middleware you've specified.


### Praxis::Blueprint

Rendering a `Praxis::Blueprint` (which includes `Praxis::MediaType`s) views are instrumented with the `''` notification. These will appear as listed as "MediaTypeClass/view_name Template" in New Relic.

### Praxis::Mapper

Praxis::Mapper is instrumented in a number of different places:
  * Any SQL statements executed (using the Sequel query type) are instrumented as a Datastore in New Relic and will appear as `PraxisMapper :ModelClass select`.
  * `IdentityMap.load(ModelClass)` -- traces the full time to execute the query, including any additional `load`s it performs. These will appear as `:ModelClass/Load`.
  * `IdentityMap#finalize!`-- traces the retrieval of any records staged in queries with `track`. Appears as "PraxisMapper/Finalize".


## Configuration

Simply requiring the gem in the `init_newrelic.rb` example above is sufficient add all of the instrumentation when the New Relic agent starts.

You can disable specific portions of the instrumentation with the following configuration flags in your New Relic configuration (typically `newrelic.yml`):

  * `disable_praxis_instrumentation` -- disables the action tracing
  * `disable_praxis_blueprints_instrumentation` -- disables Praxis::Blueprint render tracing
  * `disable_praxis_mapper_instrumentation` -- disables all tracing in `Praxis::Mapper`

*Note:* Disabling Praxis::Mapper instrumentation has no effect any other database instrumentation that may be present (i.e., the Sequel support provided by New Relic). This can either a feature if you wish to remove the database traces from this gem and use another set, or a bug if you wish to completely disable all query tracing. Consult the New Relic documentation in the latter case for how to disable other instrumentation that may be installed.


## Mailing List
Join our Google Groups for discussion, support and announcements.
* [praxis-support](http://groups.google.com/d/forum/praxis-support) (support for people using
  Praxis)
* [praxis-announce](http://groups.google.com/d/forum/praxis-announce) (announcements)
* [praxis-development](http://groups.google.com/d/forum/praxis-development) (discussion about the
  development of Praxis itself)

And follow us on twitter: [@praxisapi](http://twitter.com/praxisapi)

## Contributions
Contributions to make Praxis better are welcome. Please refer to
[CONTRIBUTING](https://github.com/rightscale/praxis/blob/master/CONTRIBUTING.md)
for further details on what contributions are accepted and how to go about
contributing.

## Requirements
Praxis requires Ruby 2.1.0 or greater.

## License

This software is released under the [MIT License](http://www.opensource.org/licenses/MIT). Please see  [LICENSE](LICENSE) for further details.

Copyright (c) 2015 RightScale
