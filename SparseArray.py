# In this program, the class SparseArrayDict was given to me by the professor.
# It creates a sparse array by storing non-default elements in a dictionary.

# I implemented the sparse_array_dict_add, sparse_array_dict_sub, and
# sparse_array_dict_eq methods; which add or subtract these objects or show
# if they're equal or not.

class SparseArrayDict:
  
  def __init__(self, *args, default=0., size=None):
      self.d = {}
      self.default = default
      if len(args) > 0:
          self.length = len(args)
          for i, x in enumerate(args):
              if x != default:
                  self.d[i] = x
      if size is not None:
          self.length = size
      elif len(args) > 0:
          self.length = len(args)
      else:
          raise UndefinedSizeArray
          
  def __repr__(self):
      if len(self) <= 10:
          return repr(list(self))
      else:
          s = "The array is a {}-long array of {},".format(
              self.length, self.default
          )
          s += " with the following exceptions:\n"
          ks = list(self.d.keys())
          ks.sort()
          s += "\n".join(["{}: {}".format(k, self.d[k]) for k in ks])
          return s
  
  def __setitem__(self, i, x):
      assert isinstance(i, int) and i >= 0
      if x == self.default:
          if i in self.d:
              del self.d[i]
      else:
          self.d[i] = x
      self.length = max(self.length, i + 1)
  
  def __getitem__(self, i):
      if i >= self.length:
          raise IndexError()
      return self.d.get(i, self.default)
  
  def __len__(self):
      return self.length
  
  def __iter__(self):
      for i in range(len(self)):
          yield self[i]
  
  def storage_len(self):
      return len(self.d)

  

  def sparse_array_dict_add(self, other):
    newarray = SparseArrayDict(size = max(len(self),len(other)))
    newarray.default = self.default + other.default
    i = 0
    for a in self:
      if a != self.default:
        newarray[i] += (a - self.default)
      i += 1
    i = 0
    for b in other:
      if b != other.default:
        newarray[i] += (b - other.default) 
      i += 1
    return newarray

  def sparse_array_dict_sub(self, other):
    newarray = SparseArrayDict(size = max(len(self),len(other)))
    newarray.default = self.default - other.default
    i = 0
    for a in self:
      if a != self.default:
        newarray[i] += (a - self.default)
      i += 1
    i = 0
    for b in other:
      if b != other.default:
        newarray[i] += (-1)*(b - other.default) 
      i += 1
    return newarray

  def sparse_array_dict_eq(self, other):
    equal = True
    if self.default != other.default:
      equal = False
    elif len(self) != len(other):
      equal = False
    index = 0
    for e in self:
      if e != other[index]:
        equal = False
      index += 1
    return equal