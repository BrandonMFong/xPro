// xPro
// g++ main.cpp -lstdc++fs -

#include <iostream>
#include <string>
#include <experimental/filesystem>
namespace fs = std::experimental::filesystem::v1;

int main(int argc, char *argv[]) 
{
    // Since there should only be two, this is the index to get the argument I want
    int index = 1; 
    std::string path;

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    path = argv[index];

    std::string filepath;
    for (const auto & entry : fs::directory_iterator(path)) 
    {
        filepath = entry.path();
        std::cout << filepath << std::endl;
    }
  
    return 0;
}