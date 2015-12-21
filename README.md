Some shell subroutines to work with simple macros via pattern substitution.

```
Usage
    Macro::Create <substituendum> [ <substituens> ]
        Print substitution expression to stdout

    Macro::Do() <ARG1> <basis>
        Do the pattern substitution

Arguments
    <ARG1>                      ( : | <name> )
    :                           Print the result to stdout
    <name>                      Name of the variable to have the result in store
    <basis>                     String
    <substituendum>             String
    <substituens>               String

Environment variables
    MACRO_FILE                  File name (regular or named pipe)
    MACRO_PATTERN               Determine the substitution (default is "//"):
                                "/", "//", "/%" or "/#"
Examples
    % Macro::Create "Helo" "Hello!"
    > //Helo/Hello!
    % Macro::Create "%s" "Hello!"
    > //[%][s]/Hello!
    % Macro::Create "Helo"
    > //Helo
    % MACRO_PATTERN="/%" Macro::Create "Hello! "
    > /%/Hello![:space:]
    % Macro::Create "%s" "Hello!" | Macro::Do : "Salut! %s Ciao!"
    > 'Salut! Hello! Ciao!'
    % MACRO_FILE=<(MACRO_PATTERN=/\# Macro::Create "Hello! ") \
      Macro::Do : "What?"
    > 'Hello! What?'
```
