################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xXML/xXML.cpp 

OBJS += \
./src/xLib/xXML/xXML.o 

CPP_DEPS += \
./src/xLib/xXML/xXML.d 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xXML/%.o: ../src/xLib/xXML/%.cpp src/xLib/xXML/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DVERSION="0.0" -D__MACOS__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


