################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xMain.cpp \
../src/xTests.cpp 

CPP_DEPS += \
./src/xMain.d \
./src/xTests.d 

OBJS += \
./src/xMain.o \
./src/xTests.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli" -I"/src" -I"/src/xLib" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src/xLib" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src

clean-src:
	-$(RM) ./src/xMain.d ./src/xMain.o ./src/xTests.d ./src/xTests.o

.PHONY: clean-src

