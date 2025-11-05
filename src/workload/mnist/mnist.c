#include "../include/neural_net.h"

// Simple pseudo-random number generator
static unsigned int seed = 42;
int simple_rand() {
    seed = seed * 1103515245 + 12345;
    return (seed / 65536) % 32768;
}

void simple_srand(unsigned int s) {
    seed = s;
}

NeuralNetwork nn;

// Main function - bare metal version
int main() {
    // Initialize random seed
    simple_srand(42);
    
    // Create neural network (using the global instance)
    init_network(&nn);
    
    // Create a test input (784 pixels)
    float test_image[INPUT_SIZE];
    for (int i = 0; i < INPUT_SIZE; i++) {
        test_image[i] = (float)(simple_rand() % 256) / 255.0f;
    }
    
    // Run inference
    int prediction = predict(&nn, test_image);
    
    // Return prediction as exit code
    return prediction;
}