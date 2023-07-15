# UnifiedSettings

A simple and unified way to get any setting in your code regardless of where it is defined.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add unified_settings

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install unified_settings

## Usage

### Basic Usage

To get the value of `some_setting`, simply do:

    UnifiedSettings.get('some_setting')

Or to check if the key has been defined:

    UnifiedSettings.defined?('some_setting')

This will search the following locations in the following order:
  1. ENV
  2. Rails Credentials (if using Rails)
  4. constants

When using `UnifiedSettings.get('some_setting')`, the *first* setting that matches the provided key will be returned. As such, even if the same key is defined in ENV, Credentials and as a constant, it will return the value defined in ENV as that is what will take precedence.

If one wants to change the search order, or limit what is searched, one should provided the handlers to search explicity. For example:

    UnifiedSettings.get(
        'some_setting',
        handlers: [
            UnifiedSettings::Handlers::Credentials,
            UnifiedSettings::Handlers::Env
        ]
    )

This will first search the Credentials, then ENV, and completely ignore any values that might be defined in Settings or as a constant. If there are any other places that need to be searched, a new custom handler can be created and then provided. To do this, just create a class that inherits from `UnifiedSettings::Handlers::Base` and add it to the list of handlers. For details on how to configure `UnifiedSettings` to use differnet handlers by default, see the Configuration section below.

Note, by default the search is also done in a "case insensitive" manner. This means, for each setting source, it will first try to match the key as provied (e.g. `Some_Setting`). If nothing is found it will then attempt an upper case version of the key (`SOME_SETTING`) and a lower case version (`some_setting`). If this is not desired, one can do 

     UnifiedSettings.get('some_setting', case_sensitive: true)

### Predefined Handlers

Build in are 4 pre-defined handlers that look for setting keys in predfined locattions

