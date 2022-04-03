[![Archive](https://github.com/BrandonMFong/xPro/actions/workflows/main.yml/badge.svg)](https://github.com/BrandonMFong/xPro/actions/workflows/main.yml)

# xPro 

XML Profile (xPro) is a project I started to allow me to use an xml file to define my shell profile.  Like previous iterations of xPro, the core functionality allows the user to define shell variables and aliases.  

An additional feature allows the user to define key/value pairs where the values are paths to a directory in the system and using a utility shell function `goto` would `cd` you directly into the keyed value directory. 

Version 5+ supports cross platform usage.  Previous versions (all of which reached end of life) only supports windows platforms using powershell. 

## Building
- Setup your development environment:
    - Unix/Linux: `sudo devenv.py create`
    - Windows: 
        - Run as administrator: `devenv.py create`
- `build.py`

## Testing
- `run-tests.py`

## Authors 
- Brando
