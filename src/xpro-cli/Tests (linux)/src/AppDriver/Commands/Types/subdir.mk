################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Types/Dictionary.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Types/Dictionary.d 

OBJS += \
./src/AppDriver/Commands/Types/Dictionary.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Types/%.o: ../src/AppDriver/Commands/Types/%.cpp src/AppDriver/Commands/Types/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__LINUX__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src/External/lib/cpplib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11  -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Types

clean-src-2f-AppDriver-2f-Commands-2f-Types:
	-$(RM) ./src/AppDriver/Commands/Types/Dictionary.d ./src/AppDriver/Commands/Types/Dictionary.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Types

