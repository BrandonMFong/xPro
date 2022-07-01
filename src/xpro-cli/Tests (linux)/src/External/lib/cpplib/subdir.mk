################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/External/lib/cpplib/tests.cpp 

CPP_DEPS += \
./src/External/lib/cpplib/tests.d 

OBJS += \
./src/External/lib/cpplib/tests.o 


# Each subdirectory must supply rules for building sources it contributes
src/External/lib/cpplib/%.o: ../src/External/lib/cpplib/%.cpp src/External/lib/cpplib/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__LINUX__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src/External/lib/cpplib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11  -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-External-2f-lib-2f-cpplib

clean-src-2f-External-2f-lib-2f-cpplib:
	-$(RM) ./src/External/lib/cpplib/tests.d ./src/External/lib/cpplib/tests.o

.PHONY: clean-src-2f-External-2f-lib-2f-cpplib

