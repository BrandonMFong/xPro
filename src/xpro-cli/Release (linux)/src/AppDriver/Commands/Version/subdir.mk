################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Version/Version.cpp 

OBJS += \
./src/AppDriver/Commands/Version/Version.o 

CPP_DEPS += \
./src/AppDriver/Commands/Version/Version.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Version/%.o: ../src/AppDriver/Commands/Version/%.cpp src/AppDriver/Commands/Version/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__LINUX__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


