################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Version/Version.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Version/Version.d 

OBJS += \
./src/AppDriver/Commands/Version/Version.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Version/%.o: ../src/AppDriver/Commands/Version/%.cpp src/AppDriver/Commands/Version/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli" -I"/src" -I"/src/xLib" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src/xLib" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Version

clean-src-2f-AppDriver-2f-Commands-2f-Version:
	-$(RM) ./src/AppDriver/Commands/Version/Version.d ./src/AppDriver/Commands/Version/Version.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Version

