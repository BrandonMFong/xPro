################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xArguments/xArgs.cpp 

CPP_DEPS += \
./src/xLib/xArguments/xArgs.d 

OBJS += \
./src/xLib/xArguments/xArgs.o 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xArguments/%.o: ../src/xLib/xArguments/%.cpp src/xLib/xArguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DRELEASE -D__WINDOWS__ -I"$(SOURCE_PATH)\src\xLib" -I"$(SOURCE_PATH)\src" -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-xLib-2f-xArguments

clean-src-2f-xLib-2f-xArguments:
	-$(RM) ./src/xLib/xArguments/xArgs.d ./src/xLib/xArguments/xArgs.o

.PHONY: clean-src-2f-xLib-2f-xArguments

