################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Alias/Alias.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Alias/Alias.d 

OBJS += \
./src/AppDriver/Commands/Alias/Alias.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Alias/%.o: ../src/AppDriver/Commands/Alias/%.cpp src/AppDriver/Commands/Alias/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__LINUX__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src/External/lib/cpplib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Alias

clean-src-2f-AppDriver-2f-Commands-2f-Alias:
	-$(RM) ./src/AppDriver/Commands/Alias/Alias.d ./src/AppDriver/Commands/Alias/Alias.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Alias

