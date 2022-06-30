################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Directory/Directory.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Directory/Directory.d 

OBJS += \
./src/AppDriver/Commands/Directory/Directory.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Directory/%.o: ../src/AppDriver/Commands/Directory/%.cpp src/AppDriver/Commands/Directory/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__MACOS__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Directory

clean-src-2f-AppDriver-2f-Commands-2f-Directory:
	-$(RM) ./src/AppDriver/Commands/Directory/Directory.d ./src/AppDriver/Commands/Directory/Directory.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Directory

