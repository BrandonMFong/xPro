################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Directory/Directory.cpp 

OBJS += \
./src/AppDriver/Commands/Directory/Directory.o 

CPP_DEPS += \
./src/AppDriver/Commands/Directory/Directory.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Directory/%.o: ../src/AppDriver/Commands/Directory/%.cpp src/AppDriver/Commands/Directory/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I"/Users/brandonmfong/brando/sources/repo/xPro/src/xpro-cli" -I"/src" -I"/src/xLib" -I"/Users/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src" -I"/Users/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src/xLib" -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

