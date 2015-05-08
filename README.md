Some shell subroutines to work with simple macros via pattern substitution.

```
Usage
    __macro_create() <substituendum> [ <substituens> ]
        Print substitution expression to stdout

    __macro_do() <ARG1> <basis>
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
    % __macro_create "Helo" "Hello!"
    > //Helo/Hello!
    % __macro_create "%s" "Hello!"
    > //[%][s]/Hello!
    % __macro_create "Helo"
    > //Helo
    % MACRO_PATTERN="/%" __macro_create "Hello! "
    > /%/Hello![:space:]
    % __macro_create "%s" "Hello!" | __macro_do : "Salut! %s Ciao!"
    > 'Salut! Hello! Ciao!'
    % MACRO_FILE=<(MACRO_PATTERN=/\# __macro_create "Hello! ") \
      __macro_do : "What?"
    > 'Hello! What?'
```
