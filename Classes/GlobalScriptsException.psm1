class GlobalScriptsException : Exception
{
   GlobalScriptsException(){}
   GlobalScriptsException([string]$msg) : base($msg){}
   GlobalScriptsException([string]$msg, [Exception]$inner) : base($msg, $inner){}
}   