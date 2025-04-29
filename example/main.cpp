#include <iostream>
#include <Person.pb.h>
#include <fstream>

int main()
{
    Person p;
    p.set_name("张三");
    std::ofstream file("test.bin");
    p.SerializeToOstream(&file);
    file.flush();
    Person p2;
    std::ifstream input("test.bin");
    p2.ParseFromIstream(&input);
    std::cout << p2.name();
    std::cout << "\n------------------------------\n";
    return 0;
}