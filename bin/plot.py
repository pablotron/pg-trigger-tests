#!/usr/bin/python3

#
# Generate plot of aggregate results of statement vs row trigger query
# timing comparison.
#
# Reads aggregate data from standard input and writes plot of results as
# SVG to standard output.
#

import csv
import sys
import matplotlib.pyplot as plt

#
# individual result
#
class Result:
  """individual result"""

  def __init__(self, row):
    """create result from row"""
    self.name = row['name']
    self.size = int(row['size'])
    self.mean = float(row['mean'])
    self.stddev = float(row['stddev'])

#
# data set
#
class Set:
  """data set"""

  def __init__(self, label, fmt, rows):
    self.label = label
    self.fmt = fmt
    self.rows = rows

  def plot(self):
    """plot data set"""
    plt.plot(
      [row.size for row in self.rows],
      [row.mean for row in self.rows],
      self.fmt,
      label = self.label,
    )

# read csv
rows = [Result(row) for row in csv.DictReader(sys.stdin)]

# init sets
sets = [Set(
  label = 'row-level trigger',
  fmt = 'ro-',
  rows = [row for row in rows if (row.name == 'slow')],
), Set(
  label = 'statement-level trigger',
  fmt = 'bs-',
  rows = [row for row in rows if (row.name == 'fast')],
)]

# plot sets
for s in sets:
  s.plot()

# configure plot
plt.xscale('log')
plt.yscale('log')
plt.xlabel('Row Count')
plt.ylabel('Query Time (ms)')
plt.title('Row Count vs Query Time')
plt.legend(loc='lower right')

# save image
plt.savefig(sys.stdout.buffer, format = 'svg')
