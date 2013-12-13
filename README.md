# Verify In Files

Verify In Files is a [Ruby][] application that can check the contents of files based on a custom set of rules.

With Verify In Files, one or more files can be tested against a set of rules from simple (e.g. find a string) to complex (e.g. file must have string A and string B, or it can have string C).

## Applications

Some possible uses of Verify In Files:

- Check the contents of test reports or captured output
- Check contents of a log file
- Check the contents of a web query response

## Verification Criteria (Rules)

File are verified based on a set of rules provided by the user.  Rules may be specified as a heirarchy of AND and OR conditions containing one or more HAS or NOT strings.  The rules can be written in JSON or YAML format.  Below is an example of a simple set of rules in JSON format.

```json
{"And": [
  {"Has": "lorem"},
  {"Has": "ipsum"}
  ]
}
```

This says that a text file must contain both "lorem" and "ipsum" in order to pass.

```json
[
  {"And": [
    {"Has": "lorem"},
    {"Or": [
      {"Has": "malesuada"},
      {"Has": "faucibus"},
      {"Has": "foobarus"}
      ]
    },
    {"Has": "ipsum"}
    ]
  },
  {"Or": [
    {"Has": "magna"},
    {"Has": "aabbccdd"}
    ]
  }
]
```

This contains two conditions at the top level--and And and an Or--each with nested rules within them.  In JSON, curly braces represent an object, while square brackets signify an array of object.  More more information about these formats, see [JSON][] or [YAML][].

## Usage

```bash
Usage: verify_in_files [options]
        --file=[TARGET]              File(s) to verify. Separate multiple files with commas (,)
        --rules=[RULES]              File containing verification rules.
    -h, --help                       Show this message
```

## Example

For this example, we will be checking a file to see if it contains the text: "in culpa qui officia" and "sapien risus a quam".  First, we create a file containing the corresponding rules:
##### rules.json
```json
{"And": [
  {"Has": "in culpa qui officia"},
  {"Has": "sapien risus a quam"}
  ]
}
```
A sample Lorem Ipsum input file can be found [here][lorem ipsum]. (What the heck is [lorem ipsum][what is lorem ipsum]?)

The following command can be entered to verify the contents of a file named "lorem_ipsum.txt" (in a subdirectory named "data") using rules defined in "rules.json" (also in a subdirectory named "data").

```bash
$ ruby bin/verify_in_files.rb --file=data/lorem_ipsum.txt --rules=data/rules.json
```
##### Output

```bash
$ ruby bin/verify_in_files.rb --file=data/lorem_ipsum.txt --rules=data/rules.json
Target file(s): data/lorem_ipsum.txt
Criteria file: data/rules.json

Reading JSON file: data/rules.json
And
 Has: in culpa qui officia
 Has: sapien risus a quam

Processing file: data/lorem_ipsum.txt
PASS
```

[Ruby]: https://www.ruby-lang.org/
[JSON]: http://en.wikipedia.org/wiki/Json
[YAML]: http://en.wikipedia.org/wiki/YAML
[lorem ipsum]: https://github.com/allaning/verify-in-files/blob/master/test/data/lorem_ipsum.txt
[what is lorem ipsum]: http://en.wikipedia.org/wiki/Lorem_ipsum
