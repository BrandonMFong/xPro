################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xMain.cpp \
../src/xTests.cpp 

OBJS += \
./src/xMain.o \
./src/xTests.o 

CPP_DEPS += \
./src/xMain.d \
./src/xTests.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__MACOS__ -I$(SOURCE_PATH)/src -I$(SOURCE_PATH)/src/xLib -O0 -g3 -Wall -c -fmessage-length=0 -std=c++11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

