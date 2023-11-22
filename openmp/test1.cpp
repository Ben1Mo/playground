#include <chrono>
#include <iostream>
#include <thread>

#include <omp.h>
#include <stdio.h>

void sleep_for_time() {

  using namespace std::chrono_literals;
  std::this_thread::sleep_for(150ms);
}

int sum_double_serial(int n) {
  int sum = 0;
  for (int i = 0; i <= n; ++i) {
    sum += i;
    for (int j = 0; j <= 120; ++j) {
      sum *= 2;
    }
  }
  return sum;
}

int sum_double_parallel(int n) {
  int sum = 0;
//#pragma omp parallel for reduction(+ : sum)
#pragma omp parallel for collapse(2)
  for (int i = 0; i <= n; ++i) {
    sum += i;
    //#pragma omp tasknowait
    for (int j = 0; j <= 120; ++j) {
      sum *= 2;
    }
  }
  return sum;
}

int main(int argc, char **argv) {

  using std::chrono::duration;
  using std::chrono::duration_cast;
  using std::chrono::high_resolution_clock;
  using std::chrono::milliseconds;

  const int n = 10000000;

  // Operation 1 without OpenMP
  auto t1 = high_resolution_clock::now();
  std::cout << "Hello World.\n";
  auto t2 = high_resolution_clock::now();

  duration<double, std::milli> ms_double1 = t2 - t1;
  std::cout << "Operation 1 (single): " << ms_double1.count() << " ms\n";
  sleep_for_time();

  // Operation 1 with OpenMP
  t1 = high_resolution_clock::now();
#pragma omp parallel
  std::cout << "Hello World.\n";
  t2 = high_resolution_clock::now();

  duration<double, std::milli> ms_double2 = t2 - t1;
  std::cout << "Operation 1 (OpenMP): " << ms_double2.count() << " ms\n";
  sleep_for_time();

  // Operation 2 without OpenMP
  t1 = high_resolution_clock::now();
  sum_double_serial(n);
  t2 = high_resolution_clock::now();

  duration<double, std::milli> ms_double3 = t2 - t1;
  std::cout << "Operation 2 (single): " << ms_double3.count() << " ms\n";
  sleep_for_time();

  // Operation 2 with OpenMP
  t1 = high_resolution_clock::now();
  sum_double_parallel(n);
  t2 = high_resolution_clock::now();

  duration<double, std::milli> ms_double4 = t2 - t1;
  std::cout << "Operation 2 (OpenMP): " << ms_double4.count() << " ms\n";

  return 0;
}