* `UnifiedSettings::Handlers::ConfigGem`: Look for settings via the interface provied by [Config](https://github.com/rubyconfig/config)
* `UnifiedSettings::Handlers::Constants`: Look for a setting defined by a constant
* `UnifiedSettings::Handlers::Credentials`: Look for a setting in a Rails Credentials file
* `UnifiedSettings::Handlers::Env`: Look for a setting defined in `ENV`

### Coercing strings to objects

In many instances it is only possible to define strings as the value of a setting. For example, when setting an `ENV` var `SUPER_IMPORTANT_IDS` with the value of `1,2,3,4,5`, what the user really wants is a list of numbers, and not a comma separated string. As such, `UnifiedSettings` will automatically try to coerce things that look like arrays into arrays. Furthermore, it will convert things that look like floats to floats, ints to ints, booleans to booleans, etc. This way one does not have to worry about converting the values of settings to be easily used within the application. For example, is `some_setting` had the value of `'  string, tRue,   false,1,      2.2, NiL '`, the following be returned `['string', true, false, 1, 2.2, nil]`.

There are times when coercion is not desired (e.g. for things like long passcodes that may look like arrays since they may contain commas/numbers, etc.). For situations like this, simply disable the coercion.

    UnifiedSettings.get(`some_setting`, coerce: false)
### Handling Missing Keys

#### Setting a Default Value

In many cases there might be a default value that should be provided if a key is missing. This can be supplied as follows:

    UnifiedSettings.get('some_setting', default: 'some_value')

#### Logging/Raising Error

By default, when there is a missing key, an message will be logged with the severity of `error`. Depending on the situation one may want a different behavior. As such, different error handlers can be passed to meet those needs. The following handlers are predefined: `:log_debug`, `:log_info`, `:log_warn`, `:log_error`, `:log_fatal`, `:raise`. For example:

    UnifiedSettings.get('some_setting', on_missing_key: :raise)

If these do not suffice, one can pass an anonymous function that takes `key` as a parameter. For example:
    
    UnifiedSettings.get(
        'some_setting', 
        on_missing_key: ->(key) { puts "Something is wrong with #{key}" }
    ) 

Furthermore, one can pass a list of hanlders, so that multiple things can happen. For example

    UnifiedSettings.get(
        'some_setting', 
        on_missing_key: [
            :log_fatal,
            ->(key) { puts "Something is wrong with #{key}" },
            :raise
        ]
    )

This will run the handlers in the order that they were defined.

### Nested Settings

In many cases it is advantageous to have settings nested when defining them in, for example, the Rails Credentials file. For example, if we had the following defined in the Credentials file:

    aws:
        client_id: SOME_ID
        client_secret: SOME_SECRET

Then the corresponding setting keys would be:

    aws.client_id
    aws.client_secret

As you can see, for nested settings, the convention to be used is to separate the elements using a '.' 

The separator for ENV variables follow a slightly different as there can be issues when using a `.` in ENV variable names. As such the convention used in `UnifiedSettings` is modeled after the [Config gem](https://github.com/rubyconfig/config). When defining a value via an environment variable, the separator is a double underscore (`__`). Continuing with the above example, the ENV keys would be

    AWS__CLIENT_ID
    AWS__CLIENT_SECRET

This means, if you do

    UnifiedSettings.get('aws.client_id')

it will look for an ENV var of the form `AWS__CLIENT_ID`.

## Configuration

Most of the settings that can be set at the individual call level can also be globally configured.

IMPORTANT FOR RAILS: If one is planning on using `UnifiedSettings` during the initialization for other Rails gems, then this configuration MUST be done before we run `application.initialize!`.

### Configuring the Handlers

By default, the search order for a settings is:
  1. ENV
  2. Rails Credentials (if using Rails)
  4. constants

For example, if one is also using the [Config gem](https://github.com/rubyconfig/config), and would also like to search for settings there, one can add that handler.

    UnifiedSettings.configure do |config|
        config.handlers = [
            UnifiedSettings::Handlers::Env,
            UnifiedSettings::Handlers::Credentials,
            UnifiedSettings::Handlers::ConfigGem,
            UnifiedSettings::Handlers::Constants
        ]
    end

If one needs to supply some extra parameters when initializing the handler, for example if a non-default constant is used for the `Config` gem, one needs only to pass a hash as follows:

    UnifiedSettings.configure do |config|
        config.handlers = [
            UnifiedSettings::Handlers::Env,
            UnifiedSettings::Handlers::Credentials,
            {
                handler: UnifiedSettings::Handlers::ConfigGem,
                params: {
                    const_name: 'ConfigSettings'
                }
            },
            UnifiedSettings::Handlers::Constants
        ]
    end

### All Other Options

Instead of going through all the various options, here is a fully worked out example with inline comments.

```
UnifiedSettings.configure do |config|
  config.handlers = [
    UnifiedSettings::Handlers::Env,
    UnifiedSettings::Handlers::Credentials,
    {
      handler: UnifiedSettings::Handlers::ConfigGem,
      params: {
        const_name: 'Settings'
      }
    },
    UnifiedSettings::Handlers::Constants
  ]

  # Whether or not keys should be case sensitive. For example, let's assume the
  # key foo.bar.baz is defined in one of the locations the handlers are
  # configured to search. If we use case_sensitive = false then any of the
  # following examples will match
  #   UnifiedSettings.get('FOO.BAR.BAZ')
  #   UnifiedSettings.get('foo.bar.bar')
  #   UnifiedSettings.get('Foo.BaR.baZ')
  # If we set set case_sensitive = true, then only if the case exactly matches
  # the key is a result returned.
  # Default is: config.case_sensitive = false
  config.case_sensitive = false

  # This can be any of the following pre-defined handlers:
  #   :log_debug, :log_info, :log_warn, :log_error, :log_fatal, :raise
  # or you can pass an anonymous function that takes `key` as a parameter. E.g.
  #   config.on_missing_key = ->(key) { puts "Something is wrong with #{key}" }
  # If you need multiple things to happen, simply use an Array here. E.g.
  #   config.on_missing_key = [
  #     :log_fatal,
  #     ->(key) { puts "Something is wrong with #{key}" },
  #     :raise
  #   ]
  # This will run the handlers in the order that they were defined.
  #
  # Default is: config.on_missing_key = :log_error
  config.on_missing_key = :log_error

  # The value that should be returned if no key was found. This can be a set
  # to a particular value (e.g. `nil`, or `{}`), or can be an anonymous function
  # that takes `key` as a parameter. E.g.
  #   config.default_value = ->(key) { key.starts_with?('a') ? 'AA' : 'ZZ'}
  #
  # Default is: config.default_value = nil
  config.default_value = nil

  # The types that should be coerced from strings to their Ruby type.
  # (e.g. "true" to the boolean true or "1.2" to the float 1.2).
  # Default is: config.coercions = %i[nil boolean integer float]
  config.coercions = %i[nil boolean integer float]

  # Whether or not to coerce strings that look like arrays to arrays.
  # E.g. "a, B, true,1  " would be coerced become to ["a", "B", true, 1]
  # Defualt is:
  #   config.coerce_arrays = true
  #   config.coerce_array_separator = ','
  config.coerce_arrays = true
  config.coerce_array_separator = ','
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/prschmid/unified_settings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
