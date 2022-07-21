################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/Lib/xUtilities/xFileSystemUtil.c \
../src/Lib/xUtilities/xStringUtil.c \
../src/Lib/xUtilities/xUtilities.c 

C_DEPS += \
./src/Lib/xUtilities/xFileSystemUtil.d \
./src/Lib/xUtilities/xStringUtil.d \
./src/Lib/xUtilities/xUtilities.d 

OBJS += \
./src/Lib/xUtilities/xFileSystemUtil.o \
./src/Lib/xUtilities/xStringUtil.o \
./src/Lib/xUtilities/xUtilities.o 


# Each subdirectory must supply rules for building sources it contributes
src/Lib/xUtilities/%.o: ../src/Lib/xUtilities/%.c src/Lib/xUtilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -DTESTING -D__WINDOWS__ -I"$(SOURCE_PATH)\src\xLib" -I"$(SOURCE_PATH)\src" -O0 -g3 -Wall -c -fmessage-length=0 -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-Lib-2f-xUtilities

clean-src-2f-Lib-2f-xUtilities:
	-$(RM) ./src/Lib/xUtilities/xFileSystemUtil.d ./src/Lib/xUtilities/xFileSystemUtil.o ./src/Lib/xUtilities/xStringUtil.d ./src/Lib/xUtilities/xStringUtil.o ./src/Lib/xUtilities/xUtilities.d ./src/Lib/xUtilities/xUtilities.o

.PHONY: clean-src-2f-Lib-2f-xUtilities

