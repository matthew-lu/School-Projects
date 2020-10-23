# This program can be called on to create a queue that stores pairs (x, n) where x is
# an element and n is the count of the number of occurences of x.
# Included are methods to manipulate the Counting Queue. 

class CountingQueue(object):
    
    def __init__(self):
        self.queue = []
        
    def __repr__(self):
        return repr(self.queue)
    
    def add(self, x, count=1):
        if len(self.queue) > 0:
            xx, cc = self.queue[-1]
            if xx == x:
                self.queue[-1] = (xx, cc + count)
            else:
                self.queue.append((x, count))
        else:
            self.queue = [(x, count)]
            
    def get(self):
        if len(self.queue) == 0:
            return None
        x, c = self.queue[0]
        if c == 1:
            self.queue.pop(0)
            return x
        else:
            self.queue[0] = (x, c - 1)
            return x
        
    def isempty(self):
        return len(self.queue) == 0

    def countingqueue_len(self):
        """Returns the number of elements in the queue."""
        l = self.queue
        count = 0
        for x, i in l:
            for y in range(i):
                count += 1
        return count
    
    def countingqueue_iter(self):
        """Iterates through all the elements of the queue,
        without removing them."""
        l = self.queue
        for i, x in l:
            for y in range(x):
                yield i
    
    def subsets(s):
        """Given a set s, yield all the subsets of s,
        including s itself and the empty set."""
        temp = list(s)
        if len(s) == 0:
            return [[]]
        subset = list(subsets(temp[1:]))
        answer = list(subset)
        for x in subset:
            answer.append(x+[temp[0]])
        return answer
        return s