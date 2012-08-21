# Riak Rolling Average Example

Provide an example of using vector clocks and a rolling average
algorithm to track the average of values in Ripple documents.

Requires a test Riak node to be running. Memory backend recommended.

## Steps in our example

   * Given a DataPointDocument and a StatisticDocument
   * Set allow_multi to true on StatisticDocument
   * Resolve StatisticDocument conflicts in a meaningful way
   * Add a buch of DataPointDocuments concurrently
   * Retrieve the StatisticDocument answer for a count and rolling average of the data points
