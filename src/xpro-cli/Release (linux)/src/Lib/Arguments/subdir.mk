################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Lib/Arguments/xArgs.cpp 

CPP_DEPS += \
./src/Lib/Arguments/xArgs.d 

OBJS += \
./src/Lib/Arguments/xArgs.o 


# Each subdirectory must supply rules for building sources it contributes
src/Lib/Arguments/%.o: ../src/Lib/Arguments/%.cpp src/Lib/Arguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__LINUX__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-Lib-2f-Arguments

clean-src-2f-Lib-2f-Arguments:
	-$(RM) ./src/Lib/Arguments/xArgs.d ./src/Lib/Arguments/xArgs.o

.PHONY: clean-src-2f-Lib-2f-Arguments

