################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/AppDriver/Commands/Version/Version.cpp 

OBJS += \
./src/AppDriver/Commands/Version/Version.o 

CPP_DEPS += \
./src/AppDriver/Commands/Version/Version.d 


# Each subdirectory must supply rules for building sources it contributes
src/AppDriver/Commands/Version/%.o: ../src/AppDriver/Commands/Version/%.cpp src/AppDriver/Commands/Version/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -DTESTING -D__WINDOWS__ -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli" -I"/src" -I"/src/xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -O0 -g3 -Wall -c -fmessage-length=0 -DVERSION=$(VERSION_STRING) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

