################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xXML/xXML-Parsing.cpp \
../src/xLib/xXML/xXML.cpp 

CPP_DEPS += \
./src/xLib/xXML/xXML-Parsing.d \
./src/xLib/xXML/xXML.d 

OBJS += \
./src/xLib/xXML/xXML-Parsing.o \
./src/xLib/xXML/xXML.o 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xXML/%.o: ../src/xLib/xXML/%.cpp src/xLib/xXML/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__LINUX__ -I$(SOURCE_PATH)/src -I$(SOURCE_PATH)/src/xLib -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11  -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-xLib-2f-xXML

clean-src-2f-xLib-2f-xXML:
	-$(RM) ./src/xLib/xXML/xXML-Parsing.d ./src/xLib/xXML/xXML-Parsing.o ./src/xLib/xXML/xXML.d ./src/xLib/xXML/xXML.o

.PHONY: clean-src-2f-xLib-2f-xXML

