################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../xLib/xArguments/xArgs.cpp 

OBJS += \
./xLib/xArguments/xArgs.o 

CPP_DEPS += \
./xLib/xArguments/xArgs.d 


# Each subdirectory must supply rules for building sources it contributes
xLib/xArguments/%.o: ../xLib/xArguments/%.cpp xLib/xArguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__MACOS__ -I$(XPRO_PATH)/xLib -I$(XPRO_PATH) -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


