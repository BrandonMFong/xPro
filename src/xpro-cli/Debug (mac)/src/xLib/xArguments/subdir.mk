################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xArguments/xArgs.cpp 

OBJS += \
./src/xLib/xArguments/xArgs.o 

CPP_DEPS += \
./src/xLib/xArguments/xArgs.d 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xArguments/%.o: ../src/xLib/xArguments/%.cpp src/xLib/xArguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DVERSION="0.0" -D__MACOS__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


