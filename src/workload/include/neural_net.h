#ifndef NEURAL_NET_H
#define NEURAL_NET_H

#include <stdint.h>

// Network architecture
#define INPUT_SIZE 28       // Changed from 784
#define HIDDEN_SIZE 8       // Changed from 128  
#define OUTPUT_SIZE 10

// Neural network structure
typedef struct {
    float weights_input_hidden[INPUT_SIZE][HIDDEN_SIZE];
    float weights_hidden_output[HIDDEN_SIZE][OUTPUT_SIZE];
    float bias_hidden[HIDDEN_SIZE];
    float bias_output[OUTPUT_SIZE];
} NeuralNetwork;

// Function declarations
void init_network(NeuralNetwork *nn);
int predict(NeuralNetwork *nn, float *input);

// UPDATED function prototype
void matrix_multiply(float *input, float *weights, float *output, 
                     int input_size, int output_size, int weight_cols);

float relu(float x);
void softmax(float *input, int size);

#endif // NEURAL_NET_H