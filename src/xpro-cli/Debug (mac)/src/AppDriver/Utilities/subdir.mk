################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/AppDriver/Utilities/Utilities.c 

OBJS += \
./src/AppDriver/Utilities/Utilities.o 

C_DEPS += \
./src/AppDriver/Utilities/Utilities.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Utilities/%.o: ../src/AppDriver/Utilities/%.c src/AppDriver/Utilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -D__MACOS__ -I$(SOURCE_PATH)/src/xLib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


