################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xArguments/xArgs.cpp 

OBJS += \
./src/xLib/xArguments/xArgs.o 

CPP_DEPS += \
./src/xLib/xArguments/xArgs.d 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xArguments/%.o: ../src/xLib/xArguments/%.cpp src/xLib/xArguments/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__WINDOWS__ -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

