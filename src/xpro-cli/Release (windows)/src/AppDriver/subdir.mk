################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/AppDriver.cpp 

CPP_DEPS += \
./src/AppDriver/AppDriver.d 

OBJS += \
./src/AppDriver/AppDriver.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/%.o: ../src/AppDriver/%.cpp src/AppDriver/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__WINDOWS__ -I"$(SOURCE_PATH)\src\xLib" -I"$(SOURCE_PATH)\src" -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver

clean-src-2f-AppDriver:
	-$(RM) ./src/AppDriver/AppDriver.d ./src/AppDriver/AppDriver.o

.PHONY: clean-src-2f-AppDriver

