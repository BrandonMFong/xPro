################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/xLib/xUtilities/xFileSystemUtil.c \
../src/xLib/xUtilities/xStringUtil.c \
../src/xLib/xUtilities/xUtilities.c 

C_DEPS += \
./src/xLib/xUtilities/xFileSystemUtil.d \
./src/xLib/xUtilities/xStringUtil.d \
./src/xLib/xUtilities/xUtilities.d 

OBJS += \
./src/xLib/xUtilities/xFileSystemUtil.o \
./src/xLib/xUtilities/xStringUtil.o \
./src/xLib/xUtilities/xUtilities.o 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xUtilities/%.o: ../src/xLib/xUtilities/%.c src/xLib/xUtilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -DTESTING -D__MACOS__ -I$(SOURCE_PATH)/src -I$(SOURCE_PATH)/src/xLib -O0 -g3 -Wall -c -fmessage-length=0 -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-xLib-2f-xUtilities

clean-src-2f-xLib-2f-xUtilities:
	-$(RM) ./src/xLib/xUtilities/xFileSystemUtil.d ./src/xLib/xUtilities/xFileSystemUtil.o ./src/xLib/xUtilities/xStringUtil.d ./src/xLib/xUtilities/xStringUtil.o ./src/xLib/xUtilities/xUtilities.d ./src/xLib/xUtilities/xUtilities.o

.PHONY: clean-src-2f-xLib-2f-xUtilities

