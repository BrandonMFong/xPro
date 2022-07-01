################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/External/lib/clib/clib.c \
../src/External/lib/clib/tests.c 

C_DEPS += \
./src/External/lib/clib/clib.d \
./src/External/lib/clib/tests.d 

OBJS += \
./src/External/lib/clib/clib.o \
./src/External/lib/clib/tests.o 


# Each subdirectory must supply rules for building sources it contributes
src/External/lib/clib/%.o: ../src/External/lib/clib/%.c src/External/lib/clib/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DRELEASE -D__LINUX__ -I$(SOURCE_PATH)/src/Lib -I$(SOURCE_PATH)/src/External/lib/clib -I$(SOURCE_PATH)/src -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-External-2f-lib-2f-clib

clean-src-2f-External-2f-lib-2f-clib:
	-$(RM) ./src/External/lib/clib/clib.d ./src/External/lib/clib/clib.o ./src/External/lib/clib/tests.d ./src/External/lib/clib/tests.o

.PHONY: clean-src-2f-External-2f-lib-2f-clib

