################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Lib/xArguments/xArgs.cpp 

CPP_DEPS += \
./src/Lib/xArguments/xArgs.d 

OBJS += \
./src/Lib/xArguments/xArgs.o 


# Each subdirectory must supply rules for building sources it contributes
src/Lib/xArguments/%.o: ../src/Lib/xArguments/%.cpp src/Lib/xArguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__MACOS__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-Lib-2f-xArguments

clean-src-2f-Lib-2f-xArguments:
	-$(RM) ./src/Lib/xArguments/xArgs.d ./src/Lib/xArguments/xArgs.o

.PHONY: clean-src-2f-Lib-2f-xArguments

