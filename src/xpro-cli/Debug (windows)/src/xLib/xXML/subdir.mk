################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/xLib/xXML/xXML.cpp 

OBJS += \
./src/xLib/xXML/xXML.o 

CPP_DEPS += \
./src/xLib/xXML/xXML.d 


# Each subdirectory must supply rules for building sources it contributes
src/xLib/xXML/%.o: ../src/xLib/xXML/%.cpp src/xLib/xXML/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DDEBUG -D__WINDOWS__ -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src\xLib" -I"B:\SOURCE\Repo\xpro-projects\xpro\src\xpro-cli\src" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

