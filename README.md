# rxcode

RXCode allows you to use Ruby to interact with your XCode projects and test your Objective-C code using MacRuby and
RSpec 2.

## Getting Started

RXCode is just a 'gem install' away:
    
    $ gem install bundler
    $ gem install rxcode
    $ cd MyProjectRoot    # The directory containing your MyProject.xcodeproj or MyProjects.xcworkspace
    $ rxcode init
    $ bundle install      # optional, though recommended

This will bootstrap your XCode project with support for writing utility scripts (a.k.a. 'tasks') with Rake, testing your
code using MacRuby & RSpec, and managing Ruby library dependencies with Bundler.

To see what tasks RXCode provides by default, try the following command:

    $ rake -T

## Testing Objective-C Code

RXCode brings the ease of BDD-style testing to Objective-C, allowing you to write tests for your Objective-C classes
using MacRuby and RSpec 2. While writing specs in MacRuby and RSpec provides a significant productivity boost, you will
want to review the following pros and cons of this approach:

**Pros**

* Quickly write BDD-style specs using RSpec's clear and concise DSL.

* Run just a subset of your entire suite easily using the `rspec` command, or from within TextMate.

* Run specs from the command-line using a provided Rake task, or with the `rspec` command.

**Cons**

* There is no way to run the tests under iOS, let alone test against specific iOS SDKs.

* MacRuby and RSpec must run in a garbage-collected environment -- memory leaks will not show up in tests.

* You cannot use XCode's debugger when running your tests.

* MacRuby provides a very convenient syntax for calling Objective-C code from Ruby, but handling C-level constructs
  can be cumbersome.

Some of these may be addressed in future releases, or by other tools.

### Running Specs

Running your specs is easy from the command line:

    $ macrake

And that's it. By default all your specs will be run. You should try this soon after you initialize your project to make
sure MacRuby and RSpec are working before you write your specs.

If you want to run specific specs, or customize the run at all, you should use the `rspec` command provided by RSpec:

    $ rspec --format html path/to/file_spec.rb

You can also run the specs with little or no work from any editor or IDE that supports RSpec, such as TextMate. The
RSpec TextMate bundle works great, and provides a way to run focused tests quickly.

### Configuring Your Project to Allow Testing with RSpec

Now that you can run specs, you'd like to move on and actually write specs for your own code. In order to test your code
using MacRuby+RSpec, the code you want to test must be added to an Objective-C framework that MacRuby can load
dynamically. If you are writing an app for iPhone or iPad, this means you can't test any iOS-specific behavior.

In practice though, there's often a lot of model-related code in iOS projects that can be extracted and tested
independently within MacRuby. This also enforces a clean separation between model and view code, as well as ensuring
that this code is cross-platform.

1.  Create a 'Cocoa Framework' target and add whatever code you'd like to test to it. Make sure header files are public
    or private, so they will be included in the framework and a Bridge Support file can be created (see #3 below).

2.  Update the framework target's build settings so that garbage collection is supported.

3.  Append a 'Run Script' build phase to the target, with the following script:
        
        rake rxcode:generate_bridgesupport_file
    
    This rake task will generate a BridgeSupport file from the framework, which MacRuby uses to understand method
    signatures and return values. Without this step, any method that returns a BOOL, for example, would be seen by
    MacRuby as a plain integer.
    
4.  Build the framework target, and ensure that no build errors occur.

5.  Open the spec/spec_helper.rb file and require the framework like so:
    
        RXCode.framework('YourFrameworkName')
    
    This will cause MacRuby to load the framework and make it available to your specs. The `spec_helper.rb` contains
    inline comments describing in detail how to load different types of frameworks.

6.  Run the specs again, ensuring that your framework is loaded and RSpec completes without error.

### Writing Specs

Now that you're able to load your Objective-C framework into MacRuby and run RSpec, it's time to write some specs.
RXCode's rake tasks will automatically discover any specs you place in a location matching this file glob:
`./**/Specs/**/*_spec.rb`. Since XCode 4 creates a separate directory for each target, the expected project layout looks
like this:

    > MyProject
      > MyFramework
        - Info.plist
        - MyFrameworkClass.h
        - MyFrameworkClass.m
        > Specs
          - MyFrameworkClass_spec.rb
      - MyProject.xcodeproj
      > spec
        - spec_helper.rb
        > support

## Ruby Versions & Bundler

RXCode has been designed to run under Ruby 1.8.7, 1.9.2, as well as MacRuby. This allows you to write Rake tasks that
can be integrated into a Run Script build phase in XCode, as well as a scheme's pre- and post- actions. However, only
MacRuby is capable of testing your Objective-C code.

Because you will be running RXCode under multiple rubies, using Bundler can really help manage installing all required
gems.

**NOTE**: Bundler versions prior to 1.0.15 had an issue that caused the `exec` and `open` commands fail under MacRuby.
Make sure that you have the latest bundler installed.

## Copyright

Copyright (c) 2011 Vulpine Labs. See LICENSE.txt for further details.