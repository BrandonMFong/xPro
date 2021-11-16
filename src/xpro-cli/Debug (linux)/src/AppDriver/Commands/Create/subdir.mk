################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Create/Create.cpp 

OBJS += \
./src/AppDriver/Commands/Create/Create.o 

CPP_DEPS += \
./src/AppDriver/Commands/Create/Create.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Create/%.o: ../src/AppDriver/Commands/Create/%.cpp src/AppDriver/Commands/Create/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__LINUX__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


