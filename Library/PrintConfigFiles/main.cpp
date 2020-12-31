// xPro

#include <iostream>
#include <string>
#include <experimental/filesystem>
namespace fs = std::experimental::filesystem::v1;

int main(int argc, char *argv[]) 
{
    // Since there should only be two, this is the index to get the argument I want
    int index = 1; 
    std::string path = argv[index];

    // Exit program if this is met
    if (argc > 2)
    {
        std::cout << "Too many arguments" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    for (const auto & entry : fs::directory_iterator(path)) std::cout << entry.path() << std::endl;
  
    return 0;
}