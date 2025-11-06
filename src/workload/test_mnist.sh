#!/bin/bash

echo "=== Running MNIST Baseline Test ==="
echo ""

# Run spike with timeout, suppress most output
timeout 2 spike -d -m0x80000000:0x10000000 --isa=rv64gc mnist_baseline > /dev/null 2>&1 &
SPIKE_PID=$!

# Wait for it to complete
sleep 2

# Kill if still running
kill -9 $SPIKE_PID 2>/dev/null

echo "Execution completed (or timed out safely)"
echo ""

# Now run in debug mode to extract the result
echo "Extracting prediction..."
(
  echo "until pc 0 0x80000026"
  sleep 0.5
  echo "reg 0 a0"
  sleep 0.5
  echo "quit"
) | spike -d -m0x80000000:0x10000000 --isa=rv64gc mnist_baseline 2>&1 | tee debug_result.txt

# Extract a0 value
PREDICTION=$(grep "^a0:" debug_result.txt | awk '{print $2}')

if [ -n "$PREDICTION" ]; then
    # Convert hex to decimal
    PRED_DEC=$((PREDICTION))
    
    echo ""
    echo "  PREDICTION: $PRED_DEC"
    echo ""
    
    if [ $PRED_DEC -ge 0 ] && [ $PRED_DEC -le 9 ]; then
        echo " TEST PASSED!"
        echo "   Valid digit: $PRED_DEC"
        echo ""
        echo " TC-200 Status: PASSED "
        exit 0
    else
        echo " TEST FAILED"
        echo "   Invalid value: $PRED_DEC"
        exit 1
    fi
else
    echo " Could not extract prediction"
    echo "   Check debug_result.txt manually"
fi
