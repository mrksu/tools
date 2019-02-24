#!/usr/bin/env ruby

require 'asciidoctor'
require 'json'
require 'nokogiri'

# Experimental XML analyzer
class Nokogiri::XML::Node
  def to_h(*a)
    {"$name"=>name}.tap do |h|
      kids = children.to_a
      h.merge!(attributes)
      h.merge!("$text"=>text) unless text.empty?
      h.merge!("$kids"=>kids) unless kids.empty?
    end.to_h(*a)
  end
end
class Nokogiri::XML::Document
  def to_h(*a); root.to_h(*a); end
end
class Nokogiri::XML::Text
  def to_h(*a); text.to_h(*a); end
end
class Nokogiri::XML::Attr
  def to_h(*a); value.to_h(*a); end
end

# Convert all instance variables of an object to a hash;
# useful for the later conversion to JSON
def object_to_hash(o)
  h = o.instance_variables.each_with_object({}) {|var, hash| hash[var.to_s.delete("@")] = o.instance_variable_get(var)}

  # In the hash, resolve lists and add the converted DocBook representation of blocks
  if o.class == Asciidoctor::ListItem
      h["list_item_content"] = o.blocks.map {|b| object_to_hash(b)}
  elsif o.class == Asciidoctor::List
      h["list_content"] = o.items.map {|li| object_to_hash(li)}
  elsif o.class == Array
      h["array_content"] = o.map {|ai| object_to_hash(ai)}
  else
      h["docbook"] = o.convert
      # Add a field with deconstructed DocBook
      h["docbook_analyzed"] = Nokogiri::XML(o.convert).to_h
  end

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

