include windows\win.mak

# nmake 
all: $(EXTERN) $(OBJECTS) $(TOOLS) clean

$(TOOLS) : 
	@echo xPro Tools: $@ 
	@$(CC) /c $(TOOLS_DIR)\$@\main.cpp $(FLAGS) 
	@$(LINK) /out:$(BIN_DIR)\xpro.$@.exe *.obj 

$(EXTERN) : 
	@echo Package: $@ 
	@$(CC) /c $(FRAMEWORK_DIR)\extern\$@ /Fe$@.obj $(FLAGS)

$(OBJECTS) :
	@echo xPro Objects: $@
	@$(CC) /c $(FRAMEWORK_DIR)\$@.cpp /Fe$@.obj $(FLAGS)

clean :
	@echo Cleaning...
	@del *.obj