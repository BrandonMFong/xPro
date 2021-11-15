"""
Logger.py
============
"""

from    datetime    import datetime
from    sys         import platform 
import  sys
import  os 
import  traceback

class ScriptInfo():
    def __init__(self):
        self.fPath          = sys.path[0]
        self.fName          = os.path.basename(sys.argv[0])
        self.fLastModified  = None

        if platform != "win32":
            stat = os.stat(self.fPath)
            self.fLastModified = datetime.fromtimestamp(stat.st_mtime)

class Logger():
    """
    Logger
    ============
    Log object
    """
    kFatal = "fatal"
    kError = "error"
    kExcept = "exception"
    kWarning = "warning"

    def __init__(self, noTime=True, noLineno=False):
        okayToContinue = True 
        callerName      = str()
        tracebackInfo   = None 

        if okayToContinue:
            tracebackInfo   = traceback.extract_stack(limit=2)
            callerName      = os.path.basename(tracebackInfo[0].filename)
            if callerName is None:
                okayToContinue = False 
                print("{}: error in getting caller's name".format(type(self)))
        if okayToContinue:
            if noLineno:
                self._header = callerName + ":"
            else: 
                self._header = callerName + "({line}):"

            if noTime: 
                self._header += " {logType}"
                self._writeMessage = "{scriptName}:".format(scriptName=callerName)
            else:
                self._header += " {date} - {logType}"
                self._writeMessage = "{scriptName}: {date}:".format(scriptName=callerName)
            
            self._datetimeFormat    = "%d/%m/%Y %H:%M:%S"

    def Fatal(self,*args,**kargs):
        tb = traceback.extract_stack(limit=2)
        message = self._header.format(line=tb[0].lineno,logType="{}:".format(self.kFatal),date=datetime.now().strftime(self._datetimeFormat))
        print(message, *args, **kargs)

    def Error(self,*args,**kargs):
        tb = traceback.extract_stack(limit=2)
        message = self._header.format(line=tb[0].lineno,logType="{}:".format(self.kError), date=datetime.now().strftime(self._datetimeFormat))
        print(message, *args, **kargs)

    def Write(self,*args,**kargs):
        message = self._writeMessage.format(date=datetime.now().strftime(self._datetimeFormat))
        print(message,*args,**kargs)

    def Except(self,*args,**kargs):
        """
        Except
        ===========
        Suggested method to called when inside an except block.  This log will print out the line that failed 
        """
        _, _, exception_traceback = sys.exc_info()
        line_number = exception_traceback.tb_lineno
        message = self._header.format(date=datetime.now().strftime(self._datetimeFormat), logType="{} (line:{}):".format(self.kExcept,line_number), line="")
        print(message, *args, **kargs)

    def Warning(self,*args,**kargs):
        message = self._header.format(date=datetime.now().strftime(self._datetimeFormat), logType="{}:".format(self.kWarning))
        print(message, *args, **kargs)