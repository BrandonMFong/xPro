################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Create/Create.cpp 

CPP_DEPS += \
./src/AppDriver/Commands/Create/Create.d 

OBJS += \
./src/AppDriver/Commands/Create/Create.o 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Create/%.o: ../src/AppDriver/Commands/Create/%.cpp src/AppDriver/Commands/Create/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli" -I"/src" -I"/src/xLib" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src" -I"/home/brandonmfong/brando/sources/repo/xPro/src/xpro-cli/src/xLib" -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src-2f-AppDriver-2f-Commands-2f-Create

clean-src-2f-AppDriver-2f-Commands-2f-Create:
	-$(RM) ./src/AppDriver/Commands/Create/Create.d ./src/AppDriver/Commands/Create/Create.o

.PHONY: clean-src-2f-AppDriver-2f-Commands-2f-Create

