################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../xUtilities/xUtilities.c 

OBJS += \
./xUtilities/xUtilities.o 

C_DEPS += \
./xUtilities/xUtilities.d 


# Each subdirectory must supply rules for building sources it contributes
xUtilities/%.o: ../xUtilities/%.c xUtilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -I"/Users/brandonmfong/brando/2021/sources/repo/xPro/lib/c++" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


