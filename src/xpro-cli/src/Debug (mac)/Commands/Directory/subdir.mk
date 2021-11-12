################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Commands/Directory/Directory.cpp 

OBJS += \
./Commands/Directory/Directory.o 

CPP_DEPS += \
./Commands/Directory/Directory.d 


# Each subdirectory must supply rules for building sources it contributes
Commands/Directory/%.o: ../Commands/Directory/%.cpp Commands/Directory/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__MACOS__ -I$(XPRO_PATH)/xLib -I$(XPRO_PATH) -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


