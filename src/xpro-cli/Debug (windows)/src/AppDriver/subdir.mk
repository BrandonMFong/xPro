################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/AppDriver.cpp 

OBJS += \
./src/AppDriver/AppDriver.o 

CPP_DEPS += \
./src/AppDriver/AppDriver.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/%.o: ../src/AppDriver/%.cpp src/AppDriver/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__WINDOWS__ -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli" -I"/src" -I"/src/xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -O0 -g3 -Wall -c -fmessage-length=0 -Wno-unknown-pragmas -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


