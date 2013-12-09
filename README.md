# Verify in Files

Check contents of files (e.g. test reports) based on rules defined by the user.

Files can be tested against a set of rules from simple (e.g. text file has a
given string) to complex (e.g. text file has string A and string B, or it has
string C, etc.).

## Verification Criteria (Rules)
Rules may be specified as a heirarchy of AND and OR conditions containing one
or more HAS or NOT strings, as desired.  The rules can be in JSON or YAML format.  Below is an example of a simple set of rules in JSON format.

```
{"And": [
  {"Has": "lorem"},
  {"Has": "ipsum"}
  ]
}
```

This says that a text file must contain the strings "lorem" and "ipsum" in
order to pass.

```
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

This contains two conditions at the top level--And and Or--each with nested
rules within them.  In JSON, curly braces represent an object, which square
brackets signify an array of objects.

## Usage

```
Usage: verify_in_files [options]
        --file=[TARGET]              File(s) to verify. Separate multiple files with commas (,)
        --rules=[RULES]              File containing verification rules.
    -h, --help                       Show this message
```

NOTE: This project is in progress.

