#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {
    int i, n;
    bool isPrime = true;

    if(argc == 1) {
        cout << "Enter a positive integer: ";
        cin >> n;
    }
    else {
        n = stoi(argv[1]);
    }

    // 0 and 1 are not prime numbers
    if (n == 0 || n == 1) {
        isPrime = false;
    }
    else {
        for (i = 2; i <= n / 2; ++i) {
            if (n % i == 0) {
                isPrime = false;
                break;
            }
        }
    }
    if (isPrime)
        cout << n << " is a prime number";
    else
        cout << n << " is not a prime number ";

    cout << endl;
    return 0;
}
