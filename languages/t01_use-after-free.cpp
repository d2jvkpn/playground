#include <iostream>
#include <vector>

using namespace std;

int main() {
	// cout << "Hello, world!\n";
	vector<int> v {10, 11};
	int* vptr = &v[1];

	v.push_back(42);

	cout << *vptr << endl;

	return 0;
}
