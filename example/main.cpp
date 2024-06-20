#include <iostream>
#include <Person.pb.h>
#include <fstream>

int main()
{
    Person p;
    p.set_name("张三");
    std::ofstream file("123.bin");
    p.SerializeToOstream(&file);
    file.flush();
    Person p2;
    std::ifstream input("123.bin");
    p2.ParseFromIstream(&input);
    std::cout << p2.name();
    std::cout << "\n------------------------------\n";
    return 0;
}