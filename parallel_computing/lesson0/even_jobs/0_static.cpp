// Static work distribution with ~equal job length
// Modified on: 29.11.23 By: Ben1Mo@github

#include <tbb/parallel_for.h>
#include <thread>

#include <algorithm>
#include <chrono>
#include <iterator>
#include <random>
#include <vector>

#include <iostream>

int main() {
  // Create a random number generator
  // uniformly-distributed integer random number generator
  std::random_device rd;
  // Mersenne Twister pseudo-random generator
  std::mt19937 mt(rd());

  // Create 1 distribution
  std::uniform_int_distribution bin(20, 30);

  // Calculate the number elements per bin
  // bit-shift
  int num_work_items = 1 << 18;

  // Create work items (iterator to store the generated values)
  std::vector<int> work_items;

  // generate num_work_items per bin and store values in the reversed of
  // work_items
  std::generate_n(std::back_inserter(work_items), num_work_items,
                  [&] { return bin(mt); });

  // Process all elements in a parallel_for loop
  tbb::parallel_for(tbb::blocked_range<int>(0, num_work_items),
                    [&](tbb::blocked_range<int> r) {
                      for (int i = r.begin(); i < r.end(); i++) {
                        std::this_thread::sleep_for(
                            std::chrono::microseconds(work_items[i]));
                      }
                    },
                    tbb::static_partitioner());

  return 0;
}
