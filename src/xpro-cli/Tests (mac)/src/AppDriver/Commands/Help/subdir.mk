################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Help/Help.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Help/Help.d 

OBJS += \
./src/AppDriver/Commands/Help/Help.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Help/%.o: ../src/AppDriver/Commands/Help/%.cpp src/AppDriver/Commands/Help/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__MACOS__ -I$(SOURCE_PATH)/src -I$(SOURCE_PATH)/src/xLib -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Help

clean-src-2f-AppDriver-2f-Commands-2f-Help:
	-$(RM) ./src/AppDriver/Commands/Help/Help.d ./src/AppDriver/Commands/Help/Help.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Help

