# Riak Rolling Average Example

The mHealth API Server provides a common API to applications based on the AT&T Developer Center (ForHealth) platform.  The API Server sits in front of a Riak Database (within Silver Lining), and works in conjuction with the application and user profile information managed within the mHealth middleware application.

## Steps in our example

   * Given a DataPointDocument and a StatisticDocument
   * Set allow_multi to true on StatisticDocument
   * Resolve StatisticDocument conflicts in a meaningful way
   * Add a buch of DataPointDocuments concurrently
   * Retrieve the StatisticDocument answer for a count and rolling average of the data points
