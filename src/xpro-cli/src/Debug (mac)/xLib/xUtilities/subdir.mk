################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../xLib/xUtilities/xFileSystemUtil.c \
../xLib/xUtilities/xStringUtil.c \
../xLib/xUtilities/xUtilities.c 

OBJS += \
./xLib/xUtilities/xFileSystemUtil.o \
./xLib/xUtilities/xStringUtil.o \
./xLib/xUtilities/xUtilities.o 

C_DEPS += \
./xLib/xUtilities/xFileSystemUtil.d \
./xLib/xUtilities/xStringUtil.d \
./xLib/xUtilities/xUtilities.d 


# Each subdirectory must supply rules for building sources it contributes
xLib/xUtilities/%.o: ../xLib/xUtilities/%.c xLib/xUtilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -D__MACOS__ -I$(XPRO_PATH)/xLib -I$(XPRO_PATH) -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


