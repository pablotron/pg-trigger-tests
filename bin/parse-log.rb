#!/usr/bin/env ruby

#
# Parse trigger timing comparison log and from ARGF and write results to
# standard output in CSV format.
#
# The output format can be controlled by the OUTPUT_MODE environment
# variable:
#
# * mean: Write CSV name, row, count, mean, and standard deviation to
#   standard output.  This is the default mode.
#
# * raw: Write parsed raw results as CSV to standard output.
#

require 'csv'

# log parsing regex
SCAN_RE = /^(fast|slow),(\d+)\nINSERT 0 (?:\d+)\nTime: ([\d.]+) ms/m

class DataSet
  attr :name, :size, :vals

  def initialize(name, size)
    @name = name.freeze
    @size = size.freeze
    @vals = []
  end

  def <<(val)
    @vals << val
  end

  def mean
    @vals.reduce(0) { |r, v| r + v } / @vals.size.to_f
  end

  def stddev
    m = mean
    Math.sqrt(@vals.reduce(0) { |r, v| (m - v) ** 2 } / @vals.size.to_f)
  end
end

class DataSets
  def initialize
    @sets = {}
  end

  def add(name, size, val)
    key = "#{name}-#{size}"
    @sets[key] ||= DataSet.new(name, size)
    @sets[key] << val
  end

  def sets
    @sets.values
  end
end

# read data sets from input
ds = DataSets.new
ARGF.read.scan(SCAN_RE).to_a.each do |row|
  ds.add(row[0], row[1].to_i, row[2].to_f)
end

# switch on output mode
case mode = ENV.fetch('OUTPUT_MODE', 'mean')
when 'mean'
  # write aggregate results as csv
  CSV(STDOUT) do |csv|
    # write column headers
    csv << %w{name size mean stddev}

    ds.sets.each do |set|
      csv << [set.name, set.size, set.mean, set.stddev]
    end
  end
when 'raw'
  # write raw results as csv
  CSV(STDOUT) do |csv|
    # write column headers
    csv << %w{name size time_ms}

    ds.sets.each do |set|
      set.vals.each do |val|
        csv << [set.name, set.size, val]
      end
    end
  end
else
  raise "Unknown mode: #{mode}"
end
