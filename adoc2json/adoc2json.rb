#!/usr/bin/env ruby

require 'asciidoctor'
require 'json'

# Convert all instance variables of an object to a hash;
# useful for the later conversion to JSON
def object_to_hash(o)
  h = o.instance_variables.each_with_object({}) {|var, hash| hash[var.to_s.delete("@")] = o.instance_variable_get(var)}

  # In the hash, add the converted DocBook representation of the object
  h["docbook"] = o.convert
  return h
end

# Get the path to the input file from ARGV
in_file = ARGV[0]

# Let asciidoctor parse the input file, using DocBook as the target converter
doc = Asciidoctor.load_file in_file, attributes: {'backend' => 'docbook'}
parsed = doc.parse

# Convert the parsed object to a hash
hash = object_to_hash parsed

# Perform the same conversion with the "blocks" array;
# otherwise, we'd get just the most basic information about paragraphs
hash["blocks"].map! {|b| object_to_hash b}

# Output a pretty JSON
puts JSON.pretty_generate hash

