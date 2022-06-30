################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Object/Object.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Object/Object.d 

OBJS += \
./src/AppDriver/Commands/Object/Object.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Object/%.o: ../src/AppDriver/Commands/Object/%.cpp src/AppDriver/Commands/Object/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__WINDOWS__ -I"$(SOURCE_PATH)\src\Lib" -I"$(SOURCE_PATH)\src" -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Object

clean-src-2f-AppDriver-2f-Commands-2f-Object:
	-$(RM) ./src/AppDriver/Commands/Object/Object.d ./src/AppDriver/Commands/Object/Object.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Object

