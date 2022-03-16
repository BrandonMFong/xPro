################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Describe/Describe.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Describe/Describe.d 

OBJS += \
./src/AppDriver/Commands/Describe/Describe.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Describe/%.o: ../src/AppDriver/Commands/Describe/%.cpp src/AppDriver/Commands/Describe/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__LINUX__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Describe

clean-src-2f-AppDriver-2f-Commands-2f-Describe:
	-$(RM) ./src/AppDriver/Commands/Describe/Describe.d ./src/AppDriver/Commands/Describe/Describe.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Describe

