# `project.pbxproj` File Structure

XCode stores project-related information in a file called 'project.pbxproj' inside the xcodeproj package. This file is an archive created with NSKeyedArchiver, which basically means it's an object-graph encoded as a dictionary.

This file documents the structure of this object graph, as understood by rxcode. The `project.pbxproj` file is not a standard in any way so this will change over time. That said, this file seems to go back to the days of Project Builder, so it's been around the block a few times. Newer XCode file formats all seem to be XML-based, though, so it's likely that the project data will become *more* parsable in the future, not less.

## Basic Structure of the File

You can think of the `project.pbxproj` file as just a dictionary serialized to disk. `rxcode` unwraps the data from the file into a Ruby Hash. If you were to create an empty XCode project using the 'Empty' XCode project template, the unwrapped data would look something like this:

    {
      "buildConfigurationList"=> {
        "buildConfigurations" => [
          {"buildSettings"=>{}, "isa"=>"XCBuildConfiguration", "name"=>"Debug"},
          {"buildSettings"=>{}, "isa"=>"XCBuildConfiguration", "name"=>"Release"}
        ],
        "defaultConfigurationIsVisible"=>"0",
        "defaultConfigurationName"=>"Release",
        "isa"=>"XCConfigurationList"
      },
      "compatibilityVersion"=>"Xcode 3.2",
      "developmentRegion"=>"English",
      "hasScannedForEncodings"=>"0",
      "isa"=>"PBXProject",
      "knownRegions"=>["en"],
      "mainGroup"=> { "children"=>[], "isa"=>"PBXGroup", "sourceTree"=>"<group>" },
      "projectDirPath"=>"",
      "projectRoot"=>"",
      "targets"=>[]
    }

Notice that each hash in the example has an 'isa' key that identifies what type of data it represents. At the top level we have a 'PBXProject', and at other levels we have 'XCBuildConfiguration', 'XCConfigurationList', and 'PBXGroup'. These probably are the names of classes XCode uses internally, and can be used to determine what different parts of the file do.

## `PBXProject` Objects

The root `PBXProject` hash primarily contains targets, build configurations, and a root PBXGroup, which contains varius file references.

## `XCBuildConfiguration` Objects

A `XCBuildConfiguration` represents an XCode build configuration like 'Debug' or 'Release'. Besides their names, they seem to contain build settings provided to scripts and the compiler.

## `XCConfigurationList` Object

A list of `XCBuildConfiguration` objects, plus some info about which is the default configuration.

## `PBXGroup` Objects

A group of file references.