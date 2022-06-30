################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/Lib/Utilities/FileSystem.c \
../src/Lib/Utilities/String.c 

C_DEPS += \
./src/Lib/Utilities/FileSystem.d \
./src/Lib/Utilities/String.d 

OBJS += \
./src/Lib/Utilities/FileSystem.o \
./src/Lib/Utilities/String.o 


# Each subdirectory must supply rules for building sources it contributes
src/Lib/Utilities/%.o: ../src/Lib/Utilities/%.c src/Lib/Utilities/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -DDEBUG -D__WINDOWS__ -I"$(SOURCE_PATH)\src\Lib" -I"$(SOURCE_PATH)\src" -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -DVERSION=$(VERSION_STRING) -DBUILD=$(BUILD_HASH) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-Lib-2f-Utilities

clean-src-2f-Lib-2f-Utilities:
	-$(RM) ./src/Lib/Utilities/FileSystem.d ./src/Lib/Utilities/FileSystem.o ./src/Lib/Utilities/String.d ./src/Lib/Utilities/String.o

.PHONY: clean-src-2f-Lib-2f-Utilities

