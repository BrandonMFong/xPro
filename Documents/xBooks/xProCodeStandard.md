# xPro c++ coding standard

## Functions
CamelCased names
Boolean Types: 'Is{Function}'

## Variables
camelCased names

## Directory names in Tools folder
The directory must be all lowercased 

## Header guards
Use #ifdef

## Pound define variables
Start with 'd' infront of the variable name 

## Constant Variables
enum, const, etc.  Use 'k' infront of the variable name 

## Global Variables
append variable with 'g', i.e. int gMyVar;

## Code
Define and/or initialize all variables at the beginning of the function

## Classes
Use getters and setters 

public, protected and private sections should be in said order 

members are always private or protected and start with '_' 

Class names should start with x, i.e. xClassName

Only inherity from one other class

Structures is allowed to be public

## Return types
if function affects in class variables, use void

## Structures
Struct name CamelCased
member names camelCased

## References
https://developer.lsst.io/v/DM-5063/docs/cpp_docs.html
https://gist.github.com/derofim/df604f2bf65a506223464e3ffd96a78a 