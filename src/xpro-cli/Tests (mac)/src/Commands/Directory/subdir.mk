################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Commands/Directory/Directory.cpp 

OBJS += \
./src/Commands/Directory/Directory.o 

CPP_DEPS += \
./src/Commands/Directory/Directory.d 


# Each subdirectory must supply rules for building sources it contributes
src/Commands/Directory/%.o: ../src/Commands/Directory/%.cpp src/Commands/Directory/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__MACOS__ -I$(SOURCE_PATH)/src -I$(SOURCE_PATH)/src/xLib -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


