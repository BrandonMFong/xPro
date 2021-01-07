# xPro c++ coding standard


## Functions
CamelCased names

## Variables
camelCased names

## Directory names in Sources folder
The directory must be all lowercased 

## Headers
Use #ifdef

## Global Variables
append variable with g, i.e. int gMyVar;

## Macros order 
includes
namespaces
define 
typedef
includes for personal file

## Code
Define and/or initialize all variables at the beginning of the function

## Classes
User getters and setters 
public, protected and private sections should be in said order 
members are always private
Class names should start with x, i.e. xClassName
Only inherity from one other class

## Return types
if function affects in class variables, use void

## References
https://developer.lsst.io/v/DM-5063/docs/cpp_docs.html
https://gist.github.com/derofim/df604f2bf65a506223464e3ffd96a78a 